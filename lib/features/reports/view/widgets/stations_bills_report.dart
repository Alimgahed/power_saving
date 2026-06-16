import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class StationBillsReportTable extends BaseReportTable {
  const StationBillsReportTable({super.key, required super.controller});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم المحطة", Icons.electrical_services),
      col("قيمة المطالبة", Icons.monetization_on),
      col("الشهر", Icons.calendar_month),
      col("السنة", Icons.date_range),
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.filteredBranchs.map((b) {
      return DataRow(cells: [
        styledCell(b.stationname ?? "", Colors.green),
        styledCell(numFmt(b.totalBill), Colors.orange),
        dataCell('${b.month}'),
        dataCell('${b.year}'),
      ]);
    }).toList();
  }
}
class StationBillsReportPrinter extends BaseReportPrinter {
  @override
  List<String> headers(String type) => ['اسم المحطة', 'قيمة المطالبة', 'الشهر', 'السنة'];

  @override
  List<String> rowCells(ReportBranch b, String type) => [
        '<td class="highlight-cell">${b.stationname}</td>',
        '<td class="highlight-cell">${formatNum(b.totalBill)}</td>',
        '<td>${b.month}</td>',
        '<td>${b.year}</td>',
      ];
}