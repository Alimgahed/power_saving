import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
   Home({super.key});

      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.blue),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open drawer from the left
          },
        ),
      ),
      drawer: Drawer( // Use drawer instead of endDrawer
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            list_view(icon: Icons.ev_station, text: "المحطات", ontap: () {
              Get.toNamed("/Stations");
            }),
            list_view(icon: Icons.charging_station_rounded, text: "العدادت", ontap: () {
               Get.toNamed( "/Countrts");
              
            }),
            list_view(icon: Icons.receipt_long, text: "الفواتير", ontap: () {}),
            list_view(icon: Icons.price_change, text: "التعريفه", ontap: () {}),
            list_view(icon: Icons.memory, text: "التكنولوجيا", ontap: () {              Get.toNamed("/Technology");
}),
            list_view(icon: Icons.ac_unit_sharp, text: "الربط", ontap: () {              Get.toNamed("/Relations");
}),
            list_view(icon: Icons.bar_chart, text: "التقارير", ontap: () {}),
            list_view(icon: Icons.person_add_alt_outlined, text: "مستخدم جديد", ontap: () {
              Get.toNamed('/NewUser');
            }),
            list_view(icon: Icons.login, text: "تسجل دخول", ontap: () {
              Get.toNamed("/Login");
            }),
            list_view(icon: Icons.logout, text: "تسجيل خروج", ontap: () {}),
          ],
        ),
      ),
    );
  }

  // Widget for drawer item
  Widget list_view({
    required IconData icon,
    required String text,
    required VoidCallback ontap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: ontap,
    );
  }
}
