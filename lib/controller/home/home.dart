import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/home.dart';
import 'package:power_saving/network/network.dart';

// ignore: camel_case_types
class homecontroller extends GetxController {
  RxBool looading = false.obs;
  ConsumptionModel? consumptionModel;

  // Reactive values using RxnNum
  RxnNum animatedMoney = RxnNum();
  RxnNum animatedWater = RxnNum();
  RxnNum animatedPower = RxnNum();
  RxnNum animatedChlorine = RxnNum();
  RxnNum animatedLiquidAlum = RxnNum();
  RxnNum animatedSolidAlum = RxnNum();
    RxnNum saintion = RxnNum();



  @override
  void onInit() {
    super.onInit();
    home();
  }

  void home() async {
    try {
      looading.value = true;
      final res = await fetchData("http://$ip/");
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        consumptionModel = ConsumptionModel.fromJson(jsonData);
        looading.value = false;

        animateAll();
        update();
      }
    } catch (e) {
      print(e.toString());
      looading.value = false;
      update();
    }
  }

  void animateAll() {
    if (consumptionModel == null) return;

    animateValue(animatedMoney, consumptionModel!.money ?? 0);
    animateValue(animatedWater, consumptionModel!.water ?? 0);
    animateValue(animatedPower, consumptionModel!.power ?? 0);
    animateValue(animatedChlorine, consumptionModel!.chlorine ?? 0);
    animateValue(animatedLiquidAlum, consumptionModel!.liquidAlum ?? 0);
    animateValue(animatedSolidAlum, consumptionModel!.solidAlum ?? 0);
        animateValue(saintion, consumptionModel!.sanitaion ?? 0);


  }

  void animateValue(RxnNum rxValue, num targetValue) {
    const duration = Duration(milliseconds: 700);
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
