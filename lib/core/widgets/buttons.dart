import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: AppDimensions.iconM,
                height: AppDimensions.iconM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                ),
              )
            : Icon(icon ?? Icons.save, size: AppDimensions.iconM),
        label: Text(label, style: AppTextStyles.button),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
          backgroundColor: backgroundColor ?? AppColors.primaryLight,
          foregroundColor: AppColors.textWhite,
          elevation: AppDimensions.elevationNone,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
      ),
    );
  }
}
class ReusableActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ReusableActionButton({super.key, 
    required this.label,
    required this.icon,
    required this.route,
    this.backgroundColor = AppColors.cardBackground,
    this.foregroundColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      child: ElevatedButton.icon(
        onPressed: () => Get.offNamed(route),
        icon: Icon(icon, size: AppDimensions.iconS),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: AppDimensions.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
    );
  }
}

class ReusableFooter extends StatelessWidget {
  final dynamic station; // Accept any station object
  final String buttonLabel; // Label for the button
  final String textLabel; // Text before the button
  final String routeName; // Route for navigation
  final IconData icon; // Icon for the button
  final TextStyle? textStyle; // Text style for the button label and text label
  final dynamic arguments; // Custom arguments to pass during navigation

  const ReusableFooter({super.key, 
    required this.station,
    required this.buttonLabel,
    required this.textLabel,
    required this.routeName,
    required this.icon,
    this.textStyle = AppTextStyles.bodySmall, // Default style for text
    this.arguments, // Accept any custom arguments to pass during navigation
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        children: [
          Text(
            textLabel,
            style: textStyle?.copyWith(color: AppColors.textSecondary),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: AppDimensions.elevationM,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offNamed(routeName, arguments: arguments);
                },
                icon: Icon(icon, size: AppDimensions.iconS),
                label: Text(buttonLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
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
