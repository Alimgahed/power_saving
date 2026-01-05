import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/home/controller/home.dart';
import 'package:power_saving/features/home/view/widgets/home_app_bar.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'package:power_saving/features/home/view/widgets/home_header_state.dart';
import 'package:power_saving/features/home/view/widgets/over_consampation.dart';
import 'package:power_saving/features/home/view/widgets/over_water_stations.dart';


/// Main Home Screen Widget
/// 
/// This screen serves as the main dashboard for the power saving application.
/// It displays key statistics, consumption data, and alerts for various resources.
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
        drawer: HomeDrawer(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        if (controller.loading.value) {
          return const Center(
            child:Text('جاري التحميل...'),
          );
        }

        final data = controller.consumptionModel;
        if (data == null) {
          return const Center(
            child: Text('لا توجد بيانات متاحة'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeaderStats(controller: controller),
              const SizedBox(height: 24),
              _buildConsumptionSections(data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsumptionSections(dynamic data) {
    return Column(
      children: [
        if (data.overPowerConsump?.isNotEmpty ?? false)
          OverConsumptionSection(
            title: 'الاستهلاك خارج الحد المسموح للطاقة',
            data: data.overPowerConsump ?? [],
            label: "الكهرباء",
            unit: "واط",
            icon: Icons.electrical_services,
            color: Colors.blue,
          ),
        
        if (data.overpowerfor0water?.isNotEmpty ?? false)
          OverConsumptionSection(
            title: 'الاستهلاك خارج الحد المسموح للإنارة (اعلي من 1200 واط)',
            data: data.overpowerfor0water ?? [],
            label: "الإنارة",
            unit: "واط",
            icon: Icons.lightbulb_outline,
            color: const Color.fromARGB(255, 255, 239, 192),
          ),
        
        if (data.overChlorineConsump?.isNotEmpty ?? false)
          OverConsumptionSection(
            title: 'الاستهلاك خارج الحد المسموح للكلور',
            data: data.overChlorineConsump ?? [],
            label: "الكلور",
            unit: "مجم/لتر",
            icon: Icons.water_drop,
            color: Colors.cyan,
          ),
        
        if (data.overLiquidAlumConsump?.isNotEmpty ?? false)
          OverConsumptionSection(
            title: 'الاستهلاك خارج الحد المسموح للشبة السائلة',
            data: data.overLiquidAlumConsump ?? [],
            label: "الشبة السائلة",
            unit: "مجم/لتر",
            icon: Icons.opacity,
            color: const Color.fromARGB(255, 255, 202, 122),
          ),
        
        if (data.overSolidAlumConsump?.isNotEmpty ?? false)
          OverConsumptionSection(
            title: 'الاستهلاك خارج الحد المسموح للشبة الصلبة',
            data: data.overSolidAlumConsump ?? [],
            label: "الشبة الصلبة",
            unit: "مجم/لتر",
            icon: Icons.grain,
            color: Colors.brown,
          ),
        
        if (data.overWaterStations?.isNotEmpty ?? false)
          OverWaterStationsSection(
            title: 'محطات انتاجها تجاوز الطاقة التصميمة',
            data: data.overWaterStations ?? [],
            color: Colors.blue,
          ),
      ],
    );
  }
}