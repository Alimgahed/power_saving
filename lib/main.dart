import 'package:power_saving/controller/binding/charts_binding.dart';
import 'package:power_saving/features/reports/binding/reports_binding.dart';
import 'package:power_saving/features/predaction/binding/prediction_binding.dart';
import 'package:power_saving/features/auth/binding/all_user_binding.dart';
import 'package:power_saving/features/planning/binding/blance_binding.dart';
import 'package:power_saving/features/planning/binding/place_types_binding.dart';
import 'package:power_saving/features/planning/view/screens/places/place_types_list_screen.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:power_saving/features/auth/model/login.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance.dart';
import 'package:power_saving/features/planning/view/screens/blance_chart/blance_chart_print_screen.dart';
import 'package:power_saving/features/planning/view/screens/places/add_places.dart';
import 'package:power_saving/features/planning/view/screens/places/edit_places.dart';
import 'package:power_saving/features/planning/view/screens/places/places.dart';
import 'package:power_saving/features/planning/binding/places_binding.dart';
import 'package:power_saving/features/relations/view/screens/relatiuons.dart';
import 'package:power_saving/features/relations/binding/relations_binding.dart';
import 'package:power_saving/features/reports/view/screens/report.dart';
import 'package:power_saving/features/stations/view/screens/following_stations.dart';
import 'package:power_saving/features/stations/binding/following_stations_binding.dart';
import 'package:power_saving/features/tech_bills/view/screens/new_tech_bills.dart';
import 'package:power_saving/features/tech_bills/binding/new_tech_bills_binding.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/shared_pref/cache.dart';
import 'package:power_saving/features/Counter/view/screens/Counter.dart';
import 'package:power_saving/features/Counter/binding/counter_binding.dart';
import 'package:power_saving/features/Counter/view/screens/add_Counter.dart';
import 'package:power_saving/features/Counter/view/screens/edit_counter.dart';
import 'package:power_saving/features/Ploitly.dart';
import 'package:power_saving/features/analysis/view/screen/analysis.dart';
import 'package:power_saving/features/auth/view/screens/all_user.dart';
import 'package:power_saving/features/auth/view/screens/change_password.dart';
import 'package:power_saving/features/auth/view/screens/login.dart';
import 'package:power_saving/features/auth/view/screens/new_user.dart';
import 'package:power_saving/features/bill/view/screens/Tech_bills.dart';
import 'package:power_saving/features/bill/binding/techbills_binding.dart';
import 'package:power_saving/features/bill/view/screens/bills.dart';
import 'package:power_saving/features/bill/binding/bills_binding.dart';
import 'package:power_saving/features/chemcails/view/screens/add_cemicals.dart';
import 'package:power_saving/features/chemcails/view/screens/chemicals.dart';
import 'package:power_saving/features/chemcails/view/screens/edit_chemcials.dart';
import 'package:power_saving/features/home/view/screens/home.dart';
import 'package:power_saving/features/predaction/view/screens/predaction.dart';
import 'package:power_saving/features/relations/view/screens/add_relation.dart';
import 'package:power_saving/features/stations/view/screens/add_station.dart';
import 'package:power_saving/features/stations/view/screens/edit_staion.dart';
import 'package:power_saving/features/stations/view/screens/stations.dart';
import 'package:power_saving/features/tech_bills/view/screens/edit_tech_bills.dart';
import 'package:power_saving/features/tech_bills/view/screens/tech_bills.dart';
import 'package:power_saving/features/tech_bills/binding/techbills_binding.dart';
import 'package:power_saving/features/technology/view/screens/add_tech.dart';
import 'package:power_saving/features/technology/view/screens/edittech.dart';
import 'package:power_saving/features/technology/view/screens/technology.dart';
import 'package:power_saving/test.dart';
import 'package:power_saving/features/home/binding/home_binding.dart';
import 'package:power_saving/features/stations/binding/stations_binding.dart';
import 'package:power_saving/features/technology/binding/technology_binding.dart';
import 'package:power_saving/features/chemcails/binding/chemicals_binding.dart';
import 'package:power_saving/global/app_theme.dart';

