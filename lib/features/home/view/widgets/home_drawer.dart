import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/home/view/widgets/navigation_helper.dart';
import 'package:power_saving/features/home/view/widgets/voltaige.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/core/auth/session_manager.dart';

// --- Theme Colors for Drawer ---
const Color _drawerBg = Color(0xFF091C31);
const Color _sectionTextColor = Color(0xFF88A2C4);
const Color _dividerColor = Color(0xFF16325B);
const Color _activeItemBg = Color(0xFF16528E);
const Color _iconColor = Colors.white;
const Color _textColor = Colors.white;

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final NavigationHelper _navigationHelper = NavigationHelper();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: _drawerBg,
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _buildMenuItem(
                    icon: Icons.home_rounded,
                    text: "الرئيسية",
                    onTap: () {
                      Get.back(); // close drawer
                    },
                    isActive: true,
                  ),
                  const SizedBox(height: 10),

                  _buildSectionHeader("الإعدادات الأساسية"),
                  if (_hasAccess([1, 2, 6, 7]))
                    _buildMenuItem(
                      icon: Icons.location_city_rounded,
                      text: "المحطات",
                      onTap: () => _navigationHelper.navigateWithAuth("/Stations"),
                    ),
                  if (_hasAccess([1, 2, 3, 7]))
                    _buildMenuItem(
                      icon: Icons.settings_suggest_rounded,
                      text: "التكنولوجيا",
                      onTap: () => _navigationHelper.navigateWithAuth("/Technology"),
                    ),
                  if (_hasAccess([1, 4, 6, 7]))
                    _buildMenuItem(
                      icon: Icons.science_rounded,
                      text: "الكيماويات",
                      onTap: () => _navigationHelper.navigateWithAuth("/Chemicals"),
                    ),
                  if (_hasAccess([1, 3]))
                    _buildMenuItem(
                      icon: Icons.price_change_rounded,
                      text: "التعريفه",
                      onTap: () => VoltageDialogHelper.showVoltageDialog(context),
                    ),
                  if (_hasAccess([1, 3, 7]))
                    _buildMenuItem(
                      icon: Icons.cable_rounded,
                      text: "الربط",
                      onTap: () => _navigationHelper.navigateWithAuth("/Relations"),
                    ),
                  if (_hasAccess([1, 5]))
                    _buildMenuItem(
                      icon: Icons.place_outlined,
                      text: "المدن والقري",
                      onTap: () => _navigationHelper.navigateWithAuth('./Places'),
                    ),

                  const SizedBox(height: 10),
                  _buildSectionHeader("العمليات"),
                  if (_hasAccess([1, 3]))
                    _buildMenuItem(
                      icon: Icons.speed_rounded,
                      text: "العدادت",
                      onTap: () => _navigationHelper.navigateWithAuth("/Countrts"),
                    ),
                  if (_hasAccess([1, 3]))
                    _buildMenuItem(
                      icon: Icons.receipt_long_rounded,
                      text: "الفواتير",
                      onTap: () => _navigationHelper.navigateWithAuth('./bills'),
                    ),
                  if (_hasAccess([1, 2, 3, 7]))
                    _buildMenuItem(
                      icon: Icons.receipt_rounded,
                      text: "فواتير التقنيات",
                      onTap: () => _navigationHelper.navigateWithAuth('./techBill'),
                    ),
                  if (_hasAccess([1, 2]))
                    _buildMenuItem(
                      icon: Icons.edit_document,
                      text: "المكتب الفني",
                      onTap: () => _navigationHelper.navigateWithAuth("/techbills"),
                    ),
                  if (_hasAccess([1, 2]))
                    _buildMenuItem(
                      icon: Icons.add_chart_rounded,
                      text: "ادخال كميات مياة جديدة",
                      onTap: () => _navigationHelper.navigateWithAuth("/NewTechBills"),
                    ),
                  _buildMenuItem(
                    icon: Icons.ev_station_rounded,
                    text: "متابعة المحطات",
                    onTap: () => _navigationHelper.navigateWithAuth('./FollowingStations'),
                  ),
                  if (_hasAccess([1, 2, 6, 7]))
                    _buildMenuItem(
                      icon: Icons.water_drop_rounded,
                      text: "التوقعات",
                      onTap: () => _navigationHelper.navigateWithAuth('./Predictions'),
                    ),

                  const SizedBox(height: 10),
                  _buildSectionHeader("التحليل والتقارير"),
                  _buildMenuItem(
                    icon: Icons.bar_chart_rounded,
                    text: "التحليل الأقتصادي",
                    onTap: () => _navigationHelper.navigateWithAuth('./Charts'),
                  ),
                  if (_hasAccess([1, 2, 4, 3, 6, 7]))
                    _buildMenuItem(
                      icon: Icons.analytics_rounded,
                      text: "التقارير",
                      onTap: () => _navigationHelper.navigateWithAuth('./Reports'),
                    ),
                  if (_hasAccess([1, 5]))
                    _buildMenuItem(
                      icon: Icons.show_chart_rounded,
                      text: "منحني الأتزان",
                      onTap: () => _navigationHelper.navigateWithAuth('./BlanceCart'),
                    ),

                  const SizedBox(height: 10),
                  _buildSectionHeader("الإدارة"),
                  if (_hasAccess([1]))
                    _buildMenuItem(
                      icon: Icons.people_alt_rounded,
                      text: "المستخدمين",
                      onTap: () => _navigationHelper.navigateWithAuth('/all_users'),
                    ),
                  if (_hasAccess([1]))
                    _buildMenuItem(
                      icon: Icons.person_add_rounded,
                      text: "مستخدم جديد",
                      onTap: () => _navigationHelper.navigateWithAuth('/NewUser'),
                    ),
                  _buildMenuItem(
                    icon: Icons.lock_person_rounded,
                    text: "تغيير كلمة المرور",
                    onTap: () => _navigationHelper.navigateWithAuth('/change_password'),
                  ),
                  if (user == null)
                    _buildMenuItem(
                      icon: Icons.login_rounded,
                      text: "تسجيل دخول",
                      onTap: () => Get.toNamed("/Login"),
                    ),
                  if (user != null)
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      text: "تسجيل خروج",
                      onTap: () => _handleLogout(),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: _drawerBg,
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'images/Gemini_Generated_Image_f6db4f6db4f6db4f.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.water_drop, color: Colors.blueAccent, size: 40);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'شركة مياه الشرب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'والصرف الصحي بالمنيا',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: _sectionTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: _dividerColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.white10,
        highlightColor: Colors.white10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? _activeItemBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: _iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: isActive ? Colors.white70 : _sectionTextColor, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasAccess(List<int> allowedGroups) {
    if (user == null) return false;
    return allowedGroups.contains(user!.groupId);
  }

  Future<void> _handleLogout() async {
    await SessionManager.logout();
  }
}