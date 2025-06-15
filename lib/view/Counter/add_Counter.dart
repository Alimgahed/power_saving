import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/counter/counter.dart';
import 'package:power_saving/model/Counter_model.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddElectricMeterScreen extends StatelessWidget {
  const AddElectricMeterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions:[ Row(
          children: [
            Text("إضافة عداد جديد", style: TextStyle(fontSize: 20)),
            SizedBox(width: 10,),
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.blue),
              onPressed: () => Get.offNamed('/Countrts'),
            ),
          ],
        )],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GetBuilder<addcounter>(
            init: addcounter(),
            builder: (controller) {
              return Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  child: Column(
                    children: [
                      const Icon(Icons.electric_meter, size: 64, color: Colors.blue),
                      const SizedBox(height: 16),
                      const Text(
                        'إدخال بيانات العداد',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),

                      CustomTextFormField(
                        label: 'رقم الحساب',
                        hintText: 'أدخل رقم الحساب',
                        icon: Icons.numbers,
                        controller: controller.Counter_number,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        label: 'معرّف العداد',
                        hintText: 'أدخل معرف العداد',
                        icon: Icons.confirmation_number,
                        controller: controller.meterId,
                      ),
                      const SizedBox(height: 16),

                     const SizedBox(height: 16),

                      CustomDropdownFormField<int>(
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
                        validator: (val) => val == null ? 'الرجاء اختيار الفرع' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        label: 'القراءة النهائية',
                        hintText: 'أدخل القراءة النهائية',
                        icon: Icons.speed,
                        controller: controller.finalReading,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        label: 'معامل العداد',
                        hintText: 'أدخل معامل العداد',
                        icon: Icons.straighten,
                        controller: controller.meterFactor,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                           
                              await controller.addCounter(counter: ElectricMeter(accountNumber:controller.Counter_number.text, finalReading:int.parse( controller.finalReading.text), meterFactor:int.parse(controller.meterFactor.text), meterId:controller.meterId.text, voltageid: controller.voltage!));
                            
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('حفظ العداد'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