import 'global/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(const HashUrlStrategy());

  // ✅ Initialize SharedPreferences before running the app
  await Cache.init();

  // ✅ Initialize reactive Session state container
  Get.put(SessionService(), permanent: true);

  // ✅ Asynchronously parse and initialize cached user on startup
  final jsuser = Cache.getdata(key: "user") ?? "{}";
  if (jsuser.isNotEmpty && jsuser != "{}") {
    try {
      dynamic decoded = jsonDecode(jsuser);
      while (decoded is String) {
        decoded = jsonDecode(decoded);
      }
      user = User.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      showCustomErrorDialog(errorMessage: e.toString());
      debugPrint("Error parsing cached user: $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {




    return GetMaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: user != null ? '/home' : '/Login', 
      getPages: [
                GetPage(name: '/Charts', page: () => SunburstPage(), binding: ChartsBinding()),


        GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding()),

                // GetPage(name: '/Populations', page: () => PopulationsScreen()),

                GetPage(name: '/change_password', page: () => ChangePassword()),
                GetPage(name: '/editPlaces', page: () => EditPlacesScreen()),

        GetPage(name: '/Stations', page: () => StationsScreen(), binding: StationsBinding()),
        GetPage(name: '/Login', page: () => const Login()),
        GetPage(name: '/editMeter', page: () => EditCounterScreen()),
        GetPage(name: '/editStations', page: () => EditStationsScreen()),
        GetPage(name: '/NewUser', page: () => NewUser()),
        GetPage(name: '/addstations', page: () => AddStationScreen()),
        GetPage(name: '/Technology', page: () => Technology(), binding: TechnologyBinding()),
                GetPage(name: '/all_users', page: () => AllUserScreen(), binding: AllUserBinding()),
                GetPage(name: '/EditTechBills', page: () => EditTechBills()),
        GetPage(name: '/Places', page: () => PlacesScreen(), binding: PlacesBinding()),
        GetPage(name: '/placeTypes', page: () => const PlaceTypesListScreen(), binding: PlaceTypesBinding()),
                GetPage(name: '/AddPlaces', page: () => AddPlacesScreen()),
        GetPage(name: '/BlanceCart', page: () => BlanceCart(), binding: BalanceChartBinding()), //
                

        // GetPage(name: '/BalanceChart', page: () => BalanceChart()),
                GetPage(name: '/BalanceChartPrintScreen', page: () => BalanceChartPrintScreen()),

        GetPage(name: '/Edittech', page: () => EditTechScreen()),
        GetPage(name: '/Reports', page: () => Reports(), binding: ReportsBinding()),
        GetPage(name: '/Predictions', page: () => Predaction(), binding: PredictionBinding()),
        GetPage(name: '/analysis', page: () => AnalysisView()),
        GetPage(name: '/addTech', page: () => AddTechScreen()),
        GetPage(name: '/bills', page: () => Bills(), binding: BillsBinding()),
        GetPage(name: '/techBill', page: () => TechBill(), binding: TechBillsBinding()),
        GetPage(name: '/Countrts', page: () => Counterscreen(), binding: CounterBinding()),
        GetPage(name: '/addCounter', page: () => AddElectricMeterScreen()),
        GetPage(name: '/NewTechBills', page: () => NewTechBillsScreen(), binding: NewTechBillsBinding()),
        GetPage(name: '/FollowingStations', page: () => FollowingStationsScreen(), binding: FollowingStationsBinding()),
        GetPage(name: '/Relations', page: () => RelationsScreen(), binding: RelationsBinding()),
        GetPage(name: '/Addrelation', page: () => AddRelationScreen()),
        GetPage(name: '/Chemicals', page: () => Chemicals(), binding: ChemicalsBinding()),
        GetPage(name: '/AddChemicalScreen', page: () => AddChemicalScreen()),
        GetPage(name: '/techbills', page: () => TechBills(), binding: TechbillsBinding()),
        GetPage(name: '/EditChemcials', page: () => EditChemcials()),
        GetPage(name: '/AnimatedGauge', page: () => AnimatedGauge()),
      ],
    );
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
