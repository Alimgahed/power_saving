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
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      /// 🔷 FILTER CARD
                      _buildCard(
                        child: Column(
                          children: [
                            _buildSectionTitle("اختيار البيانات"),

                            const SizedBox(height: 12),

                            _buildDropdown(
                              label: "الفرع",
                              icon: Icons.business,
                              value: controller.selectedBranch.value,
                              items: controller
                                  .getBranches()
                                  .map((e) =>
                                      DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) => controller.filterByBranch(value),
                            ),

                            const SizedBox(height: 12),

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

                            if (controller.selectedBranch.value != null &&
                                controller.filteredStations.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'لا توجد محطات في هذا الفرع',
                                  style: TextStyle(
                                      color: Colors.red.shade700),
                                ),
                              ),

                            const SizedBox(height: 12),

                            if (controller.selectedStation != null)
                              _buildDropdown(
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔷 DATE CARD
                      _buildCard(
                        child: Column(
                          children: [
                            _buildSectionTitle("التاريخ"),
                            const SizedBox(height: 12),

                            _buildInput(
                              controller.monthController,
                              "الشهر",
                              Icons.calendar_month,
                            ),
                            const SizedBox(height: 10),
                            _buildInput(
                              controller.yearController,
                              "السنة",
                              Icons.date_range,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔷 VALUES CARD
                      _buildCard(
                        child: Column(
                          children: [
                            _buildSectionTitle("القيم"),

                            const SizedBox(height: 12),
  _buildInput(
                              controller.measuredWaterController,
                             "كمية المياه المقاسة",
                              Icons.water,
                            ),
                            _buildInput(
                              controller.calculatedWaterController,
                              "كمية المياه المحسوبة",
                              Icons.water,
                            ),
                            const SizedBox(height: 10),
 _buildInput(
                              controller.waterProducedController,
                              "كمية المياه ",
                              Icons.water,
                            ),
                                                        const SizedBox(height: 10),

                            _buildInput(
                              controller.chlorineController,
                              "الكلور",
                              Icons.science,
                            ),
                            const SizedBox(height: 10),

                            _buildInput(
                              controller.liquidAlumController,
                              "الشبة السائلة",
                              Icons.opacity,
                            ),
                            const SizedBox(height: 10),

                            _buildInput(
                              controller.solidAlumController,
                              "الشبة الصلبة",
                              Icons.ac_unit,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// 🔷 BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("حفظ البيانات"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (controller.selectedStation == null ||
                                controller.selectedTech == null) {
                              showCustomErrorDialog(
                                errorMessage:
                                    "من فضلك اختر المحطة والتكنولوجيا",
                              );
                              return;
                            }

                            if (controller.monthController.text.isEmpty ||
                                controller.yearController.text.isEmpty) {
                              showCustomErrorDialog(
                                errorMessage:
                                    "من فضلك ادخل الشهر والسنة",
                              );
                              return;
                            }

                            controller.addTechBills(
                              staionid:
                                  controller.selectedStation!.stationId,
                              techid:
                                  controller.selectedTech!.technologyId!,
                              chlorine: double.tryParse(
                                      controller.chlorineController.text) ??
                                  0,
                                  calculatedWater: double.tryParse(
                                      controller.calculatedWaterController.text) ??                                  0,
                                      measuredWater: double.tryParse(
                                      controller.measuredWaterController.text) ??                                  0,
                                  
                              liquid: double.tryParse(
                                      controller.liquidAlumController.text) ??
                                  0,
                              solid: double.tryParse(
                                      controller.solidAlumController.text) ??
                                  0,
                              water: double.tryParse(
                                      controller
                                          .waterProducedController.text) ??
                                  0,
                              index: 0,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔄 LOADING
                Obx(() => controller.loading.value
                    ? Container(
                        color: Colors.black.withOpacity(0.2),
                        child: const Center(
                            child: CircularProgressIndicator()),
                      )
                    : const SizedBox()),
              ],
            );
          },
        ),
      );
  }

  /// 🔹 Reusable Card
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  /// 🔹 Section Title
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Icon(Icons.tune, color: Colors.blue.shade700, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ],
    );
  }

  /// 🔹 Styled Input
  Widget _buildInput(
      TextEditingController controller, String label, IconData icon) {
    return CustomTextFormField(
      controller: controller,
      label: label,
      icon: icon,
      allowOnlyDigits: true,
    );
  }

  /// 🔹 Styled Dropdown
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required value,
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
  }) {
    return DropdownButtonFormField(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}