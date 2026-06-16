import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class BranchReportTable extends BaseReportTable {
  final bool showMonthYear;
  const BranchReportTable({super.key, required super.controller, required this.showMonthYear});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم الفرع", Icons.business_outlined),
      col("قيمة المطالبة", Icons.monetization_on),
      col("كمية المياه", Icons.water_drop_outlined),
      col("الكلور", Icons.science),
      col("الشبة الصلبة", Icons.ac_unit),
      col("الشبة السائلة", Icons.opacity),
      col("الكهرباء", Icons.electric_bolt),
      if (showMonthYear) col("الشهر", Icons.calendar_month),
      if (showMonthYear) col("السنة", Icons.date_range),
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.filteredBranchs.map((b) {
      return DataRow(cells: [
        styledCell(b.branchName, Colors.blue),
        styledCell(numFmt(b.totalBill), Colors.orange),
        dataCell('${b.totalWater.toStringAsFixed(1)} م³'),
        dataCell('${b.totalChlorine.toStringAsFixed(1)} جرام'),
        dataCell('${b.totalSolidAlum.toStringAsFixed(1)} جرام'),
        dataCell('${b.totalLiquidAlum.toStringAsFixed(1)} جرام'),
        dataCell('${b.totalPower.toStringAsFixed(1)} واط'),
        if (showMonthYear) dataCell('${b.month}'),
        if (showMonthYear) dataCell('${b.year}'),
      ]);
    }).toList();
  }
}
class BranchReportPrinter extends BaseReportPrinter {
  final bool showMonthYear;
  BranchReportPrinter({required this.showMonthYear});

  @override
  List<String> headers(String type) => [
        'اسم الفرع',
        'قيمة المطالبة',
        'كمية المياه',
        'الكلور',
        'الشبة الصلبة',
        'الشبة السائلة',
        'الكهرباء',
        if (showMonthYear) 'الشهر',
        if (showMonthYear) 'السنة',
      ];

  @override
  List<String> rowCells(ReportBranch b, String type) => [
        '<td class="highlight-cell">${b.branchName}</td>',
        '<td class="highlight-cell">${formatNum(b.totalBill)}</td>',
        '<td>${formatNum(b.totalWater)}</td>',
        '<td>${formatNum(b.totalChlorine)}</td>',
        '<td>${formatNum(b.totalSolidAlum)}</td>',
        '<td>${formatNum(b.totalLiquidAlum)}</td>',
        '<td>${formatNum(b.totalPower)}</td>',
        if (showMonthYear) '<td>${b.month}</td>',
        if (showMonthYear) '<td>${b.year}</td>',
      ];
}