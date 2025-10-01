import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:power_saving/model/login.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/view/Counter/Counter.dart';
import 'package:power_saving/view/Counter/add_Counter.dart';
import 'package:power_saving/view/Counter/edit_counter.dart';
import 'package:power_saving/view/analysis/analysis.dart';
import 'package:power_saving/view/auth/change_password.dart';
import 'package:power_saving/view/auth/login.dart';
import 'package:power_saving/view/auth/new_user.dart';
import 'package:power_saving/view/bill/add_bill.dart';
import 'package:power_saving/view/chemcails/add_cemicals.dart';
import 'package:power_saving/view/chemcails/chemicals.dart';
import 'package:power_saving/view/chemcails/edit_chemcials.dart';
import 'package:power_saving/view/home.dart';
import 'package:power_saving/view/predaction/predaction.dart';
import 'package:power_saving/view/relations/add_relation.dart';
import 'package:power_saving/view/relations/relatiuons.dart';
import 'package:power_saving/view/reports/report.dart';
import 'package:power_saving/view/stations/add_station.dart';
import 'package:power_saving/view/stations/edit_staion.dart';
import 'package:power_saving/view/stations/stations.dart';
import 'package:power_saving/view/tech_bills/tech_bills.dart';
import 'package:power_saving/view/technology/add_tech.dart';
import 'package:power_saving/view/technology/edittech.dart';
import 'package:power_saving/view/technology/technology.dart';

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
  } catch (e) {
    print("Error decoding user data: $e");
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
        
        GetPage(name: '/home', page: () => Home()),
                GetPage(name: '/change_password', page: () => ChangePassword()),

        GetPage(name: '/Stations', page: () => StationsScreen()),
        GetPage(name: '/Login', page: () => const Login()),
        GetPage(name: '/editMeter', page: () => editCounter()),
        GetPage(name: '/editStations', page: () => EditStationsScreen()),
        GetPage(name: '/NewUser', page: () => NewUser()),
        GetPage(name: '/addstations', page: () => AddStationScreen()),
        GetPage(name: '/Technology', page: () => Technology()),
        GetPage(name: '/Edittech', page: () => Edittech()),
        GetPage(name: '/Reports', page: () => Reports()),
        GetPage(name: '/Predictions', page: () => Predaction()),
        GetPage(name: '/analysis', page: () => AnalysisView()),
        GetPage(name: '/addTech', page: () => AddTech()),
        GetPage(name: '/Countrts', page: () => Counterscreen()),
        GetPage(name: '/addCounter', page: () => AddElectricMeterScreen()),
        GetPage(name: '/Relations', page: () => RelatiuonsSCREAN()),
        GetPage(name: '/Addrelation', page: () => AddRelation()),
        GetPage(name: '/Chemicals', page: () => Chemicals()),
        GetPage(name: '/AddChemicalScreen', page: () => AddChemicalScreen()),
        GetPage(name: '/techbills', page: () => TechBills()),
        GetPage(name: '/EditChemcials', page: () => EditChemcials()),
        GetPage(name: '/AddBill', page: () => AddBill()),
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
        print('Height: $height');
        print('Width: $width');
      }
    });
  }
}

class ScreenUtils {
  static double get width => Get.width;
  static double get height => Get.height;

  static void printDimensions() {
    print('Height: ${height}');
    print('Width: ${width}');
  }
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
    print('Height: ${screenHeight.value}');
    print('Width: ${screenWidth.value}');
  }
}
