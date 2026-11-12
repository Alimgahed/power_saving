import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/global/ip_config.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';
import 'package:power_saving/features/bill/controller/tech_bills.dart';
import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({'token': 'synthetic-token'});
    await Cache.init();
  });
  test(
    'planning preserves established request keys and numerical values',
    () async {
      final c = BalanceChartController();
      addTearDown(c.onClose);
      await http.runWithClient(
        () => c.allvalues(),
        () => MockClient((r) async {
          expect(r.method, 'GET');
          expect(r.url.toString(), '${ApiConfig.baseUrl}/place-types');
          expect(r.headers['Authorization'], 'Bearer synthetic-token');
          return jsonResponse([placeType(4)]);
        }),
      );
      c.selectedMethod.value = 'ministry';
      c.yearController.text = '2035';
      c.incresableController.text = '2';
      c.textControllers[4]!.text = '30';
      c.toggleIsFuture(true);
      c.futureCapacities.single.yearController.text = '2030';
      c.futureCapacities.single.productionController.text = '12.5';
      expect(c.buildRequestBody(), {
        'calc_type': 'ministry',
        'is_modified': true,
        'increasable': 2,
        'goal_year': 2035,
        'is_future': true,
        'future_years_capacity': [
          {'future_year': 2030, 'future_production': 12.5},
        ],
        '4': 30,
      });
    },
  );
  test(
    'operational bills retain fields and existing filter behavior',
    () async {
      final c = Techbills();
      addTearDown(c.onClose);
      await http.runWithClient(
        () => c.fetchTechBills(),
        () => MockClient((r) async {
          expect(r.method, 'GET');
          expect(r.url.toString(), '${ApiConfig.baseUrl}/tech-bills');
          return jsonResponse([techBill(11), techBill(22, branch: 'South')]);
        }),
      );
      c.filterByBranch('South');
      expect(c.filteredTechBills.single.techBillId, 22);
      c.clearFilters();
      expect(c.filteredTechBills.length, 2);
      final draft = c.getChlorineController(11);
      draft.text = '1.25';
      expect(identical(draft, c.getChlorineController(11)), isTrue);
      expect(c.getChlorineController(11).text, '1.25');
      expect(c.techBills.first.technologyBillTotal, '25.50');
    },
  );
  test('meter history request and page totals remain unchanged', () async {
    final c = AllBills();
    addTearDown(c.onClose);
    c.currentPage.value = 2;
    c.selectedYear = '2026';
    c.selectedMonth = '3';
    c.selectedFilter = 'paid';
    c.selectedAccountNumber = 'A / B';
    c.onSearchChanged(' station ');
    await http.runWithClient(
      () => c.allbills(),
      () => MockClient((r) async {
        expect(r.url.path, '/view-bills');
        expect(r.method, 'GET');
        expect(r.url.queryParameters, {
          'page': '2',
          'per_page': '20',
          'bill_year': '2026',
          'bill_month': '3',
          'is_paid': 'true',
          'account_number': 'A / B',
          'search': 'station',
        });
        expect(
          r.headers,
          containsPair('Authorization', 'Bearer synthetic-token'),
        );
        expect(r.headers, containsPair('Content-Type', 'application/json'));
        expect(r.headers.containsKey('Accept'), isFalse);
        return jsonResponse(page([meterBill(7)], 2));
      }),
    );
    expect(c.currentPage.value, 2);
    expect(c.hasPrev.value, isTrue);
    expect(c.getTotalBillAmount(), 25.5);
    expect(c.getTotalPowerConsumption(), 12);
  });
  test(
    'technology history retains untrimmed search and page response mapping',
    () async {
      final c = TechBillscontroller();
      // Old implementation has no owned resources until onInit.
      addTearDown(c.onClose);
      c.currentPage = 2;
      c.selectedYear = '2026';
      c.selectedMonth = '3';
      c.searchQuery.value = ' water ';
      await http.runWithClient(
        () => c.allbills(),
        () => MockClient((r) async {
          expect(r.method, 'GET');
          expect(r.url.path, '/view-tech-bills');
          expect(r.url.queryParameters, {
            'page': '2',
            'per_page': '20',
            'bill_year': '2026',
            'bill_month': '3',
            'search': ' water ',
          });
          return jsonResponse(page([techBill(9)], 2));
        }),
      );
      expect(c.currentPage, 2);
      expect(c.hasPrev, isTrue);
      expect(c.getTotalWaterAmount(), 8);
      expect(c.getTotalBillAmount(), 25.5);
    },
  );
}
