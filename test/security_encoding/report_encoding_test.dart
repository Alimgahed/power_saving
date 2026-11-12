import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/global/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html;
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/model/blance_model.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart';
import '../lifecycle/report_fixture.dart';

const payloads = [
  'نص عربي عادي ومحطة المياه',
  'North & South < West > East "quoted" \'single\'',
  '<b>literal bold</b>',
  '<script>alert("fixture")</script>',
  '</td></tr><img src=x onerror=alert(1)>',
  '<svg onload=alert(1)>',
  '&lt;script&gt;literal entity text&lt;/script&gt;',
  '&#60;img src=x onerror=alert(1)&#62;',
];
const types = [
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
WaterDataResponse balanceFixture(String text, String chart) =>
    WaterDataResponse.fromJson({
      'table': [],
      'chart': chart,
      'area_data': {
        'area_id': 1,
        'area_name': text,
        'stations': [
          {
            'station_id': 1,
            'station_name': text,
            'station_type': text,
            'station_water_capacity': 10,
          },
        ],
        'places': [
          {
            'area_id': 1,
            'area_name': text,
            'branch_id': 1,
            'branch_name': text,
            'place_id': 1,
            'place_name': text,
            'place_type_id': 1,
            'place_type_name': text,
            'populations': [],
          },
        ],
      },
    });
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => Get.reset());
  for (final type in types) {
    test('$type encodes all scalar text without changing cells', () {
      final printer = ReportPrinterFactory.forType(type);
      for (final payload in payloads) {
        final data = reportRow(1);
        for (final key in [
          'branch_name',
          'station_name',
          'station_names',
          'technology_name',
          'account_number',
          'percent',
          'status',
        ]) {
          data[key] = payload;
        }
        final row = ReportBranch.fromJson(data);
        final cells = printer.rowCells(row, type);
        final doc = html.parse(
          '<table><tbody><tr>${cells.join()}</tr></tbody></table>',
        );
        expect(
          doc.querySelectorAll('script,img,svg,iframe,[onerror],[onload]'),
          isEmpty,
          reason: payload,
        );
        expect(doc.querySelectorAll('tbody tr'), hasLength(1));
        expect(doc.querySelectorAll('td'), hasLength(cells.length));
        expect(
          doc.querySelectorAll('td').map((e) => e.text),
          contains(payload),
          reason: payload,
        );
      }
    });
  }
  test('planning text remains literal throughout complete generated HTML', () {
    final controller = BalanceChartController();
    final dynamic state = const BalanceChartPrintScreen().createState();
    for (final payload in payloads) {
      controller.balanceData.value = balanceFixture(payload, '');
      final doc = html.parse(
        state.generateEnhancedPrintHtml(controller) as String,
      );
      expect(
        doc.querySelectorAll('script,svg,iframe,[onerror],[onload]'),
        isEmpty,
        reason: payload,
      );
      expect(doc.querySelector('.area-info .value')!.text, payload);
      final cells = doc.querySelectorAll('td').map((e) => e.text).toList();
      expect(cells.where((value) => value == payload), hasLength(6));
      expect(doc.querySelectorAll('.stations-table tbody tr'), hasLength(1));
      expect(doc.querySelectorAll('.places-table tbody tr'), hasLength(1));
    }
    controller.onClose();
  });
  test('planning chart attribute cannot escape its fixed image source', () {
    final controller = BalanceChartController();
    final dynamic state = const BalanceChartPrintScreen().createState();
    for (final chart in [
      'iVBORw0KGgoAAAANSUhEUg==',
      'x" onerror="alert(1)',
      'x"><script>alert(1)</script><img src="x',
      '&quot; onload=alert(1)',
    ]) {
      controller.balanceData.value = balanceFixture('منطقة', chart);
      final doc = html.parse(
        state.generateEnhancedPrintHtml(controller) as String,
      );
      expect(doc.querySelectorAll('img'), hasLength(1));
      expect(doc.querySelectorAll('script,[onerror],[onload]'), isEmpty);
      expect(
        doc.querySelector('img')!.attributes['src'],
        'data:image/png;base64,$chart',
      );
    }
    controller.onClose();
  });
  test(
    'complete report metadata stays literal and UX-05 count stays unchanged',
    () {
      Get.put(SessionService());
      final c = ReportsController()..onInit();
      c.reportname = 'branch_total';
      c.branchs = [
        ReportBranch.fromJson(reportRow(0)),
        ReportBranch.fromJson(reportRow(1)),
      ];
      c.filteredBranchs.assignAll([c.branchs.first]);
      for (final payload in payloads) {
        c.startdate.text = payload;
        c.enddate.text = payload;
        user = User(
          empCode: '1',
          empName: payload,
          groupId: 2,
          isActive: true,
          username: 'fixture',
        );
        final doc = html.parse(
          ReportPrinterFactory.forType('branch_total').buildHtml(c),
        );
        expect(
          doc.querySelectorAll('script,svg,img,iframe,[onerror],[onload]'),
          isEmpty,
        );
        expect(doc.querySelectorAll('.info-value')[1].text, '2');
        expect(doc.querySelectorAll('tbody tr'), hasLength(1));
        expect(
          doc.querySelectorAll('.info-value')[2].text,
          '$payload - $payload',
        );
        expect(doc.querySelector('.footer')!.text, contains(payload));
        expect(doc.querySelectorAll('[onclick]'), hasLength(1));
        expect(
          doc.querySelector('[onclick]')!.attributes['onclick'],
          'window.print()',
        );
      }
      user = null;
      expect(
        html
            .parse(ReportPrinterFactory.forType('branch_total').buildHtml(c))
            .querySelector('.footer')!
            .text,
        contains('null'),
      );
      c.onClose();
    },
  );
}
