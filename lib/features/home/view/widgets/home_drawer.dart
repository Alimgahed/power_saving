import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/home/view/widgets/navigation_helper.dart';
import 'package:power_saving/features/home/view/widgets/voltaige.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/my_widget/home.dart';
import 'package:power_saving/shared_pref/cache.dart';


/// Navigation Drawer for Home Screen
/// 
/// Contains all menu items with role-based visibility
class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final NavigationHelper _navigationHelper = NavigationHelper();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ..._buildMenuItems(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E40AF),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dashboard, color: Colors.white, size: 40),
          SizedBox(height: 10),
          Text(
            'نظام إدارة الطاقة والمياه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      if (_hasAccess([1, 2,6,7]))
        _buildMenuItem(
          icon: Icons.ev_station,
          text: "المحطات",
          onTap: () => _navigationHelper.navigateWithAuth("/Stations"),
        ),
      
      if (_hasAccess([1, 3]))
        _buildMenuItem(
          icon: Icons.charging_station_rounded,
          text: "العدادت",
          onTap: () => _navigationHelper.navigateWithAuth("/Countrts"),
        ),
      
      if (_hasAccess([1, 3]))
        _buildMenuItem(
          icon: Icons.price_change,
          text: "التعريفه",
          onTap: () => VoltageDialogHelper.showVoltageDialog(context),
        ),
      
      if (_hasAccess([1, 2, 3,7]))
        _buildMenuItem(
          icon: Icons.memory,
          text: "التكنولوجيا",
          onTap: () => _navigationHelper.navigateWithAuth("/Technology"),
        ),
      
      if (_hasAccess([1, 3,7]))
        _buildMenuItem(
          icon: Icons.ac_unit_sharp,
          text: "الربط",
          onTap: () => _navigationHelper.navigateWithAuth("/Relations"),
        ),
      
      if (_hasAccess([1, 4,6,7]))
        _buildMenuItem(
          icon: Icons.science,
          text: "الكماويات",
          onTap: () => _navigationHelper.navigateWithAuth("/Chemicals"),
        ),
      
      if (_hasAccess([1, 2]))
        _buildMenuItem(
          icon: Icons.engineering,
          text: "المكتب الفني",
          onTap: () => _navigationHelper.navigateWithAuth("/techbills"),
        ),
         if (_hasAccess([1, 2]))
        _buildMenuItem(
          icon: Icons.engineering,
          text: "ادخال كميات مياة جديدة",
          onTap: () => _navigationHelper.navigateWithAuth("/NewTechBills"),
        ),
      
      if (_hasAccess([1, 2,6,7]))
        _buildMenuItem(
          icon: Icons.water_drop_outlined,
          text: "التوقعات",
          onTap: () => _navigationHelper.navigateWithAuth('./Predictions'),
        ),
      
      if (_hasAccess([1, 3]))
        _buildMenuItem(
          icon: Icons.receipt_long_rounded,
          text: "الفواتير",
          onTap: () => _navigationHelper.navigateWithAuth('./bills'),
        ),
      
      if (_hasAccess([1, 2, 3,7]))
        _buildMenuItem(
          icon: Icons.receipt_long_rounded,
          text: "فواتير التقنيات",
          onTap: () => _navigationHelper.navigateWithAuth('./techBill'),
        ),
        _buildMenuItem(
        icon: Icons.ev_station,
        text: "متابعة المحطات",
        onTap: () => _navigationHelper.navigateWithAuth('./FollowingStations'),
      ),
      
      _buildMenuItem(
        icon: Icons.bar_chart,
        text: "التحليل الأقتصادي",
        onTap: () => _navigationHelper.navigateWithAuth('./Charts'),
      ),
        if (_hasAccess([1,5]))
      
      _buildMenuItem(
        icon: Icons.place_outlined,
        text: "المدن والقري",
        onTap: () => _navigationHelper.navigateWithAuth('./Places'),
      ),
       if (_hasAccess([1,5]))
      
      _buildMenuItem(
        icon: Icons.show_chart,
        text: "منحني الأتزان",
        onTap: () => _navigationHelper.navigateWithAuth('./BlanceCart'),
      ),
      
      if (_hasAccess([1, 2, 3,6,7]))
        _buildMenuItem(
          icon: Icons.report,
          text: "التقارير",
          onTap: () => _navigationHelper.navigateWithAuth('./Reports'),
        ),
      
      if (_hasAccess([1]))
        _buildMenuItem(
          icon: Icons.person_add_alt_outlined,
          text: "مستخدم جديد",
          onTap: () => _navigationHelper.navigateWithAuth('/NewUser'),
        ),
      
      if (_hasAccess([1]))
        _buildMenuItem(
          icon: Icons.people_outline_outlined,
          text: "المستخدمين",
          onTap: () => _navigationHelper.navigateWithAuth('/all_users'),
        ),
      
      _buildMenuItem(
        icon: Icons.password_outlined,
        text: "تغيير كلمة المرور",
        onTap: () => _navigationHelper.navigateWithAuth('/change_password'),
      ),
      
      if (user == null)
        _buildMenuItem(
          icon: Icons.login,
          text: "تسجل دخول",
          onTap: () => Get.toNamed("/Login"),
        ),
      
      if (user != null)
        _buildMenuItem(
          icon: Icons.logout,
          text: "تسجيل خروج",
          onTap: () => _handleLogout(),
        ),
    ];
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return list_view(
      icon: icon,
      text: text,
      ontap: onTap,
    );
  }

  bool _hasAccess(List<int> allowedGroups) {
    if (user == null) return false;
    return allowedGroups.contains(user!.groupId);
  }

  Future<void> _handleLogout() async {
    await Cache.sharedPreferences.clear();
    Get.offNamed("/Login");
  }
}