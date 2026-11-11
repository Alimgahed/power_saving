import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/controller/place/edit_place_type_controller.dart';
import 'package:power_saving/features/planning/model/all_places_model.dart';

class PlaceTypesListScreen extends StatelessWidget {
  const PlaceTypesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPlaceTypeController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppScaffold(
        title: 'أنواع الأماكن ومعدلات الاستهلاك',
        showDrawer: false,
        mobileAppBar: CustomAppBar(
          title: 'أنواع الأماكن ومعدلات الاستهلاك',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => controller.fetchPlaceTypes(forceRefresh: true),
              tooltip: 'تحديث',
            ),
          ],
        ),
        desktopHeader: CustomAppBar(
          title: 'أنواع الأماكن ومعدلات الاستهلاك',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => controller.fetchPlaceTypes(forceRefresh: true),
              tooltip: 'تحديث',
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.placeTypes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.placeTypes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد أنواع أماكن مضافة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchPlaceTypes(forceRefresh: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(context, controller),
                const SizedBox(height: 20),
                _buildTypesGrid(context, controller),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, EditPlaceTypeController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Icon(Icons.gavel_rounded, color: Color(0xFF2563EB), size: 28),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نطاقات نصيب الفرد طبقاً لقرار الوزارة الجديد',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'يمكنك تعديل اسم نوع المكان ونطاق نصيب الفرد (من - إلى) باللتر/يوم',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Obx(() => Text(
                  'العدد الكلي: ${controller.placeTypes.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTypesGrid(BuildContext context, EditPlaceTypeController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int columns = 1;
        if (width >= 1100) {
          columns = 3;
        } else if (width >= 700) {
          columns = 2;
        }

        const double spacing = 16.0;
        final double itemWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: controller.placeTypes.map((type) {
            return SizedBox(
              width: itemWidth,
              child: _buildTypeCard(context, controller, type),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    EditPlaceTypeController controller,
    PlaceType type,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.location_city_rounded, color: Color(0xFF2563EB), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        type.placeTypeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openEditDialog(context, controller, type),
                icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 24),
                tooltip: 'تعديل النطاق',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEFF6FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الحد الأدنى (من)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${type.personPortionFrom}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('لتر/فرد/يوم', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الحد الأقصى (إلى)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${type.personPortionTo}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('لتر/فرد/يوم', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tune_rounded, size: 14, color: Color(0xFF2563EB)),
                const SizedBox(width: 6),
                Text(
                  'النطاق المسموح: [ ${type.personPortionFrom} - ${type.personPortionTo} ]',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openEditDialog(
    BuildContext context,
    EditPlaceTypeController controller,
    PlaceType type,
  ) {
    controller.prepareForEdit(type);
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 460,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.edit_note_rounded, color: Color(0xFF2563EB), size: 22),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'تعديل نوع المكان والنطاق',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const Text(
                    'اسم نوع المكان',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: 'أدخل اسم نوع المكان',
                      prefixIcon: const Icon(Icons.title_rounded, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اسم نوع المكان مطلوب' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الحد الأدنى (من)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: controller.fromController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'مثال: 100',
                                suffixText: 'لتر',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'مطلوب';
                                if (int.tryParse(v) == null) return 'رقم غير صحيح';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الحد الأقصى (إلى)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: controller.toController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'مثال: 150',
                                suffixText: 'لتر',
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'مطلوب';
                                final toVal = int.tryParse(v);
                                if (toVal == null) return 'رقم غير صحيح';
                                final fromVal = int.tryParse(controller.fromController.text);
                                if (fromVal != null && toVal < fromVal) {
                                  return 'يجب أن يكون أكبر من الحد الأدنى';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('إلغاء', style: TextStyle(color: Color(0xFF64748B))),
                      ),
                      const SizedBox(width: 10),
                      Obx(() => ElevatedButton.icon(
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () async {
                                    if (formKey.currentState!.validate()) {
                                      final success = await controller.updatePlaceType(type.placeTypeId);
                                      if (success) {
                                        Get.back();
                                      }
                                    }
                                  },
                            icon: controller.isSubmitting.value
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.check, size: 18),
                            label: Text(controller.isSubmitting.value ? 'جاري الحفظ...' : 'حفظ التعديلات'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
