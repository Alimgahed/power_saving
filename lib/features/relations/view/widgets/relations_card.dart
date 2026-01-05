import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';
import 'package:power_saving/features/relations/model/relations.dart';

class RelationsCard extends StatelessWidget {
  final StationGaugeTechnologyRelation relation;
  final RelationsController controller;

  const RelationsCard({
    super.key,
    required this.relation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = relation.relationStatus == true;

    return Container(
      width: 280,
      decoration: _buildCardDecoration(isActive),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(isActive),
          _buildContent(),
          _buildFooter(isActive),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isActive) {
    return BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      boxShadow: [
        BoxShadow(
          color: isActive ? AppColors.shadowMedium : AppColors.shadowLight,
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: isActive ? AppColors.green.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  Widget _buildHeader(bool isActive) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.green, AppColors.green.withOpacity(0.9)]
              : [AppColors.error.withOpacity(0.8), AppColors.error.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusL),
          topRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Row(
        children: [
          _buildIconContainer(isActive),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              relation.stationName ?? 'غير محدد',
              style: AppTextStyles.h3.copyWith(color: AppColors.textWhite),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 2),
          _buildStatusBadge(isActive),
        ],
      ),
    );
  }

  Widget _buildIconContainer(bool isActive) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Icon(
        isActive ? Icons.link : Icons.link_off,
        color: AppColors.textWhite,
        size: AppDimensions.iconS,
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS, vertical: AppDimensions.paddingXS),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        isActive ? 'نشط' : 'غير نشط',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textWhite),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoContainer(
            'نوع التقنية',
            relation.technologyName ?? 'غير محدد',
            Icons.engineering,
            AppColors.primaryLight,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _buildInfoContainer(
            'رقم الاشتراك',
            relation.accountNumber,
            Icons.numbers,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isActive) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusL),
          bottomRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isActive ? 'إلغاء الربط' : 'تفعيل الربط',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          _buildActionButton(isActive),
        ],
      ),
    );
  }

  Widget _buildActionButton(bool isActive) {
    return Obx(() {
      return ElevatedButton.icon(
        onPressed: controller.isProcessing.value ? null : () => _handleAction(isActive),
        icon: controller.isProcessing.value
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textWhite,
                ),
              )
            : Icon(
                isActive ? Icons.close : Icons.done,
                size: AppDimensions.iconS,
              ),
        label: Text(
          isActive ? 'إلغاء' : 'تفعيل',
          style: AppTextStyles.button,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.error : AppColors.success,
          foregroundColor: AppColors.textWhite,
          elevation: AppDimensions.elevationNone,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: AppDimensions.paddingS),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      );
    });
  }

  Future<void> _handleAction(bool isActive) async {
    await controller.editRelation(
      relation.stationGaugeTechnologyId!,
      isActive ? "تم إلغاء الربط بنجاح" : "تم تفعيل الربط بنجاح",
    );
  }

  Widget _buildInfoContainer(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
