import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/buttons.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/core/widgets/form_card.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/features/relations/controller/add_relations_controller.dart';
import 'package:power_saving/features/relations/model/relations.dart';
import 'package:power_saving/my_widget/sharable.dart';

class AddRelationScreen extends StatelessWidget {
  AddRelationScreen({super.key});
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const appBarWidget = CustomAppBar(
      title: "إضافة ربط جديد",
      backRoute: '/Countrts',
    );

    return AppScaffold(
      title: "إضافة ربط جديد",
      mobileAppBar: appBarWidget,
      desktopHeader: appBarWidget,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: GetBuilder<addrelationcontroller>(
          init: addrelationcontroller(),
          builder: (controller) {
            return FormCard(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'تفاصيل الربط',
                      icon: Icons.link,
                      color: AppColors.primary,
                    ),

                    // Station Dropdown
               CustomSearchableDropdown<int>(
  items: controller.stationlist.map((p) {
    return DropdownMenuItem<int>(
      value: p.branchId,
      child: Text(p.branchName),
    );
  }).toList(),

  onChanged: (value) => controller.stationid = value!,
  labelText: 'المحطة',
  hintText: 'اختر المحطة',
  prefixIcon: Icons.map,
  validator: (val) =>
      val == null ? 'يجب ادخال اسم المحطة' : null,
),
                    const SizedBox(height: AppDimensions.paddingL),

                    // Electric Meter Dropdown
                 CustomSearchableDropdown<String>(
  items: controller.electricMeterList.map((p) {
    return DropdownMenuItem<String>(
      value: p.accountNumber!,
      child: Text(p.accountNumber!),
    );
  }).toList(),

  onChanged: (value) => controller.counterid = value!,
  labelText: 'العداد',
  hintText: 'اختر العداد',
  prefixIcon: Icons.bolt,
  validator: (val) =>
      val == null ? 'يجب ادخال اسم العداد' : null,
),
                    const SizedBox(height: AppDimensions.paddingL),

                 CustomSearchableDropdown<int>(
  items: controller.technologylist.map((p) {
    return DropdownMenuItem<int>(
      value: p.technologyId, // 👈 ID الحقيقي
      child: Text(p.technologyName),
    );
  }).toList(),

  onChanged: (value) => controller.techid = value!,
  labelText: 'التكنولوجيا',
  hintText: 'اختر التكنولوجيا',
  prefixIcon: Icons.memory,
  validator: (val) =>
      val == null ? 'يجب ادخال اسم التكنولوجيا' : null,
),
                    const SizedBox(height: AppDimensions.paddingL),
                      CustomSearchableDropdown<String>(
  items: controller.electricMeterList.map((p) {
    return DropdownMenuItem<String>(
      value: p.accountNumber!,
      child: Text(p.accountNumber!),
    );
  }).toList(),

  onChanged: (value) => controller.counterid = value!,
  labelText: 'العداد',
  hintText: 'اختر العداد',
  prefixIcon: Icons.bolt,
  validator: (val) =>
      val == null ? 'يجب ادخال اسم العداد' : null,
),
                    const SizedBox(height: AppDimensions.paddingL),

                 CustomSearchableDropdown<bool>(
                  initialValue: controller.issource,
  items: [
    DropdownMenuItem<bool>(
      value: true,
      child: Text('عدد مأخذ'),
    ),
    DropdownMenuItem<bool>(
      value: false,
      child: Text('ليس عدد مأخذ'),
    ),
  ],

  onChanged: (value) => controller.issource = value!,
  labelText: 'هل هو عدد مأخذ؟',
  hintText: 'اختر الخيار',
  prefixIcon: Icons.source,
  validator: (val) =>
      val == null ? 'يجب ادخال اسم النوع' : null,
),
                    const SizedBox(height: AppDimensions.paddingL),


                    // Submit Button
                    Obx(() {
                      return PrimaryButton(
                        label: 'حفظ الربط',
                        icon: Icons.save,
                        isLoading: controller.looading.value,
                        onPressed: () async {
                          if (_globalKey.currentState!.validate()) {
                            await controller.addRelations(
                              StationGaugeTechnologyRelation(
                                issource: controller.issource,
                                accountNumber: controller.counterid!,
                                relationStatus: true,
                                stationId: controller.stationid!,
                                technologyId: controller.techid!,
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
