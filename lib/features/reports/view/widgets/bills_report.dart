import 'package:flutter/material.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';

class BillsReportTable extends BaseReportTable {
  const BillsReportTable({super.key, required super.controller});

  @override
  List<DataColumn> buildColumns() {
    return [
      col("رقم الاشتراك", Icons.numbers),
      col("قيمة المطالبة", Icons.monetization_on),
      col("الشهر", Icons.calendar_month),
      col("السنة", Icons.date_range),
      col("المحطات", Icons.location_on_outlined),
      col("مسدد", Icons.monetization_on_outlined),
      col("شهر الترحيل", Icons.calendar_month),
      col("سنة الترحيل", Icons.date_range),
    ];
  }
  
  
  @override
  List<DataRow> buildRows() {
    return controller.branchs.map((b) {
      return DataRow(cells: [
        styledCell(b.accountnumber ?? "", Colors.blueAccent),
        styledCell(numFmt(b.totalBill), Colors.orange),
        dataCell('${b.month}'),
        dataCell('${b.year}'),
        styledCell(b.station ?? "", Colors.blueAccent),
        dataCell(b.ispaid == true ? "نعم" : "لا"),
        dataCell('${b.delleymonth ?? "لايوجد"}'),
        dataCell('${b.delleyyear ?? "لايوجد"}'),
      ]);
    }).toList();
  }
}
class BillsReportPrinter extends BaseReportPrinter {
  @override
  List<String> headers(String type) => ['رقم الاشتراك', 'قيمة المطالبة', 'الشهر', 'السنة', 'المحطات', 'مسدد', 'شهر الترحيل', 'سنة الترحيل'];

  @override
  List<String> rowCells(ReportBranch b, String type) {
    final isPaidText = b.ispaid == true ? "نعم" : "لا";
    final isPaidClass = b.ispaid == true ? "paid-yes" : "paid-no";
    return [
      '<td class="highlight-cell">${b.accountnumber}</td>',
      '<td class="highlight-cell">${formatNum(b.totalBill)}</td>',
      '<td>${b.month}</td>',
      '<td>${b.year}</td>',
      '<td>${b.station ?? "لا يوجد"}</td>',
      '<td class="$isPaidClass">$isPaidText</td>',
      '<td>${b.delleymonth ?? "لا يوجد"}</td>',
      '<td>${b.delleyyear ?? "لا يوجد"}</td>',
    ];
  }
}
