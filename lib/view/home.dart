import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:power_saving/controller/home/home.dart';
import 'package:power_saving/controller/voltage/voltage.dart';
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/home.dart';
import 'package:power_saving/model/vlotage.dart';
import 'package:power_saving/my_widget/home.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/shared_pref/cache.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Helper method to check authentication before navigation
  void _navigateWithAuth(String route) {
    if (user != null) {
      Get.toNamed(route);
    } else {
      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
    }
  }

  // Helper method with arguments
  void _navigateWithAuthAndArgs(String route, dynamic arguments) {
    if (user != null) {
      Get.toNamed(route, arguments: arguments);
    } else {
      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'لوحة التحكم الرئيسية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              // Drawer Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(color: Color(0xFF1E40AF)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.dashboard, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'نظام إدارة الطاقة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // المحطات
              if(user?.groupId==1||user?.groupId==2)
              list_view(
                icon: Icons.ev_station,
                text: "المحطات",
                ontap: () => _navigateWithAuth("/Stations"),
              ),
              
              // العدادت
              if(user?.groupId != 2&&user?.groupId!=4)
                list_view(
                  icon: Icons.charging_station_rounded,
                  text: "العدادت",
                  ontap: () => _navigateWithAuth("/Countrts"),
                ),
              
              // التعريفه
              if(user?.groupId != 2 && user?.groupId != 4)
                list_view(
                  icon: Icons.price_change,
                  text: "التعريفه",
                  ontap: () async {
                    if (user != null) {
                      Voltage voltageController = Get.put(Voltage());
                      await voltageController.allVoltage();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(16),
                            content: SizedBox(
                              height: 280,
                              child: GetBuilder<Voltage>(
                                builder: (controller) {
                                  final GlobalKey<FormState> _globalKey =
                                      GlobalKey<FormState>();

                                  return Form(
                                    key: _globalKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                "الجهد المتوسط",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: CustomTextFormField(
                                                label: 'الرسوم الثابتة',
                                                hintText: 'أدخل الرسوم الثابتة',
                                                controller: controller.avaargefixed,
                                                icon: Icons.attach_money,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: CustomTextFormField(
                                                label: 'تكلفة الجهد',
                                                hintText: 'أدخل تكلفة الجهد',
                                                controller: controller.avaragecost,
                                                icon: Icons.electrical_services,
                                              ),
                                            ),
                                            Expanded(
                                              child: Obx(() {
                                                return Center(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_globalKey.currentState!
                                                          .validate()) {
                                                        controller.vlotages.add(
                                                          VoltagePlan(
                                                            fixedFee:
                                                                double.tryParse(
                                                                  controller
                                                                      .lowfixed
                                                                      .text,
                                                                )!,
                                                            voltageCost:
                                                                double.tryParse(
                                                                  controller
                                                                      .lowcost
                                                                      .text,
                                                                )!,
                                                            voltageId: 1,
                                                            voltageType: 'منخفض',
                                                          ),
                                                        );

                                                        controller.vlotages.add(
                                                          VoltagePlan(
                                                            fixedFee:
                                                                double.tryParse(
                                                                  controller
                                                                      .avaargefixed
                                                                      .text,
                                                                )!,
                                                            voltageCost:
                                                                double.tryParse(
                                                                  controller
                                                                      .avaragecost
                                                                      .text,
                                                                )!,
                                                            voltageId: 2,
                                                            voltageType: 'متوسط',
                                                          ),
                                                        );
                                                        await controller.editVoltage(
                                                          volt: VoltagePlan(
                                                            fixedFee:
                                                                double.tryParse(
                                                                  controller
                                                                      .avaargefixed
                                                                      .text,
                                                                )!,
                                                            voltageCost:
                                                                double.tryParse(
                                                                  controller
                                                                      .avaragecost
                                                                      .text,
                                                                )!,
                                                            voltageId: 2,
                                                            voltageType: 'متوسط',
                                                          ),
                                                          voltid: 2,
                                                        );
                                                      }
                                                    },
                                                    child:
                                                        controller.isLoading.value
                                                            ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 2,
                                                                    color:
                                                                        Colors.blue,
                                                                  ),
                                                            )
                                                            : const Text("حفظ"),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                "الجهد المنخفض",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: CustomTextFormField(
                                                label: 'الرسوم الثابتة',
                                                hintText: 'أدخل الرسوم الثابتة',
                                                controller: controller.lowfixed,
                                                icon: Icons.attach_money,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: CustomTextFormField(
                                                label: 'تكلفة الجهد',
                                                hintText: 'أدخل تكلفة الجهد',
                                                controller: controller.lowcost,
                                                icon: Icons.electrical_services,
                                              ),
                                            ),
                                            Expanded(
                                              child: Obx(() {
                                                return Center(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (_globalKey.currentState!
                                                          .validate()) {
                                                        await controller
                                                            .editVoltage(
                                                              volt: VoltagePlan(
                                                                fixedFee:
                                                                    double.tryParse(
                                                                      controller
                                                                          .lowfixed
                                                                          .text,
                                                                    )!,
                                                                voltageCost:
                                                                    double.tryParse(
                                                                      controller
                                                                          .lowcost
                                                                          .text,
                                                                    )!,
                                                                voltageId: 1,
                                                                voltageType:
                                                                    'منخفض',
                                                              ),
                                                              voltid: 1,
                                                            );
                                                      }
                                                    },
                                                    child:
                                                        controller.isLoading.value
                                                            ? const SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth: 2,
                                                                    color:
                                                                        Colors.blue,
                                                                  ),
                                                            )
                                                            : const Text("حفظ"),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      showCustomErrorDialog(errorMessage: "برجاء تسجيل دخول");
                    }
                  },
                ),
              
              // التكنولوجيا
              if(user?.groupId != 4)
                list_view(
                  icon: Icons.memory,
                  text: "التكنولوجيا",
                  ontap: () => _navigateWithAuth("/Technology"),
                ),
              
              // الربط
              if(user?.groupId != 2 && user?.groupId != 4)
                list_view(
                  icon: Icons.ac_unit_sharp,
                  text: "الربط",
                  ontap: () => _navigateWithAuth("/Relations"),
                ),
              
              // الكماويات
              if(user?.groupId != 2 && user?.groupId != 3)
                list_view(
                  icon: Icons.science,
                  text: "الكماويات",
                  ontap: () => _navigateWithAuth("/Chemicals"),
                ),
              
              // المكتب الفني
              if(user?.groupId != 3 && user?.groupId != 4)
                list_view(
                  icon: Icons.engineering,
                  text: "المكتب الفني",
                  ontap: () => _navigateWithAuth("/techbills"),
                ),
              
              // التوقعات
              if(user?.groupId != 3 && user?.groupId != 4)
                list_view(
                  icon: Icons.water_drop_outlined,
                  text: "التوقعات",
                  ontap: () => _navigateWithAuth('./Predictions'),
                ),

              if (user?.groupId!=4)
              list_view(
                icon: Icons.bar_chart,
                text: "التقارير",
                ontap: () => _navigateWithAuth('./Reports'),
              ),
              
              // مستخدم جديد
              if(user?.groupId == 1)
                list_view(
                  icon: Icons.person_add_alt_outlined,
                  text: "مستخدم جديد",
                  ontap: () => _navigateWithAuth('/NewUser'),
                ),
               list_view(
                  icon: Icons.password_outlined,
                  text: "تغيير كلمة المرور",
                  ontap: () => _navigateWithAuth('/change_password'),
                ),
              // تسجل دخول
              if(user == null)
                list_view(
                  icon: Icons.login,
                  text: "تسجل دخول",
                  ontap: () {
                    Get.toNamed("/Login");
                  },
                ),
              
              // تسجيل خروج
              if(user != null)
                list_view(
                  icon: Icons.logout,
                  text: "تسجيل خروج",
                  ontap: () async {
                    // await postData("http://$ip/logout",{

                    // });
                  await  Cache.sharedPreferences.clear();
                    Get.offNamed("/Login");
                  },
                ),
            ],
          ),
        ),
        body: GetBuilder<homecontroller>(
          init: homecontroller(),
          builder: (controller) {
            if (controller.looading.value == true) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1E40AF)),
              );
            }

            final data = controller.consumptionModel!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Main Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'إجمالي التكلفة',
                                  '${NumberFormat('#,###').format(controller.animatedMoney.value ?? 0)} جنيه',
                                  Icons.attach_money,
                                  Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية المياة المنتجة',
                                  '${NumberFormat('#,###').format(controller.animatedWater.value ?? 0)} م³',
                                  Icons.opacity,
                                  Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                             Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية المياة المرفوعه',
                                  '${NumberFormat('#,###').format(controller.saintion.value ?? 0)} م³',
                                  Icons.opacity,
                                  Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  ' الكهرياء المستهلكة',
                                  '${NumberFormat('#,###').format(controller.animatedPower.value ?? 0)} واط',
                                  Icons.electrical_services,
                                  Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الكلور',
                                  '${NumberFormat('#,###').format(controller.animatedChlorine.value ?? 0)} جرام',
                                  Icons.science,
                                  Colors.cyan,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الشبة السائلة',
                                  '${NumberFormat('#,###').format(controller.animatedLiquidAlum.value ?? 0)} جرام',
                                  Icons.water_drop_outlined,
                                  Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => _buildStatCard(
                                  'كمية الشبة الصلبة',
                                  '${NumberFormat('#,###').format(controller.animatedSolidAlum.value ?? 0)} جرام',
                                  Icons.ac_unit,
                                  Colors.brown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Over Consumption Sections
                  const SizedBox(height: 24),
                  if (data.overPowerConsump?.isNotEmpty ?? false)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للطاقة',
                      data.overPowerConsump ?? [],
                      "الكهرباء",
                      "واط",
                      Icons.electrical_services,
                      Icons.electrical_services,
                      Colors.blue,
                    ),

                  if (data.overChlorineConsump?.isNotEmpty ?? false)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للكلور',
                      data.overChlorineConsump ?? [],
                      "الكلور",
                      "مجم/لتر",
                      Icons.water_drop,
                      Icons.water_drop,
                      Colors.blue,
                    ),
                  if (data.overLiquidAlumConsump?.isNotEmpty ?? false)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للشبة السائلة',
                      data.overLiquidAlumConsump ?? [],
                      "الشبة السائلة",
                      "مجم/لتر",
                      Icons.opacity,
                      Icons.opacity,
                      Colors.blue,
                    ),
                  if (data.overSolidAlumConsump?.isNotEmpty ?? false)
                    _buildOverConsumptionSection(
                      'الاستهلاك خارج الحد المسموح للشبة الصلبة',
                      data.overSolidAlumConsump ?? [],
                      "الشبة الصلبة",
                      "مجم/لتر",
                      Icons.grain,
                      Icons.grain,
                      Colors.blue,
                    ),
                  if (data.overWaterStations?.isNotEmpty ?? false)
                    _buildOverwaterstations(
                      'محطات انتاجها تجاوز الطاقة التصميمة',
                      data.overWaterStations ?? [],
                      "الشبة الصلبة",
                      "مجم/لتر",
                      Icons.grain,
                      Icons.grain,
                      Colors.blue,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverConsumptionSection(
    String title,
    List<OverConsump> data,
    String label,
    String value,
    IconData icon,
    IconData icons,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${data.length} عنصر',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            child: data.isEmpty 
              ? _buildEmptyState(color)
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return _buildProfessionalCard(item, label, icons, color);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(
    OverConsump item,
    String label,
    IconData icons,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _navigateWithAuthAndArgs(
          '/analysis',
          {
            'station': item.stationId,
            'tech': item.technologyId,
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.electric_meter_outlined,
                      color: color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'محطة ${item.stationName}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'رقم المحطة: ${item.stationId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfessionalDetailItem(
                      'التاريخ',
                      '${item.billMonth} / ${item.billYear}',
                      Icons.calendar_today_outlined,
                      Colors.blue.shade600,
                      isHighlight: true,
                    ),
                    const SizedBox(height: 5),
                    _buildProfessionalDetailItem(
                      'التقنية',
                      item.technologyName,
                      Icons.memory_outlined,
                      Colors.teal.shade600,
                      isHighlight: true,
                    ),
                    const SizedBox(height: 5),
                    _buildProfessionalDetailItem(
                      label,
                      _getItemValue(item, label),
                      icons,
                      Colors.indigo.shade600,
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.1),
                            color.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 16,
                            color: color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'عرض التحليل',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalDetailItem(
    String title,
    String value,
    IconData icon,
    Color color,
    {bool isHighlight = false}
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight ? color.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight 
          ? Border.all(color: color.withOpacity(0.2), width: 1)
          : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isHighlight ? color : Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 48,
              color: color.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات متاحة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي بيانات استهلاك مفرط',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverwaterstations(
    String title,
    List<OverWaterStation> data,
    String label,
    String value,
    IconData icon,
    IconData icons,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${data.length} محطة',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 500,
            padding: const EdgeInsets.all(20),
            child: data.isEmpty 
              ? _buildWaterEmptyState(color)
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return _buildProfessionalWaterCard(item, color);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalWaterCard(
    OverWaterStation item,
    Color color,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 320,
      height: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'محطة ${item.stationName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWaterDetailItem(
                    'التاريخ',
                    '${item.month} / ${item.year}',
                    Icons.calendar_today_outlined,
                    Colors.blue.shade600,
                  ),
                  const SizedBox(height: 12),
                  _buildWaterDetailItem(
                    'الطاقة التصميمية الشهرية',
                    '${item.capacityLimit} م³ / شهر',
                    Icons.speed_outlined,
                    Colors.orange.shade600,
                    isPercentage: true,
                  ),
                  const SizedBox(height: 12),
                  _buildWaterDetailItem(
                    'الطاقة التصميمية',
                    '${item.waterCapacity} م³/ يوم',
                    Icons.engineering_outlined,
                    Colors.teal.shade600,
                  ),
                  const SizedBox(height: 12),
                  _buildWaterDetailItem(
                    'إجمالي المياه',
                    _formatWaterAmount(item.totalWater),
                    Icons.opacity_outlined,
                    Colors.indigo.shade600,
                    isHighlight: true,
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusIndicator(item, color),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(color),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterDetailItem(
    String title,
    String value,
    IconData icon,
    Color color,
    {bool isHighlight = false, bool isPercentage = false, double percentageValue = 0}
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlight ? color.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight 
          ? Border.all(color: color.withOpacity(0.2), width: 1)
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isHighlight ? color : Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isPercentage && percentageValue > 0) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentageValue / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentageValue > 80 ? Colors.red.shade400 :
                percentageValue > 60 ? Colors.orange.shade400 :
                Colors.green.shade400
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(OverWaterStation item, Color color) {
    final capacity = double.tryParse(item.capacityLimit.toString()) ?? 0;
    final isOverCapacity = capacity > 100;
    final statusColor = isOverCapacity ? Colors.red : 
                       capacity > 80 ? Colors.orange : Colors.green;
    final statusText = isOverCapacity ? 'تجاوز السعة' : 
                       capacity > 80 ? 'قريب من السعة' : 'ضمن السعة';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.analytics_outlined,
        size: 18,
        color: color,
      ),
    );
  }

  Widget _buildWaterEmptyState(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.water_drop_outlined,
              size: 48,
              color: Colors.blue.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد محطات مياه متاحة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي بيانات لمحطات المياه',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatWaterAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)} مليون م³';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)} ألف م³';
    } else {
      return '${amount.toStringAsFixed(2)} م³';
    }
  }

  String _getItemValue(OverConsump item, String label) {
    switch (label) {
      case "الكهرباء":
        return "${NumberFormat('#,###').format(item.technologyPowerConsump)} واط";
      case "الكلور":
        return "${NumberFormat('#,###').format(item.technologyChlorineConsump)} جرام";
      case "الشبة السائلة":
        return "${NumberFormat('#,###').format(item.technologyLiquidAlumConsump)} جرام";
      case "الشبة الصلبة":
        return "${NumberFormat('#,###').format(item.technologySolidAlumConsump)} جرام";
      default:
        return "";
    }
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}