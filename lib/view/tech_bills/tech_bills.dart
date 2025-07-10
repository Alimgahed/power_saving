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
                  // Header Section
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
                              Text(
                                '${controller.techBills.length} فاتورة',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Grid Section
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.techBills.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.485, // Adjusted for more content
                        ),
                    itemBuilder: (context, index) {
                      final techBill = controller.techBills[index];

                      return Container(
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
                          children: [
                            // Header
                            Container(
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
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.engineering,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          techBill.stationName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          techBill.technologyName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    // Date and Basic Info
                                    _buildBasicInfoSection(
                                      techBill.billMonth.toString(),

                                      techBill.billYear.toString(),

                                      techBill.technologyBillPercentage
                                          .toString(),
                                    ),
                                    const SizedBox(height: 12),

                                    // Financial Info
                                    // _buildFinancialSection(
                                    //   techBill.technologyBillTotal
                                    //           ?.toString() ??
                                    //       'غير محدد',
                                    //   techBill.technologyPowerConsump
                                    //           ?.toString() ??
                                    //       'غير محدد',
                                    //   techBill.powerPerWater?.toString() ??
                                    //       'غير محدد',
                                    // ),
                                    // const SizedBox(height: 12),

                                    // Chemical Consumption

                                    // Chemical Ranges
                                    _buildChemicalRangesSection(
                                      controller,
                                      index,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Obx(() {
                                          if (controller.loadingIndex.value ==
                                              index) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return ElevatedButton.icon(
                                            onPressed: () {
                                              if (controller
                                                  .getFormKey(index)
                                                  .currentState!
                                                  .validate()) {
                                                if (controller
                                                        .getWaterProducedController(
                                                          index,
                                                        )
                                                        .text ==
                                                    "0") {
                                                  showCustomErrorDialog(
                                                    errorMessage:
                                                        'الرجاء إدخال قيمة لكمية المياه',
                                                  );
                                                } else {
                                                  controller.addTechBills(
                                                    index: index,
                                                    id: techBill.techBillId,
                                                    chlorine:
                                                        double.tryParse(
                                                          controller
                                                              .getChlorineController(
                                                                index,
                                                              )
                                                              .text,
                                                        )!,
                                                    liquid:
                                                        double.tryParse(
                                                          controller
                                                              .getLiquidAlumController(
                                                                index,
                                                              )
                                                              .text,
                                                        )!,
                                                    solid:
                                                        double.tryParse(
                                                          controller
                                                              .getSolidAlumController(
                                                                index,
                                                              )
                                                              .text,
                                                        )!,
                                                    water:
                                                        double.tryParse(
                                                          controller
                                                              .getWaterProducedController(
                                                                index,
                                                              )
                                                              .text,
                                                        )!,
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 14,
                                            ),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),

                                    // Water Amount
                                  ],
                                ),
                              ),
                            ),

                            // Footer
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(String month, String year, String percentage) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.purple),
              const SizedBox(width: 6),
              const Text(
                'معلومات الفترة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'الشهر',
                  month,
                  Icons.date_range,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoItem(
                  'السنة',
                  year,
                  Icons.class_rounded,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoItem(
            'النسبة المئوية',
            '$percentage%',
            Icons.percent,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  // Widget _buildFinancialSection(
  //   String total,
  //   String powerConsump,
  //   String powerPerWater,
  // ) {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.green.withOpacity(0.05),
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.green.withOpacity(0.1)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.attach_money, size: 14, color: Colors.green),
  //             const SizedBox(width: 6),
  //             const Text(
  //               'المعلومات المالية والكهربائية',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 12,
  //                 color: Colors.green,
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         _buildInfoItem('إجمالي الفاتورة', total, Icons.receipt, Colors.green),
  //         const SizedBox(height: 8),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildInfoItem(
  //                 'استهلاك الكهرباء',
  //                 powerConsump,
  //                 Icons.flash_on,
  //                 Colors.amber,
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: _buildInfoItem(
  //                 'كهرباء/مياه',
  //                 powerPerWater,
  //                 Icons.water_drop,
  //                 Colors.blue,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildChemicalRangesSection(Techbills controller, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            Row(
              children: [
                Icon(Icons.tune, size: 14, color: Colors.indigo),
                const SizedBox(width: 6),
                const Text(
                  'المدى الفعلي للمواد الكيميائية',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildRangeItem(
              'كمية المياة المنتجة',
              Icons.water,
              controller.getWaterProducedController(index),
            ),
            _buildRangeItem(
              'الكلور',
              Icons.science, // Better represents chemical substances
              controller.getChlorineController(index),
            ),
            _buildRangeItem(
              'الشبة السائلة',
              Icons.opacity, // Represents liquid/droplet
              controller.getLiquidAlumController(index),
            ),
            _buildRangeItem(
              'الشبة الصلبة',
              Icons.ac_unit, // Suggests solid/crystal-like materials
              controller.getSolidAlumController(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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

  Widget _buildRangeItem(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          allowOnlyDigits: true,
          controller: controller,
          label: label,
          icon: icon,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
