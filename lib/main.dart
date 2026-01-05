import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart';
import 'package:power_saving/features/planning/view/screens/places/add_places.dart';
import 'package:power_saving/features/planning/view/screens/places/edit_places.dart';
import 'package:power_saving/features/planning/view/screens/places/places.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/Counter/view/screens/Counter.dart';
import 'package:power_saving/features/Counter/view/screens/add_Counter.dart';
import 'package:power_saving/features/Counter/view/screens/edit_counter.dart';
import 'package:power_saving/features/Ploitly.dart';
import 'package:power_saving/features/analysis/view/screen/analysis.dart';
import 'package:power_saving/features/auth/view/screens/all_user.dart';
import 'package:power_saving/features/auth/view/screens/change_password.dart';
import 'package:power_saving/features/auth/view/screens/login.dart';
import 'package:power_saving/features/auth/view/screens/new_user.dart';
import 'package:power_saving/features/bill/view/screens/Tech_bills.dart';
import 'package:power_saving/features/bill/view/screens/bills.dart';
import 'package:power_saving/features/chemcails/view/screens/add_cemicals.dart';
import 'package:power_saving/features/chemcails/view/screens/chemicals.dart';
import 'package:power_saving/features/chemcails/view/screens/edit_chemcials.dart';
import 'package:power_saving/features/home/view/screens/home.dart';
import 'package:power_saving/features/predaction/view/screens/predaction.dart';
import 'package:power_saving/features/relations/view/screens/add_relation.dart';
import 'package:power_saving/features/relations/view/screens/relations.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import 'package:power_saving/features/stations/view/screens/add_station.dart';
import 'package:power_saving/features/stations/view/screens/edit_staion.dart';
import 'package:power_saving/features/stations/view/screens/stations.dart';
import 'package:power_saving/features/tech_bills/view/screens/edit_tech_bills.dart';
import 'package:power_saving/features/tech_bills/view/screens/tech_bills.dart';
import 'package:power_saving/features/technology/view/screens/add_tech.dart';
import 'package:power_saving/features/technology/view/screens/edittech.dart';
import 'package:power_saving/features/technology/view/screens/technology.dart';
import 'package:power_saving/test.dart';

import 'gloable/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());

  // ✅ Initialize SharedPreferences before running the app
  await Cache.init();

  runApp(const MyApp());
}

// Initialize with default values
double width = 0.0;
double height = 0.0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 var jsuser = Cache.getdata(key: "user") ?? "{}";

if (jsuser.isNotEmpty && jsuser != "{}") {
  try {
    dynamic decoded = jsonDecode(jsuser);
    
    // Keep decoding until we get a Map
    while (decoded is String) {
      decoded = jsonDecode(decoded);
    }
    
    user = User.fromJson(decoded as Map<String, dynamic>);
  // ignore: empty_catches
  } catch (e) {
  }
}




    return GetMaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.almaraiTextTheme()),
      initialRoute: '/home', 
      getPages: [
                GetPage(name: '/Charts', page: () =>         SunburstPage()),


        GetPage(name: '/home', page: () => HomeScreen()),

                // GetPage(name: '/Populations', page: () => PopulationsScreen()),

                GetPage(name: '/change_password', page: () => ChangePassword()),
                GetPage(name: '/editPlaces', page: () => EditPlacesScreen()),

        GetPage(name: '/Stations', page: () => StationsScreen()),
        GetPage(name: '/Login', page: () => const Login()),
        GetPage(name: '/editMeter', page: () => EditCounterScreen()),
        GetPage(name: '/editStations', page: () => EditStationsScreen()),
        GetPage(name: '/NewUser', page: () => NewUser()),
        GetPage(name: '/addstations', page: () => AddStationScreen()),
        GetPage(name: '/Technology', page: () => Technology()),
                GetPage(name: '/all_users', page: () => AllUserScreen()),
                GetPage(name: '/EditTechBills', page: () => EditTechBills()),
        GetPage(name: '/Places', page: () => PlacesScreen()),
                GetPage(name: '/AddPlaces', page: () => AddPlacesScreen()),
        GetPage(name: '/BlanceCart', page: () => BlanceCart()), //
                

        // GetPage(name: '/BalanceChart', page: () => BalanceChart()),
                GetPage(name: '/BalanceChartPrintScreen', page: () => BalanceChartPrintScreen()),

        GetPage(name: '/Edittech', page: () => EditTechScreen()),
        GetPage(name: '/Reports', page: () => Reports()),
        GetPage(name: '/Predictions', page: () => Predaction()),
        GetPage(name: '/analysis', page: () => AnalysisView()),
        GetPage(name: '/addTech', page: () => AddTechScreen()),
        GetPage(name: '/bills', page: () => Bills()),
        GetPage(name: '/techBill', page: () => TechBill()),
        GetPage(name: '/Countrts', page: () => Counterscreen()),
        GetPage(name: '/addCounter', page: () => AddElectricMeterScreen()),
        GetPage(name: '/Relations', page: () => RelationsScreen()),
        GetPage(name: '/Addrelation', page: () => AddRelationScreen()),
        GetPage(name: '/Chemicals', page: () => Chemicals()),
        GetPage(name: '/AddChemicalScreen', page: () => AddChemicalScreen()),
        GetPage(name: '/techbills', page: () => TechBills()),
        GetPage(name: '/EditChemcials', page: () => EditChemcials()),
        GetPage(name: '/AnimatedGauge', page: () => AnimatedGauge()),
      ],
      onInit: () {
        _initializeDimensions();
      },
    );
  }

  void _initializeDimensions() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        height = Get.height;
        width = Get.width;
     
      }
    });
  }
}

class ScreenUtils {
  static double get width => Get.width;
  static double get height => Get.height;

  
}

class ScreenController extends GetxController {
  RxDouble screenWidth = 0.0.obs;
  RxDouble screenHeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    updateDimensions();
  }

  void updateDimensions() {
    screenWidth.value = Get.width;
    screenHeight.value = Get.height;
    
  }
}
