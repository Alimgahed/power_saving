import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/predaction/controller/prediaction.dart';
import 'package:power_saving/features/stations/controller/all_stations_controller.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

class Predaction extends StatelessWidget {
  Predaction({super.key});

  final StationsController stationsController = Get.put(StationsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? stationId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'تحليل التنبؤ بالمياه',
      mobileAppBar: const CustomAppBar(
        title: 'تحليل التنبؤ بالمياه',
        backRoute: '/home',
      ),
      desktopHeader: const CustomAppBar(
        title: 'تحليل التنبؤ بالمياه',
        backRoute: '/home',
      ),
      body: GetBuilder<Prediactioncontroller>(
        init: Prediactioncontroller(),
        builder: (controller) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Page Header
                          const Text(
                            "لوحة التنبؤات والتحليلات",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "قم باختيار المحطة لعرض التنبؤات والتحليلات الذكية لاستهلاك وإنتاج المياه.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Station Selection Card
                          _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle("اختر المحطة", Icons.domain_rounded, Colors.indigo),
                                const SizedBox(height: 24),
                                _buildStationSelector(controller),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Results Section
                          if (controller.predictionModel == null)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.auto_graph_rounded, size: 64, color: Colors.blueGrey.shade100),
                                    const SizedBox(height: 16),
                                    Text(
                                      "الرجاء اختيار محطة للبدء بالتنبؤ",
                                      style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade400, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else ...[
                            // KPI Metrics Row
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 600) {
                                  return Column(
                                    children: _buildKpiCards(controller),
                                  );
                                } else {
                                  return Row(
                                    children: _buildKpiCards(controller)
                                        .map((card) => Expanded(child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: card,
                                            )))
                                        .toList(),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 24),

                            // Chart Card
                            _buildChartCard(controller.predictionModel!.predictionPlot),
                            const SizedBox(height: 40),
                          ],
                        ],
                      ),
                    ),
              ),

              // Loading Overlay
              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(strokeWidth: 3),
                            const SizedBox(height: 16),
                            Text(
                              "جاري حساب التنبؤات...",
                              style: TextStyle(color: Colors.blueGrey.shade700, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStationSelector(Prediactioncontroller controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Obx(() {
            return CustomDropdownFormField<int>(
              items: stationsController.stations.map((station) {
                return DropdownMenuItem<int>(
                  value: station.stationId,
                  child: Text(station.stationName),
                );
              }).toList(),
              onChanged: (value) => stationId = value,
              labelText: 'المحطة',
              hintText: 'اختر المحطة من القائمة',
              prefixIcon: Icons.map,
              validator: (val) => val == null ? 'الرجاء اختيار المحطة' : null,
            );
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Container(
            height: 56, // Matching the standard CustomDropdownFormField height roughly
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.indigo.shade600],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.prediactions(stationId!);
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.query_stats_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "بدء التنبؤ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildKpiCards(Prediactioncontroller controller) {
    return [
      _buildInfoCard(
        "السنة المتوقعة",
        controller.predictionModel!.expectedYear.toString(),
        Icons.calendar_month_rounded,
        Colors.orange,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        "الطاقة التصميمية",
        "${controller.predictionModel!.waterCapacity} م³",
        Icons.water_drop_rounded,
        Colors.blue,
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        "دقة التوقع",
        "${controller.predictionModel!.representedPoints.toStringAsFixed(1)}%",
        Icons.track_changes_rounded,
        Colors.green,
      ),
    ];
  }

  Widget _buildChartCard(String base64Image) {
    return _buildCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.show_chart_rounded, color: Colors.blue.shade700, size: 22),
                const SizedBox(width: 12),
                const Text(
                  "المخطط البياني للتوقعات",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(base64Image),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Center(
                      child: Text(
                        "خطأ في تحميل المخطط البياني",
                        style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
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

  Widget _buildCard({required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(24)}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.04),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
