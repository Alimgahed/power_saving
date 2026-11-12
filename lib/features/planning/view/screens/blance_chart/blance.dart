import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

class BlanceCart extends StatelessWidget {
  BlanceCart({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BalanceChartController());

    return AppScaffold(
      title: 'منحني الأتزان',
      mobileAppBar: CustomAppBar(
        title: 'منحني الأتزان',
        backRoute: '/home',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_rounded, color: Colors.white),
            tooltip: 'تعديل معدلات قرار الوزارة',
            onPressed: () => Get.toNamed('/placeTypes'),
          ),
        ],
      ),
      desktopHeader: CustomAppBar(
        title: 'منحني الأتزان',
        backRoute: '/home',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_rounded, color: Colors.white),
            tooltip: 'تعديل معدلات قرار الوزارة',
            onPressed: () => Get.toNamed('/placeTypes'),
          ),
        ],
      ),
      body: Obx(() => _buildBody(controller)),
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
                    initialValue: controller.selectedArea?.areaId,
                    items: [
                      ...controller.areas.map((area) {
                      return DropdownMenuItem<int>(
                        value: area.areaId,
                        child: Text(area.areaName),
                      );
                    }),
                      if (controller.selectedArea != null &&
                          !controller.areas.any((a) => a.areaId == controller.areaid))
                        DropdownMenuItem<int>(
                          value: controller.selectedArea!.areaId,
                          enabled: false,
                          child: Text(controller.selectedArea!.areaName),
                        ),
                    ],
                    onChanged: (value) {
                      controller.onAreaChanged(value);
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

                // Increasable / Commercial Needs Field (Shown only if area accepts it)
                if (controller.isIncreasableArea.value) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: controller.incresableController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الاحتياجات التجارية',
                        hintText: 'قيمة الزيادة التجارية',
                        prefixIcon: const Icon(Icons.storefront_outlined, color: Colors.blue),
                        suffixText: 'م³/يوم',
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
                        fillColor: const Color(0xFFF0FDF4),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (controller.isIncreasableArea.value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال الاحتياجات التجارية';
                          }
                          if (int.tryParse(value) == null) {
                            return 'أدخل رقم صحيح';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 🔮 خيار تحديد الوضع (الوضع الحالي vs الوضع المستقبلي)
          _buildStageSelector(controller),

          // 🔮 بطاقة إدخال السنوات والطاقات المستقبلية عند اختيار الوضع المستقبلي
          if (controller.isFuture.value)
            _buildFutureCapacitiesSection(controller),

          // Ministry method grid
          if (controller.selectedMethod.value == "ministry")
            Expanded(
              child: _buildListWithCustomScrollView(controller),
            )
          else if (!controller.isFuture.value)
            const Spacer(),

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

                      // Additional validation for future state
                      if (controller.isFuture.value) {
                        if (controller.futureCapacities.isEmpty) {
                          Get.snackbar(
                            'تنبيه',
                            'الرجاء إضافة سنة وطاقة مستقبلية واحدة على الأقل للوضع المستقبلي',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange.shade100,
                            colorText: Colors.orange.shade900,
                          );
                          return;
                        }
                        for (int i = 0; i < controller.futureCapacities.length; i++) {
                          final item = controller.futureCapacities[i];
                          final y = int.tryParse(item.yearController.text.trim());
                          final p = num.tryParse(item.productionController.text.trim());
                          if (y == null || p == null) {
                            Get.snackbar(
                              'تنبيه',
                              'الرجاء التأكد من إدخال السنة والطاقة بشكل صحيح في كل سطور الوضع المستقبلي',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.orange.shade100,
                              colorText: Colors.orange.shade900,
                            );
                            return;
                          }
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
              return 'النطاق المسموح بين ${type.personPortionFrom} و ${type.personPortionTo}';
            }
            return null;
          },
        ),
      ],
    ),
  );
}

// ═══════════════════════════════════════════════════════
// 🔮 قسم اختيار المرحلة (الوضع الحالي أم الوضع المستقبلي)
// ═══════════════════════════════════════════════════════
Widget _buildStageSelector(BalanceChartController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: controller.isFuture.value
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              controller.isFuture.value
                  ? Icons.update_rounded
                  : Icons.access_time_rounded,
              color: controller.isFuture.value
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'طبيعة دراسة الاتزان:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 16),
          // خيار الوضع الحالي
          InkWell(
            onTap: () => controller.toggleIsFuture(false),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: !controller.isFuture.value
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    !controller.isFuture.value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 16,
                    color: !controller.isFuture.value
                        ? Colors.white
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'الوضع الحالي',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !controller.isFuture.value
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // خيار الوضع المستقبلي
          InkWell(
            onTap: () => controller.toggleIsFuture(true),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: controller.isFuture.value
                    ? const Color(0xFF0D9488)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    controller.isFuture.value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 16,
                    color: controller.isFuture.value
                        ? Colors.white
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'الوضع المستقبلي (إضافة طاقات/محطات مستقبلية)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: controller.isFuture.value
                          ? Colors.white
                          : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════
// 🔮 قسم إدخال السنوات والطاقات المستقبلية
// ═══════════════════════════════════════════════════════
Widget _buildFutureCapacitiesSection(BalanceChartController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA), // Light teal background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF99F6E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'الطاقات الإنتاجية المستقبلية المضافة لمنطقة الخدمة (Future Capacities)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => controller.addFutureCapacityRow(),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('إضافة سنة/طاقة', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.futureCapacities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = controller.futureCapacities[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCCFBF1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // سنة الإضافة
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: item.yearController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'السنة المستهدفة (Future Year)',
                            hintText: 'مثال: 2028',
                            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          validator: (val) {
                            if (controller.isFuture.value) {
                              if (val == null || val.trim().isEmpty) return 'مطلوب';
                              if (int.tryParse(val) == null) return 'رقم غير صحيح';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // الطاقة الإنتاجية المضافة
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: item.productionController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'الطاقة المضافة (Future Production)',
                            hintText: 'الطاقة المضافة م³/يوم',
                            suffixText: 'م³/يوم',
                            prefixIcon: const Icon(Icons.water_drop_outlined, size: 16),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                          validator: (val) {
                            if (controller.isFuture.value) {
                              if (val == null || val.trim().isEmpty) return 'مطلوب';
                              if (num.tryParse(val) == null) return 'رقم غير صحيح';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // زر الحذف
                      IconButton(
                        onPressed: controller.futureCapacities.length > 1
                            ? () => controller.removeFutureCapacityRow(index)
                            : null,
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.red.shade600,
                        disabledColor: Colors.grey.shade300,
                        tooltip: 'حذف السطر',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

