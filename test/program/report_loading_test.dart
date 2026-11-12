import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import '../lifecycle/report_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({'token': 'fixture'});
    await Cache.init();
  });
  tearDown(() => Get.reset());
  for (final size in [100, 1000, 10000]) {
    test(
      'report fetch preserves $size rows, totals, ordering and request',
      () async {
        final body = jsonEncode(List.generate(size, reportRow));
        final times = <int>[];
        for (var run = 0; run < 4; run++) {
          final c = ReportsController()..onInit();
          final client = MockClient((r) async {
            expect(r.method, 'POST');
            expect(r.url.path, '/reports');
            expect(jsonDecode(r.body), {
              'report_name': 'branch_total',
              'from_date': '2026-01-01',
              'to_date': '2026-12-31',
            });
            return http.Response(
              body,
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          });
          final watch = Stopwatch()..start();
          await http.runWithClient(
            () => c.getReports(
              start: '2026-01-01',
              end: '2026-12-31',
              name: 'branch_total',
            ),
            () => client,
          );
          watch.stop();
          if (run > 0) times.add(watch.elapsedMicroseconds);
          expect(c.branchs.length, size);
          expect(
            c.filteredBranchs.map((r) => r.accountnumber),
            List.generate(size, (i) => 'A$i'),
          );
          expect(
            c.moneysum,
            c.branchs.fold<double>(0, (sum, r) => sum + r.totalBill),
          );
          expect(
            c.watersum,
            c.branchs.fold<double>(0, (sum, r) => sum + r.totalWater),
          );
          expect(c.isLoading.value, false);
          c.onClose();
          client.close();
        }
        times.sort();
        // ignore: avoid_print
        print(
          jsonEncode({
            'rows': size,
            'payload_bytes': utf8.encode(body).length,
            'median_fetch_parse_index_us': times[1],
          }),
        );
      },
    );
  }
}
