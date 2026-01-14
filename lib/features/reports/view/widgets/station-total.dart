import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class StationTotalReportTable extends BaseReportTable {
    final bool showMonthYear;


  const StationTotalReportTable({super.key, required super.controller, required this.showMonthYear});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم الفرع", Icons.business_outlined),
      col("اسم المحطة", Icons.location_city),
      col("كمية المياه", Icons.water_drop_outlined),
      col("الكهرباء", Icons.electric_bolt),
      col("الكلور", Icons.ac_unit),
      col("الشبة السائلة", Icons.opacity),
      col("الشبة الصلبة", Icons.ac_unit),
      if (showMonthYear) col("الشهر", Icons.calendar_month),
      if (showMonthYear) col("السنة", Icons.calendar_today),
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.branchs.map((b) {
      return DataRow(cells: [
        styledCell(b.branchName, Colors.blue),
        styledCell(b.stationname ?? "", Colors.green),
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
class StationTotalReportPrinter extends BaseReportPrinter {
  final bool showMonthYear;
  StationTotalReportPrinter({required this.showMonthYear});
  @override
  List<String> headers(String type) => [
        'اسم الفرع',
        'اسم المحطة',
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
        '<td class="highlight-cell">${b.stationname ?? ""}</td>',
        '<td>${formatNum(b.totalWater)}</td>',
        '<td>${formatNum(b.totalChlorine)}</td>',
        '<td>${formatNum(b.totalSolidAlum)}</td>',
        '<td>${formatNum(b.totalLiquidAlum)}</td>',
        '<td>${formatNum(b.totalPower)}</td>',
        if (showMonthYear) '<td>${b.month}</td>',
        if (showMonthYear) '<td>${b.year}</td>',
      ];
}