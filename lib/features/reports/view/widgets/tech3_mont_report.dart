import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class Techs3MonthReportTable extends BaseReportTable {
  const Techs3MonthReportTable({super.key, required super.controller});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("التكنولوجيا", Icons.precision_manufacturing),
      col("قيمة المطالبة", Icons.monetization_on),
      col("المياه", Icons.water_drop_outlined),
      col("الكهرباء", Icons.electric_bolt),
      col("النسبة", Icons.percent_outlined),
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.branchs.map((b) {
      return DataRow(cells: [
        styledCell(b.techname ?? "", Colors.purple),
        styledCell(numFmt(b.totalBill), Colors.orange),
        dataCell('${b.totalWater}'),
        dataCell('${b.totalPower}'),
        dataCell('${b.precent}'),
      ]);
    }).toList();
  }
}
class Techs3MonthReportPrinter extends BaseReportPrinter {
  @override
  List<String> headers(String type) => ['التكنولوجيا', 'قيمة المطالبة', 'كمية المياه', 'كمية الكهرباء', 'النسبة'];

  @override
  List<String> rowCells(ReportBranch b, String type) => [
        '<td class="highlight-cell">${b.techname}</td>',
        '<td class="highlight-cell">${formatNum(b.totalBill)}</td>',
        '<td>${formatNum(b.totalWater)}</td>',
        '<td>${formatNum(b.totalPower)}</td>',
        '<td>${b.precent}</td>',
      ];

  @override
  String? summaryHtml(ReportsController controller, String type) {
    double totalPower = 0.0, totalMoney = 0.0, totalWater = 0.0;
    for (var b in controller.branchs) {
      totalPower += double.tryParse(b.totalPower.toString()) ?? 0.0;
      totalMoney += double.tryParse(b.totalBill.toString()) ?? 0.0;
      totalWater += double.tryParse(b.totalWater.toString()) ?? 0.0;
    }
    final ratio = totalMoney != 0 ? totalMoney / totalPower : 0.0;
    return '''
<tr class="summary-row">
  <td>جملة تشغيل الكهرباء</td>
  <td>${formatNum(totalMoney)}</td>
  <td>${formatNum(totalWater)}</td>
  <td>${formatNum(totalPower)}</td>
  <td>${formatNum(ratio)}</td>
</tr>
<tr class="summary-row">
  <td>جملة الإنارة</td><td></td><td></td><td></td><td></td>
</tr>
<tr class="summary-row">
  <td>جملة الكهرباء</td><td></td><td></td><td></td><td></td>
</tr>
''';
  }
}