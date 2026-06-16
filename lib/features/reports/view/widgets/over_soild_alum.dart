
import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
class OverSolidAlumReport  extends BaseReportTable {
  const OverSolidAlumReport({super.key, required super.controller, });

  @override
  List<DataColumn> buildColumns() {
    return [
      col("اسم الفرع", Icons.business_outlined),
      col("اسم المحطة", Icons.location_city),
      col("اسم التكنولوجيا", Icons.memory),
      col("كمية المياه", Icons.water_drop_outlined),
      col("الشبة الصلبة", Icons.water),
      col("الشهر", Icons.calendar_month),
      col("السنة", Icons.calendar_today),
      col("القيمة العظمى القياسية", Icons.water_damage_outlined),
            col("القيمة الصغرى القياسية", Icons.water_damage_outlined),
                        col(" القيمة الفعلية", Icons.percent_rounded),
      col("الحالة", Icons.percent_rounded),
    ];
  }

  @override
  List<DataRow> buildRows() {
    return controller.filteredBranchs.map((b) {
      return DataRow(cells: [
        styledCell(b.branchName, Colors.blue),
        styledCell(b.stationname ?? "", Colors.green),
        dataCell(b.techname ?? ""),
        dataCell('${b.wateramount?.toStringAsFixed(1)} م³'),
          dataCell('${b.soildalum?.toStringAsFixed(1)} جرام / م³'),
         dataCell('${b.month}'),
         dataCell('${b.year}'),
          dataCell('${b.maxratio?.toStringAsFixed(1)} جرام / م³'),
            dataCell('${b.minratio?.toStringAsFixed(1)} جرام / م³'),
         dataCell('${b.actialratio?.toStringAsFixed(1)}%'),
         dataCell(b.statues ?? ""),
      ]);
    }).toList();
  }
}
class OverSolidAlumReportPrinter extends BaseReportPrinter {
  OverSolidAlumReportPrinter();
  @override
  List<String> headers(String type) => [
        'اسم الفرع',
        'اسم المحطة',
        'اسم التكونولوجيا',
        'كمية المياه',
        'الشبة الصلبة',
         'الشهر',
       'السنة',
      'القيمة العظمى القياسية',
      'القيمة الصغرى القياسية',
      ' القيمة الفعلية',
      'الحالة',
      ];

  @override
  List<String> rowCells(ReportBranch b, String type) => [
        '<td class="highlight-cell">${b.branchName}</td>',
        '<td class="highlight-cell">${b.stationname ?? ""}</td>',
        '<td>${b.techname ?? ""}</td>',
        '<td>${formatNum(b.wateramount)}</td>',
        '<td>${formatNum(b.soildalum)}</td>',
        '<td>${b.month}</td>',
         '<td>${b.year}</td>',
      '<td>${b.maxratio?.toStringAsFixed(1)} جرام / م³</td>',
      '<td>${b.minratio?.toStringAsFixed(1)} جرام / م³</td>',
      '<td>${b.actialratio?.toStringAsFixed(1)}%</td>',
      '<td>${b.statues ?? ""}</td>'
      ];
}