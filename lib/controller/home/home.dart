import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/model/home.dart';

// ignore: camel_case_types
class homecontroller extends GetxController {
  ConsumptionModel? consumptionModel;

  // Reactive values using RxnNum
  RxnNum animatedMoney = RxnNum();
  RxnNum animatedWater = RxnNum();
  RxnNum animatedPower = RxnNum();
  RxnNum animatedChlorine = RxnNum();
  RxnNum animatedLiquidAlum = RxnNum();
  RxnNum animatedSolidAlum = RxnNum();

  @override
  void onInit() {
    super.onInit();
    home();
  }

  void home() async {
    try {
      final res = await http.get(Uri.parse("http://172.16.144.197:5000/"));
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        consumptionModel = ConsumptionModel.fromJson(jsonData);
        animateAll();
        update();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void animateAll() {
    if (consumptionModel == null) return;

    animateValue(animatedMoney, consumptionModel!.money);
    animateValue(animatedWater, consumptionModel!.water);
    animateValue(animatedPower, consumptionModel!.power);
    animateValue(animatedChlorine, consumptionModel!.chlorine);
    animateValue(animatedLiquidAlum, consumptionModel!.liquidAlum);
    animateValue(animatedSolidAlum, consumptionModel!.solidAlum);
  }

  void animateValue(RxnNum rxValue, num targetValue) {
    const duration = Duration(milliseconds: 900);
    const interval = Duration(milliseconds: 5);
    int steps = duration.inMilliseconds ~/ interval.inMilliseconds;
    num stepValue = targetValue / steps;
    num current = 0.0;

    Timer.periodic(interval, (timer) {
      current += stepValue;
      if (current >= targetValue) {
        rxValue.value = targetValue;
        timer.cancel();
      } else {
        rxValue.value = current;
      }
    });
  }
}
