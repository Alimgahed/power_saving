import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/styles.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';
import 'package:power_saving/features/home/view/widgets/navigation_helper.dart';
import 'package:power_saving/features/home/view/widgets/voltaige.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/shared_pref/cache.dart';

/// Persistent Enterprise Sidebar for Desktop Layouts
class EnterpriseSidebar extends StatelessWidget {
  EnterpriseSidebar({super.key});

  final NavigationHelper _navigationHelper = NavigationHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.sidebarWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: AppColors.border, width: 1), // RTL layout, border on left
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
              physics: const BouncingScrollPhysics(),
              children: _buildMenuItems(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingS),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(Icons.dashboard, color: AppColors.primary, size: AppDimensions.iconL),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          const Expanded(
            child: Text(
              'إدارة الطاقة والمياه',
              style: AppTextStyles.h4,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      if (_hasAccess([1, 2, 6, 7]))
        _buildSidebarItem(icon: Icons.ev_station, text: "المحطات", onTap: () => _navigationHelper.navigateWithAuth("/Stations")),
      
      if (_hasAccess([1, 3]))
        _buildSidebarItem(icon: Icons.charging_station_rounded, text: "العدادت", onTap: () => _navigationHelper.navigateWithAuth("/Countrts")),
      
      if (_hasAccess([1, 3]))
        _buildSidebarItem(icon: Icons.price_change, text: "التعريفه", onTap: () => VoltageDialogHelper.showVoltageDialog(context)),
      
      if (_hasAccess([1, 2, 3, 7]))
        _buildSidebarItem(icon: Icons.memory, text: "التكنولوجيا", onTap: () => _navigationHelper.navigateWithAuth("/Technology")),
      
      if (_hasAccess([1, 3, 7]))
        _buildSidebarItem(icon: Icons.ac_unit_sharp, text: "الربط", onTap: () => _navigationHelper.navigateWithAuth("/Relations")),
      
      if (_hasAccess([1, 4, 6, 7]))
        _buildSidebarItem(icon: Icons.science, text: "الكماويات", onTap: () => _navigationHelper.navigateWithAuth("/Chemicals")),
      
      if (_hasAccess([1, 2]))
        _buildSidebarItem(icon: Icons.engineering, text: "المكتب الفني", onTap: () => _navigationHelper.navigateWithAuth("/techbills")),
      
      if (_hasAccess([1, 2]))
        _buildSidebarItem(icon: Icons.engineering, text: "ادخال كميات مياة جديدة", onTap: () => _navigationHelper.navigateWithAuth("/NewTechBills")),
      
      if (_hasAccess([1, 2, 6, 7]))
        _buildSidebarItem(icon: Icons.water_drop_outlined, text: "التوقعات", onTap: () => _navigationHelper.navigateWithAuth('./Predictions')),
      
      if (_hasAccess([1, 3]))
        _buildSidebarItem(icon: Icons.receipt_long_rounded, text: "الفواتير", onTap: () => _navigationHelper.navigateWithAuth('./bills')),
      
      if (_hasAccess([1, 2, 3, 7]))
        _buildSidebarItem(icon: Icons.receipt_long_rounded, text: "فواتير التقنيات", onTap: () => _navigationHelper.navigateWithAuth('./techBill')),
      
      _buildSidebarItem(icon: Icons.ev_station, text: "متابعة المحطات", onTap: () => _navigationHelper.navigateWithAuth('./FollowingStations')),
      
      _buildSidebarItem(icon: Icons.bar_chart, text: "التحليل الأقتصادي", onTap: () => _navigationHelper.navigateWithAuth('./Charts')),
      
      if (_hasAccess([1, 5]))
        _buildSidebarItem(icon: Icons.place_outlined, text: "المدن والقري", onTap: () => _navigationHelper.navigateWithAuth('./Places')),
      
      if (_hasAccess([1, 5]))
        _buildSidebarItem(icon: Icons.show_chart, text: "منحني الأتزان", onTap: () => _navigationHelper.navigateWithAuth('./BlanceCart')),
      
      if (_hasAccess([1, 2, 3, 6, 7]))
        _buildSidebarItem(icon: Icons.report, text: "التقارير", onTap: () => _navigationHelper.navigateWithAuth('./Reports')),
      
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL, vertical: AppDimensions.paddingS),
        child: Divider(),
      ),
      
      if (_hasAccess([1]))
        _buildSidebarItem(icon: Icons.person_add_alt_outlined, text: "مستخدم جديد", onTap: () => _navigationHelper.navigateWithAuth('/NewUser')),
      
      if (_hasAccess([1]))
        _buildSidebarItem(icon: Icons.people_outline_outlined, text: "المستخدمين", onTap: () => _navigationHelper.navigateWithAuth('/all_users')),
      
      _buildSidebarItem(icon: Icons.password_outlined, text: "تغيير كلمة المرور", onTap: () => _navigationHelper.navigateWithAuth('/change_password')),
      
      if (user == null)
        _buildSidebarItem(icon: Icons.login, text: "تسجل دخول", onTap: () => Get.toNamed("/Login")),
      
      if (user != null)
        _buildSidebarItem(icon: Icons.logout, text: "تسجيل خروج", isDestructive: true, onTap: () => _handleLogout()),
    ];
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: AppDimensions.iconM,
        ),
        title: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        onTap: onTap,
        hoverColor: isDestructive ? AppColors.errorLight : AppColors.primaryLight,
      ),
    );
  }

  bool _hasAccess(List<int> allowedGroups) {
    if (user == null) return false;
    return allowedGroups.contains(user!.groupId);
  }

  Future<void> _handleLogout() async {
    await Cache.sharedPreferences.clear();
    SessionService.to.clear();
    Get.offAllNamed("/Login");
  }
}
