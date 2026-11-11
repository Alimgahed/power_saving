import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/model/ml_forecast_model.dart';

class MLForecastResultScreen extends StatefulWidget {
  final MLForecastResponse result;

  const MLForecastResultScreen({super.key, required this.result});

  @override
  State<MLForecastResultScreen> createState() => _MLForecastResultScreenState();
}

class _MLForecastResultScreenState extends State<MLForecastResultScreen> {
  int _currentPage = 1;
  final int _pageSize = 10;
  int? _selectedFilterMonth;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9), // light slate background
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBreadcrumbsAndTitle(),
                const SizedBox(height: 20),
                _buildMetricsSection(),
                const SizedBox(height: 20),
                _buildAreasTableSection(),
                const SizedBox(height: 20),
                _buildBottomRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Header / Breadcrumbs
  // ---------------------------------------------------------
  Widget _buildBreadcrumbsAndTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Right side: Breadcrumbs & Back
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF475569)),
              onPressed: () => Get.back(),
              tooltip: 'رجوع',
            ),
            const SizedBox(width: 4),
            const Icon(Icons.home_outlined, size: 18, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left, size: 16, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Text(
              'التنبؤات والذكاء الاصطناعي',
              style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade700, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_left, size: 16, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            const Text(
              'نتائج التنبؤ (تعلم الآلة)',
              style: TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // Left side: Screen Title & Subtitle with Icon
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'نتائج التنبؤ (تعلم الآلة)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'تحليل استهلاك المياه والتنبؤ بالقيم المستقبلية لكل منطقة',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Icon(Icons.psychology_outlined, color: Color(0xFF2563EB), size: 28),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // Metrics Row (Model Performance Cards)
  // ---------------------------------------------------------
  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'ملخص أداء النموذج (Model Metrics)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(width: 8),
            Icon(Icons.bar_chart_rounded, color: Colors.blue.shade700, size: 24),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // 1. معامل التحديد (CV R²)
                Expanded(
                  child: _buildMetricCard(
                    title: 'معامل التحديد (R²)',
                    value: '${widget.result.cvR2Mean.toStringAsFixed(3)} ± ${widget.result.cvR2Std.toStringAsFixed(3)}',
                    icon: Icons.verified_outlined,
                    iconColor: const Color(0xFF2563EB),
                    bgIconColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. متوسط الخطأ المطلق (MAE)
                Expanded(
                  child: _buildMetricCard(
                    title: 'متوسط الخطأ المطلق (MAE)',
                    value: widget.result.finalMae.toStringAsFixed(2),
                    icon: Icons.stacked_line_chart,
                    iconColor: const Color(0xFF2563EB),
                    bgIconColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 12),

                // 3. دقة التنبؤ النهائية (R²)
                Expanded(
                  child: _buildMetricCard(
                    title: 'دقة التنبؤ (R² النهائية)',
                    value: widget.result.finalR2.toStringAsFixed(4),
                    icon: Icons.show_chart,
                    iconColor: const Color(0xFF2563EB),
                    bgIconColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 12),

                // 4. مجموعة الخصائص
                Expanded(
                  child: _buildMetricCard(
                    title: 'مجموعة الخصائص',
                    value: widget.result.featureSet,
                    icon: Icons.layers_outlined,
                    iconColor: const Color(0xFF2563EB),
                    bgIconColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 12),

                // 5. أفضل نموذج + Smearing Factor
                Expanded(
                  child: _buildBestModelWithSmearingCard(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgIconColor,
  }) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestModelWithSmearingCard() {
    return Column(
      children: [
        Container(
          height: widget.result.smearingFactor != null ? 52 : 90,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.hub_outlined, color: Color(0xFF2563EB), size: 18),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('أفضل نموذج', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  Text(
                    widget.result.bestModel,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.result.smearingFactor != null) ...[
          const SizedBox(height: 4),
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.result.smearingFactor!.toStringAsFixed(4),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const Row(
                  children: [
                    Text(
                      'معامل Smearing',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 4),
                    Text('Σ', style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------
  // Main Table Section
  // ---------------------------------------------------------
  Widget _buildAreasTableSection() {
    final entries = widget.result.allAreasSaturation.entries.toList();

    // Filter by peak month if selected
    final filteredEntries = _selectedFilterMonth == null
        ? entries
        : entries.where((e) => e.value.peakMonth == _selectedFilterMonth).toList();

    final totalItems = filteredEntries.length;
    final totalPages = (totalItems / _pageSize).ceil().clamp(1, 9999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final pageEntries = filteredEntries.sublist(
      startIndex.clamp(0, totalItems),
      endIndex,
    );

    // Requested area details if available
    final reqArea = widget.result.requestedAreaSaturation;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table Header Bar: Title on right, controls on left
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Right: Section Title
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Color(0xFF1E3A8A), size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'نتائج التنبؤ حسب المناطق',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),

              // Left: Requested Area Date & Month Selector
              Row(
                children: [
                  // Month filter dropdown
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: _selectedFilterMonth,
                        hint: const Row(
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 16, color: Color(0xFF2563EB)),
                            SizedBox(width: 6),
                            Text('جميع الشهور', style: TextStyle(fontSize: 12, color: Color(0xFF334155))),
                          ],
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('جميع الشهور', style: TextStyle(fontSize: 12)),
                          ),
                          ...List.generate(12, (index) => index + 1).map((m) {
                            return DropdownMenuItem<int?>(
                              value: m,
                              child: Text('شهر $m', style: const TextStyle(fontSize: 12)),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _selectedFilterMonth = val;
                            _currentPage = 1;
                          });
                        },
                      ),
                    ),
                  ),

                  if (reqArea != null && reqArea.year != null && reqArea.month != null) ...[
                    const SizedBox(width: 10),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'التاريخ المتوقع للتشبع: شهر ${reqArea.month} سنة ${reqArea.year}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.event_available, color: Color(0xFFD97706), size: 18),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom Data Table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(55),  // #
                  1: FlexColumnWidth(2.8),  // المنطقة
                  2: FlexColumnWidth(3.4),  // نسبة الاستهلاك الحالية
                  3: FlexColumnWidth(1.5),  // شهر الذروة
                  4: FlexColumnWidth(2.0),  // تاريخ التنبؤ المتوقع
                  5: FlexColumnWidth(1.5),  // الحالة
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Table Header
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                    children: [
                      _buildHeaderCell('#'),
                      _buildHeaderCell('المنطقة'),
                      _buildHeaderCell('نسبة الاستهلاك الحالية من السعة'),
                      _buildHeaderCell('شهر الذروة'),
                      _buildHeaderCell('تاريخ التنبؤ المتوقع'),
                      _buildHeaderCell('الحالة'),
                    ],
                  ),

                  // Table Rows
                  ...pageEntries.asMap().entries.map((entry) {
                    final indexOnPage = entry.key;
                    final itemIndex = startIndex + indexOnPage + 1;
                    final areaEntry = entry.value;
                    final area = areaEntry.value;
                    final isEven = indexOnPage % 2 == 0;

                    return TableRow(
                      decoration: BoxDecoration(
                        color: isEven ? Colors.white : const Color(0xFFF8FAFC),
                      ),
                      children: [
                        _buildCellText(itemIndex.toString()),
                        _buildCellText(area.areaName ?? 'المنطقة ${areaEntry.key}', isBold: true),
                        _buildUtilizationCell(area.utilization ?? 0.0),
                        _buildCellText(area.peakMonth?.toString() ?? '-'),
                        _buildCellText(
                          (area.year != null && area.month != null)
                              ? '${area.year}/${area.month}'
                              : (area.warning == 'already_exceeded' ? 'متجاوز' : '-'),
                        ),
                        _buildStatusBadge(area),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Pagination Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Right: Total statistics
              Text(
                'إجمالي المناطق: ${widget.result.allAreasSaturation.length}  |  عدد الشهور: ${widget.result.dataQuality?.nMonths ?? 0}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),

              // Left: Page numbers
              Row(
                children: [
                  _buildPageButton(
                    icon: Icons.chevron_right,
                    onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  ),
                  const SizedBox(width: 4),
                  ...List.generate(totalPages, (i) {
                    final pageNum = i + 1;
                    if (pageNum > 5 && pageNum < totalPages) {
                      if (pageNum == 6) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('...', style: TextStyle(color: Colors.grey)),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                    final isSelected = pageNum == _currentPage;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => setState(() => _currentPage = pageNum),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            '$pageNum',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 4),
                  _buildPageButton(
                    icon: Icons.chevron_left,
                    onTap: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  Widget _buildCellText(String text, {bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildUtilizationCell(double utilization) {
    final percent = (utilization * 100);
    final clampedRatio = (utilization).clamp(0.0, 1.0);

    Color barColor = const Color(0xFF22C55E); // Green
    if (percent >= 100) {
      barColor = const Color(0xFFEF4444); // Red
    } else if (percent >= 80) {
      barColor = const Color(0xFF3B82F6); // Blue
    } else if (percent >= 75) {
      barColor = const Color(0xFFF59E0B); // Amber
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: clampedRatio,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 46,
            child: Text(
              '%${percent.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: barColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(MLSaturationResult area) {
    final util = (area.utilization ?? 0) * 100;
    final isExceeded = util >= 100 || area.warning == 'already_exceeded';
    final isCritical = util >= 90;
    final isWarning = util >= 75;

    Color bg = const Color(0xFFDCFCE7);
    Color fg = const Color(0xFF16A34A);
    String label = 'مستقر';

    if (isExceeded) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFDC2626);
      label = 'تجاوز';
    } else if (isCritical) {
      bg = const Color(0xFFFFEDD5);
      fg = const Color(0xFFEA580C);
      label = 'حرج';
    } else if (isWarning) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      label = 'تحذير';
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActionsCell(String areaId, MLSaturationResult area) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _showAreaDetailsDialog(areaId, area),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left, size: 14, color: Color(0xFF2563EB)),
              SizedBox(width: 4),
              Text(
                'عرض التفاصيل',
                style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Bottom Row: At-risk Count & Data Quality
  // ---------------------------------------------------------
  Widget _buildBottomRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Right side: المناطق المعرضة للخطر (العدد فقط كما طلب المستخدم)
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'المناطق المعرضة للخطر (${widget.result.atRiskAreas.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${widget.result.atRiskAreas.length}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'إجمالي عدد المناطق المعرضة للخطر',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF991B1B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'مناطق تجاوزت أو ستصل للتشبع خلال الـ 10 سنوات القادمة وفقاً للنموذج.',
                                  style: TextStyle(fontSize: 11, color: Colors.red.shade700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Left side: جودة البيانات (Data Quality)
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'جودة البيانات (Data Quality)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3 Mini cards (إجمالي السجلات، عدد المناطق، عدد الشهور)
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataQualityMiniCard(
                          title: 'إجمالي السجلات',
                          value: '${widget.result.dataQuality?.totalRows ?? 0}',
                          icon: Icons.storage_rounded,
                          color: const Color(0xFF2563EB),
                          bgColor: const Color(0xFFEFF6FF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDataQualityMiniCard(
                          title: 'عدد المناطق',
                          value: '${widget.result.dataQuality?.nAreas ?? 0}',
                          icon: Icons.calendar_today_outlined,
                          color: const Color(0xFF10B981),
                          bgColor: const Color(0xFFECFDF5),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDataQualityMiniCard(
                          title: 'عدد الشهور',
                          value: '${widget.result.dataQuality?.nMonths ?? 0}',
                          icon: Icons.access_time_rounded,
                          color: const Color(0xFFF59E0B),
                          bgColor: const Color(0xFFFFFBEB),
                        ),
                      ),
                    ],
                  ),

                  // Warnings box
                  if (widget.result.dataQuality?.warnings.isNotEmpty ?? false) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFD97706), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.result.dataQuality!.warnings.join(' | '),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataQualityMiniCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Dialog: تفاصيل المنطقة
  // ---------------------------------------------------------
  void _showAreaDetailsDialog(String areaId, MLSaturationResult area) {
    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      area.areaName ?? 'تفاصيل المنطقة $areaId',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildDialogRow('نسبة الاستهلاك الحالية:', '%${((area.utilization ?? 0) * 100).toStringAsFixed(1)}'),
                _buildDialogRow('شهر الذروة:', '${area.peakMonth ?? "-"}'),
                _buildDialogRow(
                  'تاريخ التشبع المتوقع:',
                  (area.year != null && area.month != null) ? '${area.year}/${area.month}' : 'غير محدد',
                ),
                if (area.popMax != null)
                  _buildDialogRow('الحد الأقصى للسكان المستوعب:', '${area.popMax} نسمة'),
                if (area.warning != null)
                  _buildDialogRow('تنبيه:', area.warning!, isWarning: true),
                if (area.scenarios != null && area.scenarios!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('السيناريوهات السكانية المتوقعة:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...area.scenarios!.entries.map((e) {
                    final s = e.value as Map<String, dynamic>;
                    String label = e.key;
                    if (label == 'pessimistic') label = 'السيناريو المتشائم';
                    if (label == 'expected') label = 'السيناريو المتوقع';
                    if (label == 'optimistic') label = 'السيناريو المتفائل';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• $label: ${s['year'] != null ? '${s['year']}/${s['month']}' : 'غير محدد'}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text('إغلاق'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogRow(String title, String val, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(
            val,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
