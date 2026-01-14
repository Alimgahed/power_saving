
import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class TechnologyReportTable extends BaseReportTable {
  final bool showMonthYear;
  const TechnologyReportTable({super.key, required super.controller, required this.showMonthYear});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("التكنولوجيا", Icons.precision_manufacturing),
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
    return controller.branchs.map((b) {
      return DataRow(cells: [
        styledCell(b.techname ?? "", Colors.purple),
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

class TechnologyReportPrinter extends BaseReportPrinter {
  final bool showMonthYear;
  TechnologyReportPrinter({required this.showMonthYear});

  @override
  List<String> headers(String type) => [
        'التكنولوجيا',
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
        '<td class="highlight-cell">${b.techname}</td>',
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
