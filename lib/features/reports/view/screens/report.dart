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
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

class Reports extends StatelessWidget {
  Reports({super.key});
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  // ─── Design tokens (page-local) ───
  static const _kHeaderPaddingH = 24.0;
  static const _kHeaderPaddingV = 16.0;
  static const _kSectionMargin = 16.0;
  static const _kCardRadius = 10.0;
  static const _kInputRadius = 8.0;
  static const _kInputHeight = 48.0;
  static final _kBorderColor = Colors.grey.shade300;
  static final _kNeutralBg = const Color(0xFFF8FAFC);
  static final _kHeaderBlue = const Color(0xFF1E40AF);
  static final _kHeaderBlueDark = const Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'التقارير',
      desktopHeader: const SizedBox.shrink(),
      mobileAppBar: const PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body: GetBuilder<ReportsController>(
        init: ReportsController(),
        builder: (controller) {
          return Column(
            children: [
              // ── Level 1: Header ──
              _buildHeader(controller),
              // ── Level 2: Filters ──
              _buildFiltersSection(controller),
              // ── Level 3+4: Report card (toolbar + table) ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(_kSectionMargin, 12, _kSectionMargin, _kSectionMargin),
                  decoration: _cardDecoration(),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // Level 3: Report toolbar header
                      _buildReportToolbar(controller),
                      // Level 4: Table
                      Expanded(
                        child: Obx(() {
                          final _ = controller.filteredBranchs.length;
                          return controller.isLoading.value
                              ? _buildLoadingState()
                              : controller.filteredBranchs.isEmpty
                                  ? _buildEmptyState()
                                  : _buildReportTable(controller);
                        }),
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

  // ═══════════════════════════════════════════════════
  //  CARD DECORATION
  // ═══════════════════════════════════════════════════
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_kCardRadius),
      border: Border.all(color: Colors.grey.shade200, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════
  //  LEVEL 1: HEADER
  // ═══════════════════════════════════════════════════
  Widget _buildHeader(ReportsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: _kHeaderPaddingH, vertical: _kHeaderPaddingV),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_kHeaderBlueDark, _kHeaderBlue],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Row(
        children: [
          // ── Report icon ──
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.assessment_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          // ── Title + Subtitle ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تقارير الفروع',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2),
                ),
                const SizedBox(height: 2),
                Text(
                  'عرض شامل لبيانات جميع الفروع',
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.8), height: 1.3),
                ),
              ],
            ),
          ),
          // ── Print button ──
          ElevatedButton.icon(
            onPressed: () async {
              controller.sumvalueofreport(controller.filteredBranchs);
              ReportPrinterFactory.forType(controller.reportname ?? '').print(controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _kHeaderBlue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            icon: const Icon(Icons.print_outlined, size: 16),
            label: const Text('طباعة التقرير', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          const SizedBox(width: 10),
          // ── Back button ──
          Material(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Get.offNamed("/home"),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  LEVEL 2: FILTER SECTION
  // ═══════════════════════════════════════════════════
  Widget _buildFiltersSection(ReportsController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(_kSectionMargin, 12, _kSectionMargin, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _cardDecoration(),
      child: Form(
        key: globalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header row: label + record count ──
            Row(
              children: [
                Icon(Icons.tune, color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 6),
                Text(
                  'المرشحات',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade800),
                ),
                const Spacer(),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _kNeutralBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _kBorderColor),
                      ),
                      child: Text(
                        'إجمالي السجلات: ${controller.filteredBranchs.length}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            // ── Filter controls ── uses LayoutBuilder for responsive flex
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                // If wide enough, use a single horizontal row with flexible children
                if (availableWidth > 700) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildDateFieldInline(controller.startdate, "بداية التاريخ")),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: _buildDateFieldInline(controller.enddate, "نهاية التاريخ")),
                      const SizedBox(width: 10),
                      Expanded(flex: 3, child: _buildReportTypeInline(controller)),
                      const SizedBox(width: 10),
                      _buildSearchButton(controller),
                    ],
                  );
                }
                // Narrower screens: wrap into 2 rows
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildDateFieldInline(controller.startdate, "بداية التاريخ")),
                        const SizedBox(width: 10),
                        Expanded(child: _buildDateFieldInline(controller.enddate, "نهاية التاريخ")),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildReportTypeInline(controller)),
                        const SizedBox(width: 10),
                        _buildSearchButton(controller),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Page-local date field (neutral borders, no extra padding) ──
  Widget _buildDateFieldInline(TextEditingController controller, String label) {
    return SizedBox(
      height: _kInputHeight,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label.tr,
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _kBorderColor),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _kHeaderBlue, width: 1.5),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'هذا الحقل مطلوب';
          return null;
        },
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
      ),
    );
  }

  // ── Page-local report-type dropdown (neutral borders) ──
  Widget _buildReportTypeInline(ReportsController controller) {
    final reportTypes = [
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "branch_per_month", "label": "تقرير الفروع شهرياً"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "branch_total", "label": "إجمالي تقرير الفروع"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "technology_per_month", "label": "تقرير التكنولوجيا شهرياً"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "technology_total", "label": "إجمالي تقرير التكنولوجيا"},
      if (user?.groupId != 4) {"value": "station_total", "label": "إجمالي المحطات"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6 || user?.groupId == 4) {"value": "over_solid_alum_consumption", "label": "الأستهلاك الزائد (الشبة الصلب)"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6 || user?.groupId == 4) {"value": "over_liquid_alum_consumption", "label": "الأستهلاك الزائد (الشبة السائل)"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "power_for_zero_water", "label": "أستهلاك خارج الحد المسموح للأنارة"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6 || user?.groupId == 4) {"value": "over_chlorine_consumption", "label": "الأستهلاك الزائد (كلور)"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "over_power_consumption", "label": "الأستهلاك الزائد (كهرياء)"},
      if (user?.groupId == 2 || user?.groupId == 1 || user?.groupId == 6) {"value": "station_per_month", "label": "تقرير المحطات شهرياً"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "station-bills", "label": "فواتير المحطات"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "water-techs-3-month", "label": "تقرير المياه (3 أشهر)"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "sanity-techs-3-month", "label": "تقرير الصرف (3 أشهر)"},
      if (user?.groupId == 3 || user?.groupId == 1) {"value": "bills", "label": "(المالي) تقرير فواتير"},
    ];

    return SizedBox(
      height: _kInputHeight,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'نوع التقرير',
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          hintText: 'اختر نوع التقرير',
          prefixIcon: Icon(Icons.category_outlined, size: 18, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _kBorderColor),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _kHeaderBlue, width: 1.5),
            borderRadius: BorderRadius.circular(_kInputRadius),
          ),
        ),
        items: reportTypes.map((type) => DropdownMenuItem(value: type["value"], child: Text(type["label"]!, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: (val) => controller.reportname = val!,
        validator: (val) => val == null ? 'الرجاء اختيار نوع التقرير' : null,
        isExpanded: true,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade900),
      ),
    );
  }

  // ── Search button ──
  Widget _buildSearchButton(ReportsController controller) {
    return SizedBox(
      height: _kInputHeight,
      child: Material(
        color: _kHeaderBlue,
        borderRadius: BorderRadius.circular(_kInputRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(_kInputRadius),
          onTap: () {
            if (globalKey.currentState!.validate()) {
              controller.getReports(start: controller.startdate.text, end: controller.enddate.text, name: controller.reportname!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.isLoading.value
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text('بحث', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  LEVEL 3: REPORT TOOLBAR (header + search + local filters)
  // ═══════════════════════════════════════════════════
  Widget _buildReportToolbar(ReportsController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Report title bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _kNeutralBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_kCardRadius),
              topRight: Radius.circular(_kCardRadius),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: Colors.grey.shade700, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getTableTitle(controller.reportname ?? ""),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey.shade900),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _kBorderColor),
                    ),
                    child: Text(
                      '${controller.filteredBranchs.length} سجل',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  )),
              const SizedBox(width: 6),
              _buildStatusBadge(),
            ],
          ),
        ),
        // ── Divider ──
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        // ── Search bar + local filters ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Single row: Search + All Filters ──
              Row(
                children: [
                  // Search field
                  SizedBox(
                    width: 220,
                    height: 36,
                    child: TextField(
                      controller: controller.searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'بحث داخل التقرير...',
                        hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, size: 16, color: Colors.grey.shade400),
                        filled: true,
                        fillColor: _kNeutralBg,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: _kHeaderBlue, width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // All filters in one row
                                  // All filters in one row
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('عرض:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                              _buildLocalFilterDropdown("الفرع", controller.availableBranches, controller.selectedFilterBranch),
                              _buildLocalFilterDropdown("المحطة", controller.availableStations, controller.selectedFilterStation),
                              _buildLocalFilterDropdown("السنة", controller.availableYears, controller.selectedFilterYear),
                              _buildLocalFilterDropdown("الشهر", controller.availableMonths, controller.selectedFilterMonth),
                              _buildLocalFilterDropdown("التقنية", controller.availableTechs, controller.selectedFilterTech),
                              _buildLocalFilterDropdown("السداد", controller.availableIsPaid, controller.selectedFilterIsPaid),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ── Bottom divider before table ──
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ],
    );
  }

  // ── Status badge ──
  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
          const SizedBox(width: 4),
          const Text('محدث', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
        ],
      ),
    );
  }

  // ── Local filters ──
  Widget _buildLocalFilterDropdown(String label, List<String> items, RxnString selectedValue) {
    final hasItems = items.isNotEmpty && !(items.length == 1 && items.first == "الكل");
    if (!hasItems) return const SizedBox.shrink();

    return Obx(() {
      return Container(
        height: 32,
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _kBorderColor),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
            value: items.contains(selectedValue.value) ? selectedValue.value : null,
            icon: Icon(Icons.unfold_more, size: 13, color: Colors.grey.shade400),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade900),
            items: items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (val) {
              selectedValue.value = val;
            },
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════
  //  STATES: LOADING / EMPTY
  // ═══════════════════════════════════════════════════
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 3, color: _kHeaderBlue),
          ),
          const SizedBox(height: 12),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
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
          Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'لا توجد بيانات للعرض',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 4),
          Text(
            'تأكد من اختيار التواريخ والفلاتر المناسبة',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  LEVEL 4: TABLE
  // ═══════════════════════════════════════════════════
  Widget _buildReportTable(ReportsController controller) {
    final ScrollController verticalController = ScrollController();
    final ScrollController horizontalController = ScrollController();
    final reportType = controller.reportname ?? '';

    Widget table = ReportTableFactory.forType(reportType, controller);

    return Scrollbar(
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
              constraints: BoxConstraints(minWidth: Get.width - 64),
              child: table,
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  TABLE TITLE LOOKUP
  // ═══════════════════════════════════════════════════
  String _getTableTitle(String reportName) {
    final titles = {
      "branch_per_month": "بيانات الفروع الشهرية",
      "branch_total": "إجمالي بيانات الفروع",
      "technology_per_month": "بيانات التكنولوجيا الشهرية",
      "technology_total": "إجمالي بيانات التكنولوجيا",
      "station-bills": "فواتير المحطات",
      "water-techs-3-month": "تقرير المياه",
      "sanity-techs-3-month": "تقرير الصرف",
      "over_power_consumption": "الأسنهلاك الزائد(كهرباء)",
      "bills": "تقرير الفواتير (المالي)",
      "station_total": "إجمالي المحطات",
      "station_per_month": "إجمالي المحطات شهرياً",
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
          Icon(icon, size: 13, color: Colors.grey.shade500),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }

  DataCell styledCell(String text, Color color) {
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 12)),
      ),
    );
  }

  DataCell dataCell(String text) {
    return DataCell(
      Text(text, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade800, fontSize: 13)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey,
      ),
      child: DataTable(
        columnSpacing: 20,
        horizontalMargin: 16,
        headingRowHeight: 42,
        dataRowHeight: 44,
        headingTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey.shade900),
        dataTextStyle: TextStyle(fontSize: 13, color: Colors.grey.shade800),
        headingRowColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFF1F5F9)),
        columns: buildColumns(),
        rows: buildRows(),
      ),
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
    final rows = controller.filteredBranchs.map((b) {
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
    .table-container { background: white; border-radius: 12px; overflow-x: auto; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; margin-top: 20px; }
    table { width: 100%; border-collapse: collapse; table-layout: auto; }
    th { background: linear-gradient(135deg, #2563eb, #1d4ed8); color: white; padding: 14px 10px; text-align: center; font-weight: bold; font-size: 14px; border-bottom: 2px solid #1d4ed8; white-space: nowrap; }
    td { padding: 14px 10px; border-bottom: 1px solid #f1f5f9; text-align: center; font-size: 13px; vertical-align: middle; }
    tr:nth-child(even) { background: #f8fafc; }
    tr:hover { background: #e0f2fe; transition: all 0.2s ease; }
    .highlight-cell { background: #dbeafe !important; color: #1e40af; font-weight: 600; }
    .paid-yes { background: #d1fae5 !important; color: #065f46; font-weight: 600; }
    .paid-no { background: #fee2e2 !important; color: #991b1b; font-weight: 600; }
    .summary-row { background: white !important; color: #1f2937; font-weight: bold; }
    .summary-row td { background: white !important; color: #1f2937; font-weight: bold; border-top: 2px solid #2563eb; border-bottom: 1px solid #e2e8f0; text-align: center; }
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
