import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/widgets/request_error_view.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/features/analysis/controller/analysis.dart';
import 'package:power_saving/features/analysis/model/analysis.dart';
import 'package:power_saving/features/home/model/home.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});
  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  final int? station = Get.arguments != null ? Get.arguments['station'] : null;
  final int? tech = Get.arguments != null ? Get.arguments['tech'] : null;
  final OverConsump? data = Get.arguments != null ? Get.arguments['data'] : null;

  final Analysis controller = Get.put(Analysis());

  @override
  void initState() {
    super.initState();
    if (station != null && tech != null) {
      controller.getAnalysis(station: station!, tech: tech!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If navigated without arguments, return back safely
    if (station == null || tech == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
        Get.back();
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return PopScope(
      canPop: true,
      child: AppScaffold(
        title: 'التحليل الاقتصادي والإحصاءات',
        showDrawer: false,
        mobileAppBar: const CustomAppBar(
          title: 'التحليل الاقتصادي والإحصاءات',
        ),
        desktopHeader: const CustomAppBar(
          title: 'التحليل الاقتصادي والإحصاءات',
        ),
        body: GetBuilder<Analysis>(
          builder: (controller) {
            if (controller.errorMessage.isNotEmpty) {
              return RequestErrorView(message: controller.errorMessage,
                onRetry: () => controller.getAnalysis(station: station!, tech: tech!));
            }
            if (controller.isLoading || controller.anl == null) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'جاري إعداد وتحليل البيانات...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'يتم رسم وتوليد المنحنيات البيانية لاستهلاكات المحطة',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              );
            }

            final List<Map<String, dynamic>> charts = _extractChartsList(controller.anl!);

            if (charts.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(36),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.analytics_outlined, size: 48, color: Colors.amber.shade700),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'لا توجد رسوم بيانية متاحة',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'لم يتم العثور على فواتير أو بيانات كافية لرسم منحنيات هذه المحطة.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text('العودة للمحطات'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderSection(context, charts.length),
                  const SizedBox(height: 20),
                  _buildChartsGrid(context, charts),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, int chartsCount) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right: Info & breadcrumb-style title
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF475569)),
                onPressed: () => Get.back(),
                tooltip: 'رجوع',
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Icon(Icons.stacked_line_chart_rounded, color: Color(0xFF2563EB), size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'لوحة التحليل الاقتصادي والإحصاءات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'منحنيات تتبع ومقارنة استهلاك المواد والطاقة بالمقارنة مع معدلات التشغيل',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600),
                  ),
                ],
              ),
            ],
          ),

          // Left: Count Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.pie_chart_outline, size: 18, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Text(
                  'عدد المنحنيات: $chartsCount',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _extractChartsList(AnalysisModel model) {
    final List<Map<String, dynamic>> list = [];

    if (model.clorhine.isNotEmpty) {
      list.add({
        'title': 'منحنى استهلاك الكلور',
        'subtitle': 'مقارنة استهلاك الكلور بالنسبة لكمية المياه المنتجة',
        'image': model.clorhine,
        'icon': Icons.water_damage_outlined,
        'color': const Color(0xFF0284C7),
      });
    }

    if (model.power.isNotEmpty) {
      list.add({
        'title': 'منحنى استهلاك الطاقة الكهربائية',
        'subtitle': 'مقارنة استهلاك الطاقة الكهربائية ومعدلات التشغيل',
        'image': model.power,
        'icon': Icons.bolt_outlined,
        'color': const Color(0xFFD97706),
      });
    }

    if (model.liquid.isNotEmpty) {
      list.add({
        'title': 'منحنى الشبة السائلة',
        'subtitle': 'مقارنة استهلاك الشبة السائلة بالنسبة للإنتاج',
        'image': model.liquid,
        'icon': Icons.opacity_outlined,
        'color': const Color(0xFF059669),
      });
    }

    if (model.soild.isNotEmpty) {
      list.add({
        'title': 'منحنى الشبة الصلبة',
        'subtitle': 'مقارنة استهلاك الشبة الصلبة بالنسبة للإنتاج',
        'image': model.soild,
        'icon': Icons.grain_outlined,
        'color': const Color(0xFF7C3AED),
      });
    }

    return list;
  }

  Widget _buildChartsGrid(BuildContext context, List<Map<String, dynamic>> charts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // 2 columns for desktop/large screen, 1 column for smaller screens
        final int columns = width >= 900 ? 2 : 1;
        const double spacing = 20.0;
        final double cardWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: charts.map((item) {
            return SizedBox(
              width: cardWidth,
              child: _buildChartCard(context, item),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildChartCard(BuildContext context, Map<String, dynamic> item) {
    final String title = item['title'];
    final String subtitle = item['subtitle'];
    final String base64Image = item['image'];
    final IconData icon = item['icon'];
    final Color color = item['color'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen_rounded, color: Color(0xFF64748B), size: 22),
                  onPressed: () => _showFullScreenImage(context, base64Image, title),
                  tooltip: 'عرض بحجم الشاشة',
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Image View with gesture detector to enlarge
          InkWell(
            onTap: () => _showFullScreenImage(context, base64Image, title),
            child: Container(
              height: 380,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFFAFAFA),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  base64Decode(base64Image),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_outlined, color: Colors.grey.shade400, size: 36),
                          const SizedBox(height: 8),
                          Text('تعذر تحميل المنحنى', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String base64Image, String chartTitle) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.show_chart, color: Color(0xFF2563EB), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        chartTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              // Image
              Expanded(
                child: Container(
                  color: const Color(0xFFF1F5F9),
                  padding: const EdgeInsets.all(16),
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20),
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.memory(
                        base64Decode(base64Image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
