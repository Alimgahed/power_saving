import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:power_saving/view/Counter/Counter.dart';
import 'package:power_saving/view/Counter/add_Counter.dart';

import 'package:power_saving/view/auth/login.dart';
import 'package:power_saving/view/auth/new_user.dart';
import 'package:power_saving/view/bill/add_bill.dart';
import 'package:power_saving/view/home.dart';
import 'package:power_saving/view/relations/add_relation.dart';
import 'package:power_saving/view/relations/relatiuons.dart';
import 'package:power_saving/view/stations/add_station.dart';
import 'package:power_saving/view/stations/edit_staion.dart';
import 'package:power_saving/view/stations/stations.dart';
import 'package:power_saving/view/technology/add_tech.dart';
import 'package:power_saving/view/technology/edittech.dart';
import 'package:power_saving/view/technology/technology.dart';

void main() {
  setUrlStrategy(
    const HashUrlStrategy(),
  ); // Prevent back navigation issues on reload
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
      theme: ThemeData(textTheme: GoogleFonts.amiriTextTheme()),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => Home()),
        GetPage(name: '/Stations', page: () => StationsScreen()),
        GetPage(name: '/Login', page: () => const Login()),
        GetPage(name: '/editStations', page: () => EditStationsScreen()),

        GetPage(name: '/NewUser', page: () => const NewUser()),
        GetPage(name: '/addstations', page: () => AddStationScreen()),
        GetPage(name: '/Technology', page: () => Technology()),
        GetPage(name: '/Edittech', page: () => Edittech()),
        GetPage(name: '/addTech', page: () => AddTech()),
        GetPage(name: '/Countrts', page: () => Counterscreen()),
        GetPage(name: '/addCounter', page: () => AddElectricMeterScreen()),
        GetPage(name: '/Relations', page: () => RelatiuonsSCREAN()),
        GetPage(name: '/Addrelation', page: () => AddRelation()),
        GetPage(name: '/AddBill', page: () => AddBill()),
      ],
    );
  }
}
