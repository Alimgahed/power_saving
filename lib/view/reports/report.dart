import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/controller/reports/reports_controller.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/report.dart';
import 'dart:html' as html;
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
                      Expanded(
                        child: controller.isLoading.value
                            ? _buildLoadingState()
                            : controller.branchs.isEmpty
                                ? _buildEmptyState()
                                : _buildOptimizedDataView(controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
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
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 14),
          Text(
            'لا توجد بيانات للعرض',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'تأكد من اختيار التواريخ والفلاتر المناسبة',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 10),
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
                Text(
                  'المرشحات:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey.shade700),
                ),
                const Spacer(),
                Text(
                  'إجمالي السجلات: ${controller.branchs.length}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.blue.shade700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: _buildDateField(controller.startdate, "بداية التاريخ", controller),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 250,
                  child: _buildDateField(controller.enddate, "نهاية التاريخ", controller),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 350,
                  child: _buildReportTypeDropdown(controller),
                ),
                SizedBox(width: 10),
                _buildSearchButton(controller),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label, ReportsController reportController) {
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

  Widget _buildSearchButton(ReportsController controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (globalKey.currentState!.validate()) {
            controller.get_reports(
              start: controller.startdate.text,
              end: controller.enddate.text,
              name: controller.reportname!,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'بحث',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }

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

  Widget _buildHeader(ReportsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقارير الفروع',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'عرض شامل لبيانات جميع الفروع',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          _buildActionButtons(controller),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Get.offNamed("/home");
            },
            icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 30),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(ReportsController controller) {
    return ElevatedButton.icon(
      onPressed: () async {
        await controller.sumvalueofreport();
        _printReport(controller);
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
    );
  }

  Widget _buildReportTypeDropdown(ReportsController controller) {
    final reportTypes = [
      if (user?.groupId == 2||user?.groupId==1) {"value": "branch_per_month", "label": "تقرير الفروع شهرياً"},
      if (user?.groupId == 2||user?.groupId==1) {"value": "branch_total", "label": "إجمالي تقرير الفروع"},
      if (user?.groupId == 2||user?.groupId==1) {"value": "technology_per_month", "label": "تقرير التكنولوجيا شهرياً"},
      if (user?.groupId == 2||user?.groupId==1) {"value": "technology_total", "label": "إجمالي تقرير التكنولوجيا"},
      if (user?.groupId == 3||user?.groupId==1) {"value": "station-bills", "label": "فواتير المحطات"},
      if (user?.groupId == 3||user?.groupId==1) {"value": "water-techs-3-month", "label": "تقرير المياه (3 أشهر)"},
      if (user?.groupId == 3||user?.groupId==1) {"value": "sanity-techs-3-month", "label": "تقرير الصرف (3 أشهر)"},
      if (user?.groupId == 3||user?.groupId==1) {"value": "bills", "label": "(المالي) تقرير فواتير"},
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

  Widget _buildTableHeader(ReportsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.table_chart_outlined, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            _getTableTitle(controller.reportname ?? ""),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const Spacer(),
          _buildStatusIndicator(),
        ],
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
      "bills": "تقرير الفواتير (المالي) ",
      "sanity-techs-3-month": "تقرير الصرف",
    };
    return titles[reportName] ?? "بيانات التقارير";
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            'محدث',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedDataView(ReportsController controller) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();

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
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 50,
                  dataRowHeight: 56,
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey.shade800,
                  ),
                  dataTextStyle: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  columns: _buildOptimizedColumns(controller),
                  rows: _buildOptimizedRows(controller),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildOptimizedColumns(ReportsController controller) {
    List<DataColumn> columns = [];

    final reportType = controller.reportname ?? "";

    // Add columns based on report type
    if (reportType.contains("branch")) {
      columns.add(_buildColumn("اسم الفرع", Icons.business_outlined));
    } else if (reportType.contains("technology") || reportType.contains("techs-3")) {
      columns.add(_buildColumn("التكنولوجيا", Icons.precision_manufacturing));
    } else if (reportType == "station-bills") {
      columns.add(_buildColumn("اسم المحطة", Icons.electrical_services));
    } else if (reportType == "bills") {
      columns.add(_buildColumn("رقم الاشتراك", Icons.numbers));
    }

    columns.add(_buildColumn("قيمة المطالبة", Icons.monetization_on));

    if (reportType != "bills" && reportType != "station-bills" && reportType != "sanity-techs-3-month" && reportType != "water-techs-3-month") {
      columns.addAll([
        _buildColumn("كمية المياه", Icons.water_drop_outlined),
        _buildColumn("الكلور", Icons.science),
        _buildColumn("الشبة الصلبة", Icons.ac_unit),
        _buildColumn("الشبة السائلة", Icons.opacity),
        _buildColumn("الكهرباء", Icons.electric_bolt),
      ]);
    }
    
    if (reportType.contains("techs-3")) {
      columns.addAll([
        _buildColumn("المياه", Icons.water_drop_outlined),
        _buildColumn("الكهرباء", Icons.electric_bolt),
        _buildColumn("النسبة", Icons.percent_outlined),
      ]);
    }

    if (!reportType.contains("total") && !reportType.contains("techs-3")) {
      columns.addAll([
        _buildColumn("الشهر", Icons.calendar_month),
        _buildColumn("السنة", Icons.date_range),
      ]);
    }
    
    if (reportType == ("bills")) {
      columns.addAll([
        _buildColumn("مسدد", Icons.monetization_on_outlined),
        _buildColumn("شهر الترحيل", Icons.calendar_month),
        _buildColumn("سنة الترحيل", Icons.date_range),
      ]);
    }

    return columns;
  }

  DataColumn _buildColumn(String label, IconData icon) {
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

  List<DataRow> _buildOptimizedRows(ReportsController controller) {
    return controller.branchs.map((branch) {
      return DataRow(
        cells: _buildCellsForBranch(branch, controller.reportname ?? ""),
      );
    }).toList();
  }

  List<DataCell> _buildCellsForBranch(ReportBranch branch, String reportType) {
    List<DataCell> cells = [];

    // Add main identifier cell
    if (reportType.contains("branch")) {
      cells.add(_buildStyledCell(branch.branchName, Colors.blue));
    } else if (reportType.contains("technology") || reportType.contains("techs-3")) {
      cells.add(_buildStyledCell(branch.techname ?? "", Colors.purple));
    } else if (reportType == "station-bills") {
      cells.add(_buildStyledCell(branch.stationname ?? "", Colors.green));
    } else if (reportType == "bills") {
      cells.add(_buildStyledCell(branch.accountnumber ?? "", Colors.green));
    }

    // Add bill amount
    cells.add(_buildStyledCell(
      NumberFormat('#,###').format(branch.totalBill),
      Colors.orange,
    ));

    // Add other data if not station bills or bills
    if (reportType != "bills" && reportType != "station-bills" && reportType != "sanity-techs-3-month" && reportType != "water-techs-3-month") {
      cells.addAll([
        _buildDataCell('${branch.totalWater.toStringAsFixed(1)} م³'),
        _buildDataCell('${branch.totalChlorine.toStringAsFixed(1)} كجم'),
        _buildDataCell('${branch.totalSolidAlum.toStringAsFixed(1)} كجم'),
        _buildDataCell('${branch.totalLiquidAlum.toStringAsFixed(1)} كجم'),
        _buildDataCell('${branch.totalPower.toStringAsFixed(1)} واط'),
      ]);
    }
    
    if (reportType.contains("techs-3")) {
      cells.addAll([
        _buildDataCell('${branch.totalWater}'),
        _buildDataCell('${branch.totalPower}'),
        _buildDataCell('${branch.precent}'),
      ]);
    }
    
    // Add month/year if not total reports
    if (!reportType.contains("total") && !reportType.contains("techs-3")) {
      cells.addAll([
        _buildDataCell('${branch.month}'),
        _buildDataCell('${branch.year}'),
      ]);
    }
    
    if (reportType == ("bills")) {
      cells.addAll([
        if (branch.ispaid == true) _buildDataCell("نعم"),
        if (branch.ispaid != true) _buildDataCell("لا"),
        _buildDataCell('${branch.delleymonth ?? "لايوجد"}'),
        _buildDataCell('${branch.delleyyear ?? "لايوجد"}'),
      ]);
    }

    return cells;
  }

  DataCell _buildStyledCell(String text, Color color) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCell(String text) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _printReport(ReportsController controller) {
    final printContent = _generateEnhancedPrintHtml(controller);
    final blob = html.Blob([printContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
  }

  String _generateEnhancedPrintHtml(ReportsController controller) {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    final reportTitle = _getTableTitle(controller.reportname ?? "");

    String tableHeaders = _generateTableHeaders(controller.reportname ?? "");
    String tableRows = _generateTableRows(controller);

    return '''
  <!DOCTYPE html>
  <html dir="rtl">
  <head>
    <meta charset="UTF-8">
    <title>$reportTitle</title>
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body {
        font-family: 'Arial', sans-serif;
        direction: rtl;
        background: white;
        color: #1f2937;
      }
      .print-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
      }
      .header {
        text-align: center;
        margin-bottom: 10px;
        padding: 10px;
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color: white;
        border-radius: 10px;
      }
      .header h1 {
        font-size: 20px;
        margin-bottom: 5px;
        font-weight: bold;
      }
      .header p {
        font-size: 14px;
        opacity: 0.9;
      }
      .info-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        margin-bottom: 30px;
        padding: 20px;
        background: #f8fafc;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
      }
      .info-section > * {
        flex: 1;
        text-align: center;
      }
      .info-item {
        text-align: center;
        padding: 4px;
        background: white;
        border-radius: 8px;
      }
      .info-label {
        font-size: 10px;
        color: #64748b;
        margin-bottom: 5px;
        text-transform: uppercase;
        font-weight: 600;
      }
      .info-value {
        font-size: 12px;
        color: #1e293b;
        font-weight: bold;
      }
      .table-container {
        background: white;
        border-radius: 12px;
        overflow-x: auto;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        border: 1px solid #e2e8f0;
      }
      table {
        width: 100%;
        border-collapse: collapse;
      }
      th {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color: white;
        padding: 16px 12px;
        text-align: right;
        font-weight: bold;
        font-size: 14px;
        border-bottom: 2px solid #1d4ed8;
      }
      td {
        padding: 14px 12px;
        border-bottom: 1px solid #f1f5f9;
        text-align: right;
        font-size: 13px;
      }
      tr:nth-child(even) {
        background: #f8fafc;
      }
      tr:hover {
        background: #e0f2fe;
        transition: all 0.2s ease;
      }
      .highlight-cell {
        background: #dbeafe !important;
        color: #1e40af;
        font-weight: 600;
        border-radius: 6px;
      }
      .paid-yes {
        background: #d1fae5 !important;
        color: #065f46;
        font-weight: 600;
        border-radius: 6px;
      }
      .paid-no {
        background: #fee2e2 !important;
        color: #991b1b;
        font-weight: 600;
        border-radius: 6px;
      }
      .summary-row {
        background: white !important;
        color: #1f2937;
        font-weight: bold;
      }
      .summary-row td {
        background: white !important;
        color: #1f2937;
        font-weight: bold;
        border-top: 2px solid #2563eb;
        border-bottom: 1px solid #e2e8f0;
      }
      .summary-row:hover {
        background: white !important;
        transform: none;
      }
      .footer {
        margin-top: 40px;
        text-align: center;
        color: #64748b;
        font-size: 12px;
        border-top: 2px solid #e2e8f0;
        padding-top: 20px;
      }
      .no-print {
        text-align: center;
        margin-bottom: 30px;
      }
      .print-button {
        background: linear-gradient(135deg, #059669, #047857);
        color: white;
        border: none;
        padding: 15px 30px;
        border-radius: 10px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
        transition: all 0.2s ease;
      }
      .print-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(5, 150, 105, 0.4);
      }
      @media print {
        .no-print { display: none; }
        body { background: white; }
        .print-container { padding: 0; }
      }
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
        <div class="info-item">
          <div class="info-label">تاريخ الطباعة</div>
          <div class="info-value">$formattedDate</div>
        </div>
        <div class="info-item">
          <div class="info-label">إجمالي السجلات</div>
          <div class="info-value">${controller.branchs.length}</div>
        </div>
        <div class="info-item">
          <div class="info-label">الفترة</div>
          <div class="info-value">${controller.startdate.text} - ${controller.enddate.text}</div>
        </div>
        <div class="info-item">
          <div class="info-label">نوع التقرير</div>
          <div class="info-value">$reportTitle</div>
        </div>
      </div>

      <div class="table-container">
        <table>
          <thead>
            <tr>$tableHeaders</tr>
          </thead>
          <tbody>
            $tableRows
          </tbody>
        </table>
      </div>

      <div class="footer">
        <p>تم إنشاء هذا التقرير تلقائياً بواسطة   ${user?.empName} | ${DateTime.now().year}</p>
      </div>
    </div>
  </body>
  </html>
  ''';
  }

  String _generateTableHeaders(String reportType) {
    List<String> headers = [];

    if (reportType.contains("branch")) {
      headers.add('<th>اسم الفرع</th>');
    } else if (reportType.contains("technology") || reportType.contains("techs-3")) {
      headers.add('<th>التكنولوجيا</th>');
    } else if (reportType == "station-bills") {
      headers.add('<th>اسم المحطة</th>');
    } else if (reportType == "bills") {
      headers.add('<th>رقم الاشتراك</th>');
    }

    headers.add('<th>قيمة المطالبة</th>');

    if (reportType != "bills" && reportType != "station-bills" && reportType != "water-techs-3-month" && reportType != "sanity-techs-3-month") {
      headers.addAll([
        '<th>كمية المياه</th>',
        '<th>الكلور</th>',
        '<th>الشبة الصلبة</th>',
        '<th>الشبة السائلة</th>',
        '<th>الكهرباء</th>',
      ]);
    }

    if (reportType.contains("techs-3")) {
      headers.addAll(['<th>كمية المياه</th>', '<th>كمية الكهرباء</th>', '<th>النسبة</th>']);
    }

    if (!reportType.contains("total") && !reportType.contains("techs-3")) {
      headers.addAll(['<th>الشهر</th>', '<th>السنة</th>']);
    }

    if (reportType == "bills") {
      headers.addAll(['<th>مسدد</th>', '<th>شهر الترحيل</th>', '<th>سنة الترحيل</th>']);
    }

    return headers.join('');
  }

  String _generateTableRows(ReportsController controller) {
    String regularRows = controller.branchs.map((branch) {
      List<String> cells = [];
      String reportType = controller.reportname ?? "";

      // First column based on report type
      if (reportType.contains("branch")) {
        cells.add('<td class="highlight-cell">${branch.branchName}</td>');
      } else if (reportType.contains("technology") || reportType.contains("techs-3")) {
        cells.add('<td class="highlight-cell">${branch.techname}</td>');
      } else if (reportType == "station-bills") {
        cells.add('<td class="highlight-cell">${branch.stationname}</td>');
      } else if (reportType == "bills") {
        cells.add('<td class="highlight-cell">${branch.accountnumber}</td>');
      }

      // Claim value column
      cells.add('<td class="highlight-cell">${_formatNumber(branch.totalBill)}</td>');

      // Additional columns for non-station-bills and non-bills reports
      if (reportType != "bills" && reportType != "station-bills" && reportType != "water-techs-3-month" && reportType != "sanity-techs-3-month") {
        cells.addAll([
          '<td>${_formatNumber(branch.totalWater)}</td>',
          '<td>${_formatNumber(branch.totalChlorine)}</td>',
          '<td>${_formatNumber(branch.totalSolidAlum)}</td>',
          '<td>${_formatNumber(branch.totalLiquidAlum)}</td>',
          '<td>${_formatNumber(branch.totalPower)}</td>',
        ]);
      }

      if (reportType.contains("techs-3")) {
        cells.addAll([
          '<td>${branch.totalWater}</td>',
          '<td>${branch.totalPower}</td>',
          '<td>${branch.precent}</td>',
        ]);
      }

      if (!reportType.contains("total") && !reportType.contains("techs-3")) {
        cells.addAll([
          '<td>${branch.month}</td>',
          '<td>${branch.year}</td>',
        ]);
      }

      if (reportType == "bills") {
        String isPaidText = branch.ispaid == true ? "نعم" : "لا";
        String isPaidClass = branch.ispaid == true ? "paid-yes" : "paid-no";

        cells.addAll([
          '<td class="$isPaidClass">$isPaidText</td>',
          '<td>${branch.delleymonth ?? "لا يوجد"}</td>',
          '<td>${branch.delleyyear ?? "لا يوجد"}</td>',
        ]);
      }

      return '<tr>${cells.join('')}</tr>';
    }).join('');

    // Add summary rows for techs-3 reports
    String summaryRows = '';
    if (controller.reportname?.contains("techs-3") == true) {
      summaryRows = _generateSummaryRows(controller);
    }

    return regularRows + summaryRows;
  }

  String _generateSummaryRows(ReportsController controller) {
    // Calculate totals for the summary
    double totalPower = 0.0;
    double totalMoney = 0.0;
    double totalWater = 0.0;

    for (var branch in controller.branchs) {
      totalPower += double.tryParse(branch.totalPower.toString()) ?? 0.0;
      totalMoney += double.tryParse(branch.totalBill.toString()) ?? 0.0;
      totalWater += double.tryParse(branch.totalWater.toString()) ?? 0.0;
    }

    // Calculate electricity per claim value ratio
    double electricityPerClaimRatio = totalMoney != 0 ? totalMoney / totalPower : 0.0;

    return '''
    <tr class="summary-row">
      <td>جملة تشغيل الكهرباء</td>
      <td>${_formatNumber(totalMoney)}</td>
      <td>${_formatNumber(totalWater)}</td>
      <td>${_formatNumber(totalPower)}</td>
      <td>${_formatNumber(electricityPerClaimRatio)}</td>
    </tr>
    <tr class="summary-row">
      <td>جملة الإنارة</td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr class="summary-row">
      <td>جملة الكهرباء</td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  ''';
  }

  // Helper method to format numbers with proper Arabic numerals and formatting
  String _formatNumber(dynamic value) {
    if (value == null) return "0";

    // Convert to double if it's a string
    double numValue;
    if (value is String) {
      numValue = double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      numValue = value.toDouble();
    } else {
      return "0";
    }

    // Format with thousands separator and 2 decimal places
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(numValue);
  }
}