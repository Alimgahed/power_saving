import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import 'package:power_saving/features/reports/view/widgets/branch_report.dart';
import 'report_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => Get.reset());
  test(
    'all report printer content and filter ordering match pre-change golden',
    () {
      final c = ReportsController()..onInit();
      c.branchs = List.generate(6, (i) => ReportBranch.fromJson(reportRow(i)));
      final snapshots = <String, dynamic>{};
      final types = [
        'branch_per_month',
        'branch_total',
        'technology_per_month',
        'technology_total',
        'station-bills',
        'bills',
        'water-techs-3-month',
        'sanity-techs-3-month',
        'station_total',
        'station_per_month',
        'over_power_consumption',
        'over_chlorine_consumption',
        'over_solid_alum_consumption',
        'over_liquid_alum_consumption',
        'power_for_zero_water',
      ];
      for (final scenario in [
        'all',
        'branch',
        'station',
        'month',
        'year',
        'tech',
        'paid',
        'search',
      ]) {
        c.clearSearch();
        switch (scenario) {
          case 'branch':
            c.selectedFilterBranch.value = 'الفرع أ';
          case 'station':
            c.selectedFilterStation.value = 'Shared';
          case 'month':
            c.selectedFilterMonth.value = '2';
          case 'year':
            c.selectedFilterYear.value = '2026';
          case 'tech':
            c.selectedFilterTech.value = 'Tech 1';
          case 'paid':
            c.selectedFilterIsPaid.value = 'نعم';
          case 'search':
            c.searchQuery.value = 'Station 3';
        }
        c.applyFilters();
        snapshots[scenario] = {
          'order': c.filteredBranchs.map((e) => e.accountnumber).toList(),
          'totals': [c.watersum, c.powersum, c.moneysum],
          'reports': {
            for (final type in types)
              type:
                  (() {
                    final p = ReportPrinterFactory.forType(type);
                    return {
                      'title': p.title(type),
                      'headers': p.headers(type),
                      'rows':
                          c.filteredBranchs
                              .map((b) => p.rowCells(b, type))
                              .toList(),
                      'summary': p.summaryHtml(c, type),
                    };
                  })(),
          },
        };
      }
      final golden = File('test/lifecycle/fixtures/report_output.json');
      if (const bool.fromEnvironment('CAPTURE_REPORT_GOLDEN')) {
        golden.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(snapshots),
        );
      } else {
        expect(snapshots, jsonDecode(golden.readAsStringSync()));
      }
      c.onClose();
    },
  );
  for (final size in [100, 1000, 10000]) {
    test('read-only report baseline $size rows retains every row', () {
      final raw = jsonEncode(List.generate(size, reportRow));
      final measurements = <Map<String, int>>[];
      for (var run = 0; run < 4; run++) {
        final c = ReportsController()..onInit();
        final watch = Stopwatch()..start();
        c.branchs =
            (jsonDecode(raw) as List)
                .map((e) => ReportBranch.fromJson(e))
                .toList();
        final parsing = watch.elapsedMicroseconds;
        watch.reset();
        c.applyFilters();
        final filtering = watch.elapsedMicroseconds;
        watch.reset();
        final rows =
            BranchReportTable(controller: c, showMonthYear: true).buildRows();
        final rowBuilding = watch.elapsedMicroseconds;
        watch.reset();
        final printer = BranchReportPrinter(showMonthYear: true);
        final html =
            c.filteredBranchs
                .map(
                  (b) =>
                      '<tr>${printer.rowCells(b, 'branch_per_month').join()}</tr>',
                )
                .join();
        final htmlTime = watch.elapsedMicroseconds;
        watch.stop();
        expect(rows.length, size);
        expect(RegExp('<tr>').allMatches(html).length, size);
        if (run > 0) {
          measurements.add({
            'parse_us': parsing,
            'filter_us': filtering,
            'rows_us': rowBuilding,
            'html_us': htmlTime,
          });
        }
        c.onClose();
      }
      final medians = {
        for (final key in measurements.first.keys)
          key: (measurements.map((m) => m[key]!).toList()..sort())[1],
      };
      // Diagnostic timings, not a machine-dependent performance threshold.
      // ignore: avoid_print
      print(
        jsonEncode({
          'rows': size,
          'json_bytes': utf8.encode(raw).length,
          'median': medians,
        }),
      );
    });
  }
}
