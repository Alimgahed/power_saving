import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/voltage/voltage.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/vlotage.dart';
import 'package:power_saving/my_widget/sharable.dart';

/// Voltage Dialog Helper
/// 
/// Manages the voltage configuration dialog
class VoltageDialogHelper {
  static Future<void> showVoltageDialog(BuildContext context) async {
    if (user == null) {
      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
      return;
    }

    final voltageController = Get.put(Voltage());
    await voltageController.allVoltage();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => _VoltageDialog(controller: voltageController),
    );
  }
}

/// Voltage Configuration Dialog
class _VoltageDialog extends StatelessWidget {
  final Voltage controller;

  const _VoltageDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        height: 280,
        child: GetBuilder<Voltage>(
          init: controller,
          builder: (ctrl) => Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildVoltageRow(
                  title: "الجهد المتوسط",
                  fixedController: ctrl.avaargefixed,
                  costController: ctrl.avaragecost,
                  onSave: () => _saveAverageVoltage(formKey, ctrl),
                  isLoading: ctrl.isLoading.value,
                ),
                const SizedBox(height: 20),
                _buildVoltageRow(
                  title: "الجهد المنخفض",
                  fixedController: ctrl.lowfixed,
                  costController: ctrl.lowcost,
                  onSave: () => _saveLowVoltage(formKey, ctrl),
                  isLoading: ctrl.isLoading.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoltageRow({
    required String title,
    required TextEditingController fixedController,
    required TextEditingController costController,
    required VoidCallback onSave,
    required bool isLoading,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
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
            controller: fixedController,
            icon: Icons.attach_money,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextFormField(
            label: 'تكلفة الجهد',
            hintText: 'أدخل تكلفة الجهد',
            controller: costController,
            icon: Icons.electrical_services,
          ),
        ),
        Expanded(
          child: Obx(() => _buildSaveButton(onSave,)),
        ),
      ],
    );
  }

  Widget _buildSaveButton(VoidCallback onSave,) {
    return Center(
      child: ElevatedButton(
        onPressed: onSave,
        child: 
       controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.blue,
                ),
              )
            : const Text("حفظ"),
      ),
    );
  }

  Future<void> _saveAverageVoltage(
    GlobalKey<FormState> formKey,
    Voltage controller,
  ) async {
    if (!formKey.currentState!.validate()) return;

    final voltagePlan = VoltagePlan(
      fixedFee: double.tryParse(controller.avaargefixed.text) ?? 0,
      voltageCost: double.tryParse(controller.avaragecost.text) ?? 0,
      voltageId: 2,
      voltageType: 'متوسط',
    );

    controller.vlotages.add(voltagePlan);
    await controller.editVoltage(volt: voltagePlan, voltid: 2);
  }

  Future<void> _saveLowVoltage(
    GlobalKey<FormState> formKey,
    Voltage controller,
  ) async {
    if (!formKey.currentState!.validate()) return;

    final voltagePlan = VoltagePlan(
      fixedFee: double.tryParse(controller.lowfixed.text) ?? 0,
      voltageCost: double.tryParse(controller.lowcost.text) ?? 0,
      voltageId: 1,
      voltageType: 'منخفض',
    );

    controller.vlotages.add(voltagePlan);
    await controller.editVoltage(volt: voltagePlan, voltid: 1);
  }
}