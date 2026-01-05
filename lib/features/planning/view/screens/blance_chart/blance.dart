import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/my_widget/sharable.dart';

class BlanceCart extends StatelessWidget {
  BlanceCart({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BalanceChartController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF1E40AF),
          title: const Center(
            child: Text(
              "منحني الأتزان",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          
          actions: [
              Container(
                margin: const EdgeInsets.only(left: AppDimensions.paddingL),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: AppColors.textWhite),
                  onPressed: () {
                    Get.offNamed('/home');
                    
                  
                  
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.overlayBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Obx(() => _buildBody(controller)),
      ),
    );
  }

  Widget _buildBody(BalanceChartController controller) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Area Dropdown
                Expanded(
                  child: CustomDropdownFormField<int>(
                    items: controller.areas.map((area) {
                      return DropdownMenuItem<int>(
                        value: area.areaId,
                        child: Text(area.areaName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.areaid = value!;
                    },
                    labelText: 'منطقة الخدمة',
                    hintText: 'اختر منطقة الخدمة',
                    prefixIcon: Icons.location_on,
                    validator: (val) =>
                        val == null ? 'الرجاء اختيار منطقة الخدمة' : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Method Dropdown
                Expanded(
                  child: CustomDropdownFormField<String>(
                    items: const [
                      DropdownMenuItem(
                        value: 'machine_learning',
                        child: Text('Machine Learning'),
                      ),
                      DropdownMenuItem(
                        value: 'equation',
                        child: Text('معادلة حساب نصيب الفرد'),
                      ),
                      DropdownMenuItem(
                        value: 'ministry',
                        child: Text('قرار الوزارة الجديد'),
                      ),
                    ],
                    onChanged: (value) {
                      controller.onMethodChanged(value);
                    },
                    labelText: ' طريقة الحساب',
                    hintText: 'اختر طريقة الحساب',
                    prefixIcon: Icons.calculate,
                    validator: (val) =>
                        val == null ? 'الرجاء اختيار طريقة الحساب' : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Target Year Field with Validation
                Expanded(
                  child: TextFormField(
                    controller: controller.yearController,
                    keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'سنة الهدف',
          hintText: 'أدخل سنة الهدف',
          prefixIcon: const Icon(Icons.calendar_today),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال سنة الهدف';
                      }

                      final year = int.tryParse(value);
                      if (year == null) {
                        return 'أدخل سنة صحيحة';
                      }

                      final currentYear = DateTime.now().year;
                      final maxYear = currentYear + 100;

                      if (year < currentYear) {
                        return 'السنة يجب أن تكون في المستقبل';
                      }

                      if (year > maxYear) {
                        return 'السنة لا يمكن أن تتجاوز $maxYear';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Growth Rate Dropdown
                Expanded(
                  child: CustomDropdownFormField<bool>(
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text('المعدل'),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text('الفعلي'),
                      ),
                    ],
                    initialValue: true,
                    onChanged: (value) {
                      controller.edited = value!;
                    },
                    labelText: 'معدل النمو',
                    hintText: 'اختر معدل النمو',
                    prefixIcon: Icons.trending_up,
                    validator: (val) =>
                        val == null ? 'الرجاء اختيار معدل النمو' : null,
                  ),
                ),
              ],
            ),
          ),

          // Ministry method grid
          if (controller.selectedMethod.value == "ministry")
            Expanded(
              child: _buildListWithCustomScrollView(controller),
            ),

          // Submit Button
          RepaintBoundary(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Additional validation for ministry method
                      if (controller.selectedMethod.value == "ministry") {
                        bool allFieldsFilled = true;
                        for (var type in controller.allTypes) {
                          final value = controller
                              .textControllers[type.placeTypeId]?.text;
                          if (value == null || value.isEmpty) {
                            allFieldsFilled = false;
                            break;
                          }
                        }

                        if (!allFieldsFilled) {
                          Get.snackbar(
                            'تنبيه',
                            'الرجاء ملء جميع الحقول',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange.shade100,
                            colorText: Colors.orange.shade900,
                          );
                          return;
                        }
                      }

                      controller.submitData(controller.areaid);
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: controller.isloading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'حفظ البيانات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildListWithCustomScrollView(BalanceChartController controller) {
  return CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(
        child: SizedBox(height: 20),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildSimpleCard(
                context,
                controller.allTypes[index],
                controller.textControllers[
                    controller.allTypes[index].placeTypeId]!,
              );
            },
            childCount: controller.allTypes.length,
          ),
        ),
      ),
    ],
  );
}

Widget _buildSimpleCard(
  BuildContext context,
  dynamic type,
  TextEditingController textController,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title - Compact
        Text(
          type.placeTypeName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),

        // Range - Compact
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${type.personPortionFrom} - ${type.personPortionTo}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Compact Input Field
        TextFormField(
          controller: textController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'القيمة',
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(
              Icons.edit,
              color: Colors.grey.shade600,
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            errorStyle: const TextStyle(
              fontSize: 10,
              height: 0.5,
            ),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'مطلوب';
            }

            final number = int.tryParse(value);
            if (number == null) {
              return 'رقم خاطئ';
            }
            if (number < type.personPortionFrom ||
                number > type.personPortionTo) {
              return 'خارج النطاق';
            }
            return null;
          },
        ),
      ],
    ),
  );
}