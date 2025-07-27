import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/counter/counter.dart';
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class editCounter extends StatelessWidget {
  editCounter({super.key});

  final ElectricMeter? meter = Get.arguments!=null?Get.arguments["meter"]:null;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
      if (meter == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/Countrts');
      });}
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        
        appBar: AppBar(
          title: const Text(
           "تعديل عداد",
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
              
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                    Get.offNamed('/Countrts');
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GetBuilder<EditCounter>(
            init: EditCounter(),
            builder: (controller) {
              controller.Counter_number.text = meter!.accountNumber!;
              controller.finalReading.text = meter!.finalReading.toString();
              controller.meterFactor.text = meter!.meterFactor.toString();
              controller.meterId.text = meter!.meterId;
              controller.voltage = meter!.voltageid;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.electric_meter,
                            size: 32,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'تعديل بيانات العداد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تحديث بيانات العداد المختار',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('تفاصيل العداد', Icons.electric_meter, Colors.blue),

                          CustomTextFormField(
                            label: 'رقم الحساب',
                            allowOnlyDigits: true,
                            hintText: 'أدخل رقم الحساب',
                            icon: Icons.numbers,
                            controller: controller.Counter_number,
                          ),
                          const SizedBox(height: 16),

                          CustomTextFormField(
                            label: 'معرّف العداد',
                            allowOnlyDigits: true,
                            hintText: 'أدخل معرف العداد',
                            icon: Icons.confirmation_number,
                            controller: controller.meterId,
                          ),
                          const SizedBox(height: 16),

                          CustomDropdownFormField<int>(
                            initialValue: controller.voltage,
                            items: controller.allVoltage.map((Type) {
                              return DropdownMenuItem<int>(
                                value: Type.voltageId,
                                child: Text(Type.voltageType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              controller.voltage = value;
                            },
                            labelText: 'جهد العداد',
                            hintText: 'اختر نوع الجهد',
                            prefixIcon: Icons.map,
                            validator: (val) => val == null ? 'الرجاء اختيار الجهد' : null,
                          ),
                          const SizedBox(height: 16),

                          CustomTextFormField(
                            label: 'القراءة النهائية',
                            hintText: 'أدخل القراءة النهائية',
                            icon: Icons.speed,
                            allowOnlyDigits: true,
                            controller: controller.finalReading,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          CustomTextFormField(
                            label: 'معامل العداد',
                            hintText: 'أدخل معامل العداد',
                            icon: Icons.straighten,
                            allowOnlyDigits: true,
                            controller: controller.meterFactor,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),

                          // Save Button
                          Obx((){
                            return controller.looadig.value?Center(child: CircularProgressIndicator(color: Colors.blue,),):
                              SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_globalKey.currentState!.validate()) {
                                  await controller.editCounter(
                                    serial: controller.Counter_number.text,
                                    counter: ElectricMeter(
                                      finalReading: int.tryParse(controller.finalReading.text) ?? 0,
                                      meterFactor: int.tryParse(controller.meterFactor.text) ?? 1,
                                      meterId: controller.meterId.text,
                                      voltageid: controller.voltage!,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.save, size: 20),
                              label: const Text(
                                'حفظ التعديلات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                          })
                        
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 1, color: color.withOpacity(0.2))),
        ],
      ),
    );
  }
}
