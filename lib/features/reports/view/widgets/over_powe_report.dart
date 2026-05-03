import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
class OverPoweReport extends BaseReportTable {
  const OverPoweReport({super.key, required super.controller, });

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم الفرع", Icons.business_outlined),
      col("اسم المحطة", Icons.location_city),
      col("اسم التكنولوجيا", Icons.memory),
      col("كمية المياه", Icons.water_drop_outlined),
      col("الكهرباء", Icons.electric_bolt),
      col("الشهر", Icons.calendar_month),
      col("السنة", Icons.calendar_today),
      col("الرقم المرجعي القياسي", Icons.electric_bolt_rounded),
            col("الرقم المرجعي الفعلي", Icons.electric_bolt_rounded),
                        col("نسبة التجاوز", Icons.percent_rounded),
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
          dataCell('${b.expected?.toStringAsFixed(1)} واط'),
            dataCell('${b.actualratio?.toStringAsFixed(1)} واط'),
         dataCell('${b.excesspercentage?.toStringAsFixed(1)}%'),
      ]);
    }).toList();
  }
}
class OverPowerReportPrinter extends BaseReportPrinter {
  OverPowerReportPrinter();
  @override
  List<String> headers(String type) => [
        'اسم الفرع',
        'اسم المحطة',
        'اسم التكونولوجيا',
        'كمية المياه',
        'الكهرباء',
         'الشهر',
       'السنة',
      'الرقم المرجعي القياسي',
      'الرقم المرجعي الفعلي',
      'نسبة التجاوز',
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
      '<td>${b.expected?.toStringAsFixed(1)} ك واط/م³</td>',
      '<td>${b.actualratio?.toStringAsFixed(1)} ك واط/م³</td>',
      '<td>${b.excesspercentage?.toStringAsFixed(1)}%</td>'
      ];
}