
import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
class PowerZeroWaterReport extends BaseReportTable {
  const PowerZeroWaterReport({super.key, required super.controller, });

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم الفرع", Icons.business_outlined),
      col("اسم المحطة", Icons.location_city),
      col("اسم التكنولوجيا", Icons.memory),
      col("كمية المياه", Icons.water_drop_outlined),
      col("الكهرباء", Icons.electric_bolt_outlined),
      col("الشهر", Icons.calendar_month),
      col("السنة", Icons.calendar_today),
     
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.branchs.map((b) {
      return DataRow(cells: [
        styledCell(b.branchName, Colors.blue),
        styledCell(b.stationname ?? "", Colors.green),
        dataCell(b.techname ?? ""),
        dataCell('${b.wateramount?.toStringAsFixed(1)} م³'),
          dataCell('${b.powerconsump?.toStringAsFixed(1)} واط'),
         dataCell('${b.month}'),
         dataCell('${b.year}'),
   
      ]);
    }).toList();
  }
}
class PowerZeroWaterReportPrinter extends BaseReportPrinter {
  PowerZeroWaterReportPrinter();
  @override
  List<String> headers(String type) => [
        'اسم الفرع',
        'اسم المحطة',
        'اسم التكونولوجيا',
        'كمية المياه',
        'الكهرباء',
         'الشهر',
       'السنة',
    
      ];

  @override
  List<String> rowCells(ReportBranch b, String type) => [
        '<td class="highlight-cell">${b.branchName}</td>',
        '<td class="highlight-cell">${b.stationname ?? ""}</td>',
        '<td>${b.techname ?? ""}</td>',
        '<td>${formatNum(b.wateramount)}</td>',
        '<td>${formatNum(b.powerconsump)}</td>',
        '<td>${b.month}</td>',
         '<td>${b.year}</td>',
      ];
}