import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:power_saving/features/tech_bills/controller/new_tech_bills.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

class NewTechBillsScreen extends StatelessWidget {
  const NewTechBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const appBarWidget = CustomAppBar(
      title: "إضافة فاتورة تقنية",
      backRoute: '/home', // Or relevant back route
    );

    return AppScaffold(
      title: "إضافة فاتورة تقنية",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: GetBuilder<NewTechBillsController>(
        init: NewTechBillsController(),
        builder: (controller) {
          return Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Page Header
                        const Text(
                          "أدخل بيانات الفاتورة التقنية",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "يرجى التأكد من صحة البيانات والمحطة المحددة قبل الحفظ.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 32),

                        /// 🔷 FILTER CARD
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("اختيار البيانات", Icons.account_balance_rounded, Colors.indigo),
                              const SizedBox(height: 24),

                              _buildResponsiveRow([
                                _buildDropdown(
                                  label: "الفرع",
                                  icon: Icons.business,
                                  value: controller.selectedBranch.value,
                                  items: controller
                                      .getBranches()
                                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (value) => controller.filterByBranch(value),
                                ),
                                _buildDropdown(
                                  label: "المحطة",
                                  icon: Icons.map,
                                  value: controller.selectedStation,
                                  items: controller.filteredStations
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.stationName),
                                          ))
                                      .toList(),
                                  onChanged: (value) => controller.onStationChanged(value),
                                ),
                              ]),

                              if (controller.selectedBranch.value != null && controller.filteredStations.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'لا توجد محطات في هذا الفرع',
                                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                                  ),
                                ),

                              const SizedBox(height: 16),

                              if (controller.selectedStation != null)
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdown(
                                        label: "التكنولوجيا",
                                        icon: Icons.engineering,
                                        value: controller.selectedTech,
                                        items: controller.selectedStation!.techs
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.technologyName),
                                                ))
                                            .toList(),
                                        onChanged: (value) => controller.onTechChanged(value),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Spacer(), // Keeps dropdown half-width on large screens
                                  ],
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 🔷 DATE CARD
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("التاريخ", Icons.calendar_today_rounded, Colors.amber.shade700),
                              const SizedBox(height: 24),

                              _buildResponsiveRow([
                                _buildInput(
                                  controller.monthController,
                                  "الشهر",
                                  Icons.calendar_month,
                                ),
                                _buildInput(
                                  controller.yearController,
                                  "السنة",
                                  Icons.date_range,
                                ),
                              ]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// 🔷 VALUES CARD
                        _buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("القيم والإحصائيات", Icons.analytics_rounded, Colors.teal),
                              const SizedBox(height: 24),

                              _buildResponsiveRow([
                                _buildInput(
                                  controller.measuredWaterController,
                                  "كمية المياه المقاسة",
                                  Icons.water,
                                ),
                                _buildInput(
                                  controller.calculatedWaterController,
                                  "كمية المياه المحسوبة",
                                  Icons.water_drop,
                                ),
                              ]),
                              const SizedBox(height: 16),

                              _buildResponsiveRow([
                                _buildInput(
                                  controller.waterProducedController,
                                  "كمية المياه المنتجة",
                                  Icons.waves,
                                ),
                                _buildInput(
                                  controller.chlorineController,
                                  "الكلور",
                                  Icons.science,
                                ),
                              ]),
                              const SizedBox(height: 16),

                              _buildResponsiveRow([
                                _buildInput(
                                  controller.liquidAlumController,
                                  "الشبة السائلة",
                                  Icons.opacity,
                                ),
                                _buildInput(
                                  controller.solidAlumController,
                                  "الشبة الصلبة",
                                  Icons.ac_unit,
                                ),
                              ]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// 🔷 PREMIUM SUBMIT BUTTON
                        _buildSubmitButton(controller),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              /// 🔄 LOADING OVERLAY
              Obx(() => controller.loading.value
                  ? Container(
                      color: Colors.white.withOpacity(0.7),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink()),
            ],
          );
        },
      ),
    );
  }

  /// 🔹 Premium Reusable Card
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.04),
            blurRadius: 24,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  /// 🔹 Responsive Row Helper (Side-by-side on wide, stacked on narrow)
  Widget _buildResponsiveRow(List<Widget> children) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return Column(
            children: children
                .map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: child,
                    ))
                .toList(),
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: child,
                      ),
                    ))
                .toList(),
          );
        }
      },
    );
  }

  /// 🔹 Modern Section Title
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

  /// 🔹 Modern Styled Input
  Widget _buildInput(TextEditingController controller, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: CustomTextFormField(
        controller: controller,
        label: label,
        icon: icon,
        allowOnlyDigits: true,
      ),
    );
  }

  /// 🔹 Modern Styled Dropdown
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required dynamic value,
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
  }) {
    return DropdownButtonFormField(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF64748B)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF64748B)),
        prefixIcon: Icon(icon, color: Colors.blue.shade600, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
        ),
      ),
    );
  }

  /// 🔹 Premium Submit Action Button
  Widget _buildSubmitButton(NewTechBillsController controller) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.indigo.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (controller.selectedStation == null || controller.selectedTech == null) {
              showCustomErrorDialog(errorMessage: "من فضلك اختر المحطة والتكنولوجيا");
              return;
            }

            if (controller.monthController.text.isEmpty || controller.yearController.text.isEmpty) {
              showCustomErrorDialog(errorMessage: "من فضلك ادخل الشهر والسنة");
              return;
            }

            controller.addTechBills(
              staionid: controller.selectedStation!.stationId,
              techid: controller.selectedTech!.technologyId!,
              chlorine: double.tryParse(controller.chlorineController.text) ?? 0,
              calculatedWater: double.tryParse(controller.calculatedWaterController.text) ?? 0,
              measuredWater: double.tryParse(controller.measuredWaterController.text) ?? 0,
              liquid: double.tryParse(controller.liquidAlumController.text) ?? 0,
              solid: double.tryParse(controller.solidAlumController.text) ?? 0,
              water: double.tryParse(controller.waterProducedController.text) ?? 0,
              index: 0,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "حفظ البيانات الجديدة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}