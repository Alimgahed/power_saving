import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:power_saving/controller/analysis/analysis.dart';
import 'package:power_saving/controller/home/home.dart';
import 'package:power_saving/controller/voltage/voltage.dart';
import 'package:power_saving/model/home.dart';
import 'package:power_saving/model/vlotage.dart';
import 'package:power_saving/my_widget/home.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/view/analysis/analysis.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'لوحة التحكم الرئيسية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFF1E40AF)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.dashboard, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'نظام إدارة الطاقة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              list_view(
                icon: Icons.ev_station,
                text: "المحطات",
                ontap: () {
                  Get.toNamed("/Stations");
                },
              ),
              list_view(
                icon: Icons.charging_station_rounded,
                text: "العدادت",
                ontap: () {
                  Get.toNamed("/Countrts");
                },
              ),
              list_view(
                icon: Icons.price_change,
                text: "التعريفه",
                ontap: () async {
                  Voltage voltageController = Get.put(Voltage());
                  await voltageController.allVoltage();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(16),
                        content: SizedBox(
                          height: 280,
                          child: GetBuilder<Voltage>(
                            builder: (controller) {
                              final GlobalKey<FormState> _globalKey =
                                  GlobalKey<FormState>();

                              return Form(
                                key: _globalKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "الجهد المتوسط",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'الرسوم الثابتة',
                                            hintText: 'أدخل الرسوم الثابتة',
                                            controller: controller.avaargefixed,
                                            icon: Icons.attach_money,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'تكلفة الجهد',
                                            hintText: 'أدخل تكلفة الجهد',
                                            controller: controller.avaragecost,
                                            icon: Icons.electrical_services,
                                          ),
                                        ),
                                        Expanded(
                                          child: Obx(() {
                                            return Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_globalKey.currentState!
                                                      .validate()) {
                                                    controller.vlotages.add(
                                                      VoltagePlan(
                                                        fixedFee:
                                                            double.tryParse(
                                                              controller
                                                                  .lowfixed
                                                                  .text,
                                                            )!,
                                                        voltageCost:
                                                            double.tryParse(
                                                              controller
                                                                  .lowcost
                                                                  .text,
                                                            )!,
                                                        voltageId: 1,
                                                        voltageType: 'منخفض',
                                                      ),
                                                    );

                                                    controller.vlotages.add(
                                                      VoltagePlan(
                                                        fixedFee:
                                                            double.tryParse(
                                                              controller
                                                                  .avaargefixed
                                                                  .text,
                                                            )!,
                                                        voltageCost:
                                                            double.tryParse(
                                                              controller
                                                                  .avaragecost
                                                                  .text,
                                                            )!,
                                                        voltageId: 2,
                                                        voltageType: 'متوسط',
                                                      ),
                                                    );
                                                    await controller.editVoltage(
                                                      volt: VoltagePlan(
                                                        fixedFee:
                                                            double.tryParse(
                                                              controller
                                                                  .avaargefixed
                                                                  .text,
                                                            )!,
                                                        voltageCost:
                                                            double.tryParse(
                                                              controller
                                                                  .avaragecost
                                                                  .text,
                                                            )!,
                                                        voltageId: 2,
                                                        voltageType: 'متوسط',
                                                      ),
                                                      voltid: 2,
                                                    );
                                                  }
                                                },
                                                child:
                                                    controller.isLoading.value
                                                        ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                        )
                                                        : const Text("حفظ"),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "الجهد المنخفض",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'الرسوم الثابتة',
                                            hintText: 'أدخل الرسوم الثابتة',
                                            controller: controller.lowfixed,
                                            icon: Icons.attach_money,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFormField(
                                            label: 'تكلفة الجهد',
                                            hintText: 'أدخل تكلفة الجهد',
                                            controller: controller.lowcost,
                                            icon: Icons.electrical_services,
                                          ),
                                        ),
                                        Expanded(
                                          child: Obx(() {
                                            return Center(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_globalKey.currentState!
                                                      .validate()) {
                                                    await controller
                                                        .editVoltage(
                                                          volt: VoltagePlan(
                                                            fixedFee:
                                                                double.tryParse(
                                                                  controller
                                                                      .lowfixed
                                                                      .text,
                                                                )!,
                                                            voltageCost:
                                                                double.tryParse(
                                                                  controller
                                                                      .lowcost
                                                                      .text,
                                                                )!,
                                                            voltageId: 1,
                                                            voltageType:
                                                                'منخفض',
                                                          ),
                                                          voltid: 1,
                                                        );
                                                  }
                                                },
                                                child:
                                                    controller.isLoading.value
                                                        ? const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                        )
                                                        : const Text("حفظ"),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              list_view(
                icon: Icons.memory,
                text: "التكنولوجيا",
                ontap: () {
                  Get.toNamed("/Technology");
                },
              ),
              list_view(
                icon: Icons.ac_unit_sharp,
                text: "الربط",
                ontap: () {
                  Get.toNamed("/Relations");
                },
              ),
              list_view(
                icon: Icons.science,
                text: "الكماويات",
                ontap: () {
                  Get.toNamed("/Chemicals");
                },
              ),
              list_view(
                icon: Icons.engineering,
                text: "المكتب الفني",
                ontap: () {
                  Get.toNamed("/techbills");
                },
              ),

              list_view(
                icon: Icons.water_drop_outlined,
                text: "التوقعات",
                ontap: () {
                  Get.toNamed('./Predictions');
                },
              ),
              list_view(icon: Icons.bar_chart, text: "التقارير", ontap: () {}),
              list_view(
                icon: Icons.person_add_alt_outlined,
                text: "مستخدم جديد",
                ontap: () {
                  Get.toNamed('/NewUser');
                },
              ),
              list_view(
                icon: Icons.login,
                text: "تسجل دخول",
                ontap: () {
                  Get.toNamed("/Login");
                },
              ),
              list_view(icon: Icons.logout, text: "تسجيل خروج", ontap: () {}),
            ],
          ),
        ),
        body: GetBuilder<homecontroller>(
          init: homecontroller(),
          builder: (controller) {
            if (controller.looading.value == true) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1E40AF)),
              );
            }

            final data = controller.consumptionModel!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Main Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'إجمالي التكلفة',
                                  '${NumberFormat('#,###').format(controller.animatedMoney.value ?? 0)} جنيه',
                                  Icons.attach_money,
                                  Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية المياة المنتجة',
                                  '${NumberFormat('#,###').format(controller.animatedWater.value ?? 0)} م³',
                                  Icons.opacity,
                                  Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الكهرياء المستهلكة',
                                  '${NumberFormat('#,###').format(controller.animatedPower.value ?? 0)} واط',
                                  Icons.electrical_services,
                                  Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الكلور',
                                  '${NumberFormat('#,###').format(controller.animatedChlorine.value ?? 0)} جرام',
                                  Icons.science,
                                  Colors.cyan,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الشبة السائلة',
                                  '${NumberFormat('#,###').format(controller.animatedLiquidAlum.value ?? 0)} جرام',
                                  Icons.water_drop_outlined,
                                  Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الشبة الصلبة',
                                  '${NumberFormat('#,###').format(controller.animatedSolidAlum.value ?? 0)} جرام',
                                  Icons.ac_unit,
                                  Colors.brown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Grid Stats

                  // Over Consumption Sections
                  const SizedBox(height: 24),
                  if (data.overPowerConsump.isNotEmpty)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للطاقة',

                      data.overPowerConsump,
                      "الكهرباء",
                      "واط", // Remove fixed value since it varies per item
                      Icons.electrical_services,
                      Icons.electrical_services,
                      Colors.cyan,
                    ),

                  if (data.overChlorineConsump.isNotEmpty)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للكلور',
                      data.overChlorineConsump,
                      "الكلور",
                      "مجم/لتر", // Remove fixed value since it varies per item
                      Icons.water_drop,
                      Icons.water_drop,
                      Colors.cyan,
                    ),

                  if (data.overLiquidAlumConsump.isNotEmpty)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للشبة السائلة',
                      data.overLiquidAlumConsump,
                      "الشبة السائلة",
                      "مجم/لتر", // Remove the fixed value since it varies per item
                      Icons.opacity,
                      Icons.opacity,
                      Colors.cyan,
                    ),

                  if (data.overSolidAlumConsump.isNotEmpty)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للشبة الصلبة',
                      data.overSolidAlumConsump,
                      "الشبة الصلبة",
                      "مجم/لتر", // Remove fixed value since it varies per item
                      Icons.grain,
                      Icons.grain,
                      Colors.cyan,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Summary Stat Card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Consumption Stat Card

  // Overconsumption Section
  // Fixed method calls for the over-consumption sections

  // Here's the corrected _buildOverConsumptionSection method
  Widget _buildOverConsumptionSection(
    String title,
    List<OverConsump> data,
    String label,
    String value,
    IconData icon,
    IconData icons,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 20,
                children:
                    data.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/analysis',
                            arguments: {
                              'station': item.stationId,
                              'tech': item.technologyId,
                            },
                          );
                        },
                        child: Container(
                          width: 250, // You control the width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                spreadRadius: 0,
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize:
                                MainAxisSize.min, // Allow dynamic height
                            children: [
                              // Header Section
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade600,
                                      Colors.blue.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.electric_meter,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'محطة ${item.stationName}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Content Section
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailItem(
                                      'الشهر/السنة',
                                      '${item.billMonth} / ${item.billYear}',
                                      Icons.date_range,
                                      Colors.blue,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDetailItem(
                                      'التقنية',
                                      item.technologyName,
                                      Icons.memory,
                                      Colors.teal,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildDetailItem(
                                      label,
                                      _getItemValue(item, label),
                                      icons,
                                      Colors.indigo,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the appropriate value for each item
  String _getItemValue(OverConsump item, String label) {
    switch (label) {
      case "الكهرباء":
        return "${NumberFormat('#,###').format(item.technologyPowerConsump)} واط";
      case "الكلور":
        return "${NumberFormat('#,###').format(item.technologyChlorineConsump)} جرام";
      case "الشبة السائلة":
        return "${NumberFormat('#,###').format(item.technologyLiquidAlumConsump)} جرام";
      case "الشبة الصلبة":
        return "${NumberFormat('#,###').format(item.technologySolidAlumConsump)} جرام";
      default:
        return "";
    }
  }

  // Detail Item Widget
  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
