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
        backgroundColor: AppColors.primary,
        elevation: AppDimensions.elevationNone,
        automaticallyImplyLeading: false,
        title:
            isSearching
                    .value // Access the value of RxBool
                ? TextFormField(
                  controller: searchController,
                  autofocus: true,
                  style: AppTextStyles.appBarTitle,
                  decoration: InputDecoration(
                    hintText: hintText ?? 'ابحث باسم الفرع أو المحطة...',
                    hintStyle: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
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
                : Text(title, style: AppTextStyles.appBarTitle),
        actions: [
          ...customActions,
          if (!isSearching.value) // Use the value of RxBool
            _IconAction(icon: Icons.search, onTap: onSearchToggle),
          if (!isSearching.value) const SizedBox(width: AppDimensions.paddingS),
          _IconAction(icon: Icons.arrow_forward, onTap: onNavigateHome),
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
        backgroundColor: AppColors.overlayBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
      ),
    );
  }
}
