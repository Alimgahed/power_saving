import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/technology/controller/edit_tech_controller.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/features/tech_bills/controller/new_tech_bills.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import '../state_management/fixtures.dart';
import 'report_fixture.dart';
import 'package:power_saving/global/ip_config.dart';

class CountingReports extends ReportsController {
  int filters = 0;
  @override
  void applyFilters() {
    filters++;
    super.applyFilters();
  }
}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({'token': 'fixture'});
    await Cache.init();
    Get.put(SessionService());
  });
  tearDown(() => Get.reset());
  test(
    'technology edit disposes all five exclusively owned text controllers',
    () {
      final c = EditTechController()..onInit();
      final fields = [c.name, c.chlorine, c.liquid, c.solid, c.power];
      c.onClose();
      for (final field in fields) {
        expect(() => field.addListener(() {}), throwsFlutterError);
      }
    },
  );
  testWidgets(
    'new bill preserves produced-water calculation and releases all eight fields/listeners',
    (tester) async {
      final c = NewTechBillsController();
      final net = PendingHttp();
      await tester.runAsync(
        () => http.runWithClient(() async {
          c.onInit();
          await net.started(1);
          net.finish(0, []);
          await Future<void>.delayed(Duration.zero);
          c.measuredWaterController.text = '1.25';
          c.calculatedWaterController.text = '2.5';
          expect(c.waterProducedController.text, '3.75');
          final fields = [
            c.chlorineController,
            c.liquidAlumController,
            c.solidAlumController,
            c.waterProducedController,
            c.yearController,
            c.monthController,
            c.calculatedWaterController,
            c.measuredWaterController,
          ];
          c.onClose();
          for (final field in fields) {
            expect(() => field.addListener(() {}), throwsFlutterError);
          }
        }, () => net.client),
      );
    },
  );
  testWidgets(
    'report filter subscription and pending debounce stop on disposal',
    (tester) async {
      final c = CountingReports()..onInit();
      c.searchController.text = 'pending';
      c.onClose();
      final count = c.filters;
      c.selectedFilterBranch.value = 'changed after close';
      await tester.pump(const Duration(milliseconds: 400));
      expect(c.filters, count);
    },
  );
  testWidgets(
    'report scroll controllers survive rebuilds and are disposed on screen removal',
    (tester) async {
      tester.view.resetPhysicalSize();
      tester.view.physicalSize = const Size(1600, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = Get.put(ReportsController());
      c.reportname = 'branch_per_month';
      c.branchs = List.generate(40, (i) => ReportBranch.fromJson(reportRow(i)));
      c.applyFilters();
      await tester.pumpWidget(GetMaterialApp(home: Reports()));
      await tester.pumpAndSettle();
      List<ScrollController> owned() =>
          tester
              .widgetList<Scrollbar>(find.byType(Scrollbar))
              .map((w) => w.controller)
              .whereType<ScrollController>()
              .toList();
      final initial = owned();
      expect(initial, hasLength(2));
      initial.first.jumpTo(100);
      await tester.pump();
      final identities = Set<ScrollController>.identity()..addAll(initial);
      for (var i = 0; i < 10; i++) {
        c.filteredBranchs.refresh();
        await tester.pump();
        identities.addAll(owned());
      }
      // ignore: avoid_print
      print(
        'report scroll controllers across initial build + 10 rebuilds: ${identities.length}',
      );
      expect(owned()[0], same(initial[0]));
      expect(owned()[1], same(initial[1]));
      expect(initial.first.offset, 100);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      for (final field in initial) {
        expect(() => field.addListener(() {}), throwsFlutterError);
      }
    },
  );
  testWidgets('report search retains 300ms debounce and active filters', (
    tester,
  ) async {
    final c = CountingReports()..onInit();
    c.branchs = List.generate(4, (i) => ReportBranch.fromJson(reportRow(i)));
    c.searchController.text = 'Station 1';
    await tester.pump(const Duration(milliseconds: 299));
    expect(c.filters, 0);
    await tester.pump(const Duration(milliseconds: 1));
    expect(c.filters, 1);
    expect(c.filteredBranchs.map((r) => r.accountnumber), ['A1']);
    expect(c.isSearching.value, false);
    c.onClose();
  });
  for (final kind in ['report', 'edit', 'new-read', 'new-save']) {
    testWidgets('$kind ignores completion after owning controller closes', (
      tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const Scaffold()));
      final net = PendingHttp();
      await tester.runAsync(
        () => http.runWithClient(() async {
          if (kind == 'report') {
            final c = ReportsController()..onInit();
            final pending = c.getReports(
              start: '2026-01-01',
              end: '2026-02-01',
              name: 'branch_total',
            );
            await net.started(1);
            expect(
              net.requests.single.url.toString(),
              '${ApiConfig.baseUrl}/reports',
            );
            expect(net.requests.single.method, 'POST');
            expect(jsonDecode(net.requests.single.body), {
              'report_name': 'branch_total',
              'from_date': '2026-01-01',
              'to_date': '2026-02-01',
            });
            c.onClose();
            net.finish(0, [reportRow(1)]);
            await pending;
            expect(c.branchs, isEmpty);
          } else if (kind == 'edit') {
            final c = EditTechController()..onInit();
            final pending = c.edittech(
              id: 7,
              tech: TechnologyModel(
                technologyName: 'T',
                main_type: 'ثابت',
                powerPerWater: 1.25,
              ),
            );
            await net.started(1);
            expect(
              net.requests.single.url.toString(),
              '${ApiConfig.baseUrl}/edit-tech/7',
            );
            expect(net.requests.single.method, 'POST');
            expect(jsonDecode(net.requests.single.body), {
              'technology_main_type': 'ثابت',
              'power_per_water': 1.25,
              'technology_id': null,
              'technology_name': 'T',
            });
            c.onClose();
            net.finish(0, {});
            await pending;
          } else {
            final c = NewTechBillsController()..onInit();
            await net.started(1);
            expect(
              net.requests.single.url.toString(),
              '${ApiConfig.baseUrl}/station-techs',
            );
            expect(net.requests.single.method, 'GET');
            expect(net.requests.single.body, isEmpty);
            if (kind == 'new-read') {
              c.onClose();
              net.finish(0, [
                {
                  'station_id': 7,
                  'station_name': 'S',
                  'station_type': 'T',
                  'station_water_capacity': 10,
                  'branch_name': 'B',
                  'water_source_name': 'W',
                  'techs': [],
                },
              ]);
              await Future<void>.delayed(Duration.zero);
              expect(c.stations, isEmpty);
            } else {
              net.finish(0, []);
              await Future<void>.delayed(Duration.zero);
              c.monthController.text = '3';
              c.yearController.text = '2026';
              c.addTechBills(
                staionid: 7,
                techid: 9,
                chlorine: 1,
                liquid: 2,
                solid: 3,
                water: 4,
                index: 0,
                measuredWater: 1,
                calculatedWater: 3,
              );
              await net.started(2);
              expect(
                net.requests.last.url.toString(),
                '${ApiConfig.baseUrl}/insert-or-edit-tech-bill',
              );
              expect(net.requests.last.method, 'POST');
              expect(jsonDecode(net.requests.last.body), {
                'technology_chlorine_consump': 1.0,
                'technology_liquid_alum_consump': 2.0,
                'technology_solid_alum_consump': 3.0,
                'technology_water_amount': 4.0,
                'measured_water': 1.0,
                'calculated_water': 3.0,
                'station_id': 7,
                'technology_id': 9,
                'bill_month': 3,
                'bill_year': 2026,
              });
              c.onClose();
              net.finish(1, {});
              await Future<void>.delayed(Duration.zero);
            }
          }
          expect(Get.isDialogOpen, isNot(true));
        }, () => net.client),
      );
      await tester.pumpAndSettle();
    });
  }
}
