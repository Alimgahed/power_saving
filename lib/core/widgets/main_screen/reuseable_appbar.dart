import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final RxBool isSearching;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final String? hintText;
  final VoidCallback onSearchToggle;
  final VoidCallback onNavigateHome;
  final List<Widget> customActions;
  final GlobalKey<FormState>? formKey;

  const ReusableAppBar({
    super.key,
    required this.title,
    this.hintText,
    required this.isSearching,
    this.searchController,
    this.onSearchChanged,
    required this.onSearchToggle,
    required this.onNavigateHome,
    this.customActions = const [],
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.header),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title:
            isSearching.value
                ? TextFormField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.textWhite,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? 'ابحث باسم الفرع أو المحطة...',
                    hintStyle: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingXS,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                  onChanged: onSearchChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال نص للبحث';
                    }
                    return null;
                  },
                )
                : Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
        actions: [
          ...customActions,
          if (!isSearching.value)
            _IconAction(icon: Icons.search, onTap: onSearchToggle),
          if (!isSearching.value) const SizedBox(width: AppDimensions.paddingS),
          _IconAction(icon: Icons.arrow_forward, onTap: () => Get.back()),
          const SizedBox(width: AppDimensions.paddingS),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.textWhite),
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
  }
}
