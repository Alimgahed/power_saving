import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/tech_bills/techbills.dart';
import 'package:power_saving/my_widget/sharable.dart';

class TechBills extends StatelessWidget {
  const TechBills({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'قائمة فواتير التقنيات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      Get.offNamed('/home');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: GetBuilder<Techbills>(
          init: Techbills(),
          builder: (controller) {
            return Obx(() {
              if (controller.looading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }

              if (controller.techBills.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.engineering,
                          size: 48,
                          color: Colors.blue.shade300,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'لا توجد فواتير تقنيات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ابدأ بإضافة فاتورة تقنية جديدة',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filters Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.filter_list, 
                                size: 20, 
                                color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              const Text(
                                'بحث',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              if (controller.selectedBranch.value != null || 
                                  controller.selectedStation.value != null)
                                TextButton.icon(
                                  onPressed: controller.clearFilters,
                                  icon: const Icon(Icons.clear, size: 16),
                                  label: const Text('مسح الفلاتر'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade600,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Branch Filter
                              Expanded(
                                child: Obx(() => DropdownButtonFormField<String>(
                                  value: controller.selectedBranch.value,
                                  decoration: InputDecoration(
                                    labelText: 'الفرع',
                                    prefixIcon: Icon(Icons.business, 
                                      size: 20, color: Colors.blue.shade600),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  items: [
                                    const DropdownMenuItem(
                                      value: null,
                                      child: Text('كل الفروع'),
                                    ),
                                    ...controller.branches.map((branch) {
                                      return DropdownMenuItem(
                                        value: branch,
                                        child: Text(branch),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: controller.filterByBranch,
                                )),
                              ),
                              const SizedBox(width: 12),
                              // Station Filter
                              Expanded(
                                child: SearchableDropdown(
  tag: 'station_dropdown', // Unique tag
  items: [
    ...controller.stations.map((p) {
      return DropdownMenuItem<String>(
        value: p, // Convert int to String
        child: Text(p),
      );
    }).toList(),
  ],
  onChanged: (value) {
    controller.filterByStation(value);
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "يجب ادخال اسم المحطة".tr;
    }
    return null;
  },
  labelText: "المحطة".tr,
  hintText: 'اختر المحطة'.tr,
  prefixIcon: Icons.map,
),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Summary Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade50, Colors.blue.shade100],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.engineering,
                              color: Colors.blue.shade700,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'إجمالي فواتير التقنيات',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Obx(() => Text(
                                  '${controller.filteredTechBills.length} فاتورة',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tech Bills Grid
                    Obx(() => controller.filteredTechBills.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off, 
                                    size: 48, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'لا توجد نتائج تطابق الفلتر',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: controller.filteredTechBills
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final techBill = entry.value;
                              final originalIndex = controller.techBills
                                  .indexOf(techBill);

                              return Container(
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Card Header
                                    Container(
                                      height: 130,
                                      padding: const EdgeInsets.all(16),
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            techBill.stationName,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            techBill.technologyName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            techBill.branch??"",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'السنة: ${techBill.billYear} - الشهر: ${techBill.billMonth}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Card Content
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          _buildChemicalRangesSection(
                                              controller, originalIndex),
                                          const SizedBox(height: 8),
                                          Obx(() {
                                            if (controller.loadingIndex.value ==
                                                originalIndex) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            return SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (controller
                                                      .getFormKey(originalIndex)
                                                      .currentState!
                                                      .validate()) {
                                                    controller.addTechBills(
                                                      index: originalIndex,
                                                      id: techBill.techBillId,
                                                      chlorine: double.tryParse(
                                                            controller
                                                                .getChlorineController(
                                                                    originalIndex)
                                                                .text,
                                                          ) ??
                                                          0,
                                                      liquid: double.tryParse(
                                                            controller
                                                                .getLiquidAlumController(
                                                                    originalIndex)
                                                                .text,
                                                          ) ??
                                                          0,
                                                      solid: double.tryParse(
                                                            controller
                                                                .getSolidAlumController(
                                                                    originalIndex)
                                                                .text,
                                                          ) ??
                                                          0,
                                                      water: double.tryParse(
                                                            controller
                                                                .getWaterProducedController(
                                                                    originalIndex)
                                                                .text,
                                                          ) ??
                                                          0,
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.edit,
                                                    size: 14),
                                                label: const Text(
                                                  'حفظ',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue.shade600,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(6),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChemicalRangesSection(Techbills controller, int index) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.withOpacity(0.1)),
      ),
      child: Form(
        key: controller.getFormKey(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.tune, size: 14, color: Colors.indigo),
                const SizedBox(width: 6),
                const Text(
                  'المدى الفعلي للمواد الكيميائية',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _buildRangeItem(
              'كمية المياة المنتجة',
              Icons.water,
              controller.getWaterProducedController(index),
            ),
            _buildRangeItem(
              'الكلور',
              Icons.science,
              controller.getChlorineController(index),
            ),
            _buildRangeItem(
              'الشبة السائلة',
              Icons.opacity,
              controller.getLiquidAlumController(index),
            ),
            _buildRangeItem(
              'الشبة الصلبة',
              Icons.ac_unit,
              controller.getSolidAlumController(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeItem(
      String label, IconData icon, TextEditingController controller) {
    return CustomTextFormField(
      padding: 4,
      allowOnlyDigits: true,
      controller: controller,
      label: label,
      icon: icon,
    );
  }
}