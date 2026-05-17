import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/features/reports/controller/reports_controller.dart';
import 'package:power_saving/features/reports/view/widgets/bills_report.dart';
import 'package:power_saving/features/reports/view/widgets/branch_report.dart';
import 'package:power_saving/features/reports/view/widgets/over_chlorine_report.dart';
import 'package:power_saving/features/reports/view/widgets/over_liquid_report.dart';
import 'package:power_saving/features/reports/view/widgets/over_powe_report.dart';
import 'package:power_saving/features/reports/view/widgets/over_soild_alum.dart';
import 'package:power_saving/features/reports/view/widgets/power_zero_water.dart';
import 'package:power_saving/features/reports/view/widgets/station_total.dart';
import 'package:power_saving/features/reports/view/widgets/stations_bills_report.dart';
import 'package:power_saving/features/reports/view/widgets/tech3_mont_report.dart';
import 'package:power_saving/features/reports/view/widgets/technology_report.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/reports/model/report.dart';
import 'package:power_saving/global/html_platform.dart';
import 'package:power_saving/my_widget/sharable.dart';

class Reports extends StatelessWidget {
  Reports({super.key});
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: GetBuilder<ReportsController>(
        init: ReportsController(),
        builder: (controller) {
          return Column(
            children: [
              _buildHeader(controller),
              _buildFiltersSection(controller),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _buildTableHeader(controller),

                      // 🔍 SEARCH BAR
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: TextField(
                          controller: controller.searchController,
                          // controller manages search via its listener/debounce
                          decoration: InputDecoration(
                            hintText: 'بحث باسم الفرع أو المحطة',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      // ================= TABLE =================
                      Expanded(
                        child: Obx(() {
                          return controller.isLoading.value
                              ? _buildLoadingState()
                              : controller.filteredBranchs.isEmpty
                                  ? _buildEmptyState()
                                  : _buildReportTable(controller);
                        }),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // UI helpers
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            'لا توجد بيانات للعرض',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text('تأكد من اختيار التواريخ والفلاتر المناسبة', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(ReportsController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Form(
        key: globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list_outlined, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Text('المرشحات:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey.shade700)),
                const Spacer(),
                Obx(() => Text(
                      'إجمالي السجلات: ${controller.filteredBranchs.length}',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.blue.shade700),
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(width: 250, child: _buildDateField(controller.startdate, "بداية التاريخ")),
                const SizedBox(width: 10),
                SizedBox(width: 250, child: _buildDateField(controller.enddate, "نهاية التاريخ")),
                const SizedBox(width: 10),
                SizedBox(width: 350, child: _buildReportTypeDropdown(controller)),
                const SizedBox(width: 10),
                _buildSearchButton(controller),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return CustomTextFormField(
      controller: controller,
      icon: Icons.calendar_month,
      label: label.tr,
      readonly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  Widget _buildReportTypeDropdown(ReportsController controller) {
    final reportTypes = [
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "branch_per_month", "label": "تقرير الفروع شهرياً"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "branch_total", "label": "إجمالي تقرير الفروع"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "technology_per_month", "label": "تقرير التكنولوجيا شهرياً"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "technology_total", "label": "إجمالي تقرير التكنولوجيا"},
      {"value": "station_total", "label": "إجمالي المحطات"},
        if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)
      {"value": "over_solid_alum_consumption", "label": " الأستهلاك الزائد (الشبة الصلب)"},
        if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)
      {"value": "over_liquid_alum_consumption", "label": " الأستهلاك الزائد (الشبة السائل)"},
        if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)
      {"value": "power_for_zero_water", "label": "أستهلاك خارج الحد المسموح للأنارة"},
          if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)
      {"value": "over_chlorine_consumption", "label": " الأستهلاك الزائد (كلور)"},
      
                if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)



           {"value": "over_power_consumption", "label": " الأستهلاك الزائد (كهرياء)"},
          if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6)

      {"value": "station_per_month", "label": "تقرير المحطات شهرياً"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "station-bills", "label": "فواتير المحطات"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "water-techs-3-month", "label": "تقرير المياه (3 أشهر)"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "sanity-techs-3-month", "label": "تقرير الصرف (3 أشهر)"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "bills", "label": "(المالي) تقرير فواتير"},
    ];

    return CustomDropdownFormField<String>(
      items: reportTypes.map((type) => DropdownMenuItem(value: type["value"], child: Text(type["label"]!))).toList(),
      onChanged: (val) => controller.reportname = val!,
      labelText: 'نوع التقرير',
      hintText: 'اختر نوع التقرير',
      prefixIcon: Icons.category,
      validator: (val) => val == null ? 'الرجاء اختيار نوع التقرير' : null,
    );
  }

  Widget _buildSearchButton(ReportsController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (globalKey.currentState!.validate()) {
            controller.getReports(start: controller.startdate.text, end: controller.enddate.text, name: controller.reportname!);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('بحث', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildSearchBar(ReportsController controller) {
    return TextField(
      controller: controller.searchController,
      // controller manages search via its listener/debounce
      decoration: InputDecoration(
        hintText: 'بحث باسم الفرع أو المحطة',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildHeader(ReportsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تقارير الفروع', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text('عرض شامل لبيانات جميع الفروع', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              controller.sumvalueofreport(controller.filteredBranchs);
              ReportPrinterFactory.forType(controller.reportname ?? '').print(controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Icons.print_outlined, size: 18),
            label: const Text('طباعة التقرير', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => Get.offNamed("/home"),
            icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }

  Widget _buildTableHeader(ReportsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Icon(Icons.table_chart_outlined, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Text(_getTableTitle(controller.reportname ?? ""), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const Spacer(),
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('محدث', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.green.shade700)),
        ],
      ),
    );
  }

  // Report view switcher
  Widget _buildReportTable(ReportsController controller) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();
    final reportType = controller.reportname ?? '';

    Widget table = ReportTableFactory.forType(reportType, controller);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Scrollbar(
        controller: verticalController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: verticalController,
          scrollDirection: Axis.vertical,
          child: Scrollbar(
            controller: horizontalController,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: Get.width - 100),
                child: table,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTableTitle(String reportName) {
    final titles = {
      "branch_per_month": "بيانات الفروع الشهرية",
      "branch_total": "إجمالي بيانات الفروع",
      "technology_per_month": "بيانات التكنولوجيا الشهرية",
      "technology_total": "إجمالي بيانات التكنولوجيا",
      "station-bills": "فواتير المحطات",
      "water-techs-3-month": "تقرير المياه",
      "sanity-techs-3-month": "تقرير الصرف",
      "over_power_consumption":"الأسنهلاك الزائد(كهرباء)",
      "bills": "تقرير الفواتير (المالي) ",
      "station_total": "إجمالي المحطات",
      "station_per_month": " إجمالي المحطات شهرياً",
      "over_chlorine_consumption": "الاستهلاك الزائد (كلور)",
      "over_solid_alum_consumption": "الاستهلاك الزائد (الشبة الصلبة)",
      "over_liquid_alum_consumption": "الاستهلاك الزائد (الشبة السائلة)",
      "power_for_zero_water": "استهلاك كهرباء مع عدم وجود مياه",
    };
    return titles[reportName] ?? "بيانات التقارير";
  }
}

// ---------- Base report table ----------
abstract class BaseReportTable extends StatelessWidget {
  final ReportsController controller;
  const BaseReportTable({super.key, required this.controller});

  List<DataColumn> buildColumns();
  List<DataRow> buildRows();

  DataColumn col(String label, IconData icon) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade600),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  DataCell styledCell(String text, Color color) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 12)),
      ),
    );
  }

  DataCell dataCell(String text) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700, fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 16,
      headingRowHeight: 50,
      dataRowHeight: 56,
      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade800),
      dataTextStyle: TextStyle(fontSize: 12, color: Colors.grey.shade700),
      columns: buildColumns(),
      rows: buildRows(),
    );
  }

  String numFmt(num v) => NumberFormat('#,###').format(v);
}

// ---------- Table factory ----------
class ReportTableFactory {
  static Widget forType(String type, ReportsController controller) {
    switch (type) {
      case 'station_total':
        return StationTotalReportTable(controller: controller, showMonthYear: false);
      case 'branch_per_month':
        return BranchReportTable(controller: controller, showMonthYear: true);
      case 'branch_total':
        return BranchReportTable(controller: controller, showMonthYear: false);
      case 'technology_per_month':
        return TechnologyReportTable(controller: controller, showMonthYear: true);
      case 'technology_total':
        return TechnologyReportTable(controller: controller, showMonthYear: false);
      case 'station-bills':
        return StationBillsReportTable(controller: controller);
      case 'station_per_month':
        return StationTotalReportTable(controller: controller, showMonthYear: true);
        case 'bills':
          return BillsReportTable(controller: controller);
      case 'over_power_consumption':
        return OverPoweReport(controller: controller);
      case 'water-techs-3-month':
      case 'sanity-techs-3-month':
        return Techs3MonthReportTable(controller: controller);
         case 'over_chlorine_consumption':
        return OverChlorineReport(controller: controller);
          case 'over_solid_alum_consumption':
        return OverSolidAlumReport(controller: controller);
          case 'over_liquid_alum_consumption':
        return OverLiquidAlumReport(controller: controller);
           case 'power_for_zero_water':
        return PowerZeroWaterReport(controller: controller);
        
      default:
        return BranchReportTable(controller: controller, showMonthYear: true);
    }
  }
}

// ---------- Printing strategies ----------
abstract class BaseReportPrinter {
  String title(String type) {
    return {
          "branch_per_month": "بيانات الفروع الشهرية",
          "branch_total": "إجمالي بيانات الفروع",
          "technology_per_month": "بيانات التكنولوجيا الشهرية",
          "technology_total": "إجمالي بيانات التكنولوجيا",
          "station-bills": "فواتير المحطات",
          "water-techs-3-month": "تقرير المياه",
          'over_power_consumption':"الأسنهلاك الزائد(كهرباء)",
          "sanity-techs-3-month": "تقرير الصرف",
          "bills": "تقرير الفواتير (المالي) ",
          "station_total": "إجمالي المحطات",
          "station_per_month": " إجمالي المحطات شهرياً",
          "over_chlorine_consumption": "الاستهلاك الزائد (كلور)",
          "over_solid_alum_consumption": "الاستهلاك الزائد (الشبة الصلبة)",
          "over_liquid_alum_consumption": "الاستهلاك الزائد (الشبة السائلة)",
          "power_for_zero_water": "استهلاك كهرباء مع عدم وجود مياه",
          "all_anomalies_report": "مجمع اخطاء الكهرباء   ",
        }[type] ??
        "بيانات التقارير";
  }

  List<String> headers(String type);
  List<String> rowCells(ReportBranch b, String type);
  String? summaryHtml(ReportsController controller, String type) => null;

  String formatNum(dynamic value) {
    if (value == null) return "0";
    double numValue;
    if (value is String) {
      numValue = double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      numValue = value.toDouble();
    } else {
      return "0";
    }
    return NumberFormat('#,##0.00').format(numValue);
  }

  void print(ReportsController controller) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    final reportTitle = title(controller.reportname ?? "");

    final th = headers(controller.reportname ?? "").map((h) => '<th>$h</th>').join('');
    final rows = controller.branchs.map((b) {
      final cells = rowCells(b, controller.reportname ?? "");
      return '<tr>${cells.join('')}</tr>';
    }).join('');
    final extra = summaryHtml(controller, controller.reportname ?? "") ?? '';

    final htmlStr = '''
<!DOCTYPE html>
<html dir="rtl">
<head>
  <meta charset="UTF-8">
  <title>$reportTitle</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Arial', sans-serif; direction: rtl; background: white; color: #1f2937; }
    .print-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
    .header { text-align: center; margin-bottom: 10px; padding: 10px; background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; border-radius: 10px; }
    .header h1 { font-size: 20px; margin-bottom: 5px; font-weight: bold; }
    .header p { font-size: 14px; opacity: 0.9; }
    .info-section { display: flex; justify-content: space-between; align-items: center; width: 100%; margin-bottom: 30px; padding: 20px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; }
    .info-section > * { flex: 1; text-align: center; }
    .info-item { text-align: center; padding: 4px; background: white; border-radius: 8px; }
    .info-label { font-size: 10px; color: #64748b; margin-bottom: 5px; text-transform: uppercase; font-weight: 600; }
    .info-value { font-size: 12px; color: #1e293b; font-weight: bold; }
    .table-container { background: white; border-radius: 12px; overflow-x: auto; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; }
    table { width: 100%; border-collapse: collapse; }
    th { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; padding: 16px 12px; text-align: right; font-weight: bold; font-size: 14px; border-bottom: 2px solid #1d4ed8; }
    td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; text-align: right; font-size: 13px; }
    tr:nth-child(even) { background: #f8fafc; }
    tr:hover { background: #e0f2fe; transition: all 0.2s ease; }
    .highlight-cell { background: #dbeafe !important; color: #1e40af; font-weight: 600; border-radius: 6px; }
    .paid-yes { background: #d1fae5 !important; color: #065f46; font-weight: 600; border-radius: 6px; }
    .paid-no { background: #fee2e2 !important; color: #991b1b; font-weight: 600; border-radius: 6px; }
    .summary-row { background: white !important; color: #1f2937; font-weight: bold; }
    .summary-row td { background: white !important; color: #1f2937; font-weight: bold; border-top: 2px solid #2563eb; border-bottom: 1px solid #e2e8f0; }
    .summary-row:hover { background: white !important; transform: none; }
    .footer { margin-top: 40px; text-align: center; color: #64748b; font-size: 12px; border-top: 2px solid #e2e8f0; padding-top: 20px; }
    .no-print { text-align: center; margin-bottom: 30px; }
    .print-button { background: linear-gradient(135deg, #059669, #047857); color: white; border: none; padding: 15px 30px; border-radius: 10px; cursor: pointer; font-size: 16px; font-weight: 600; box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3); transition: all 0.2s ease; }
    .print-button:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(5, 150, 105, 0.4); }
    @media print { .no-print { display: none; } body { background: white; } .print-container { padding: 0; }
  </style>
</head>
<body>
  <div class="print-container">
    <div class="header">
      <h1>$reportTitle</h1>
      <p>تقرير شامل ومفصل لجميع البيانات</p>
    </div>
    <div class="no-print">
      <button class="print-button" onclick="window.print()">🖨️ طباعة التقرير</button>
    </div>
    <div class="info-section">
      <div class="info-item"><div class="info-label">تاريخ الطباعة</div><div class="info-value">$formattedDate</div></div>
      <div class="info-item"><div class="info-label">إجمالي السجلات</div><div class="info-value">${controller.branchs.length}</div></div>
      <div class="info-item"><div class="info-label">الفترة</div><div class="info-value">${controller.startdate.text} - ${controller.enddate.text}</div></div>
      <div class="info-item"><div class="info-label">نوع التقرير</div><div class="info-value">$reportTitle</div></div>
    </div>
    <div class="table-container">
      <table>
        <thead><tr>$th</tr></thead>
        <tbody>$rows$extra</tbody>
      </table>
    </div>
    <div class="footer"><p>تم إنشاء هذا التقرير تلقائياً بواسطة   ${user?.empName} | ${DateTime.now().year}</p></div>
  </div>
</body>
</html>
''';

    openHtmlReport(htmlStr);
  }
}

// ---------- Printer factory ----------
class ReportPrinterFactory {
  static BaseReportPrinter forType(String type) {
    switch (type) {
      case 'branch_per_month':
        return BranchReportPrinter(showMonthYear: true);
      case 'branch_total':
        return BranchReportPrinter(showMonthYear: false);
      case 'technology_per_month':
        return TechnologyReportPrinter(showMonthYear: true);
      case 'technology_total':
        return TechnologyReportPrinter(showMonthYear: false);
      case 'station-bills':
        return StationBillsReportPrinter();
      case 'bills':
        return BillsReportPrinter();
      case 'water-techs-3-month':
      case 'sanity-techs-3-month':
        return Techs3MonthReportPrinter();
      case 'station_total':
        return StationTotalReportPrinter(showMonthYear: false);
      case 'station_per_month':
        return StationTotalReportPrinter(showMonthYear: true);
      case 'over_power_consumption':

        return OverPowerReportPrinter();
          case 'over_solid_alum_consumption':

        return OverSolidAlumReportPrinter();
          case 'over_chlorine_consumption':
        return OverChlorineReportPrinter();
          case 'power_for_zero_water':
        return PowerZeroWaterReportPrinter();
        case 'over_liquid_alum_consumption':
        return OverLiquidAlumReportPrinter();
      default:
        return BranchReportPrinter(showMonthYear: true);
    }
  }
}
