import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:power_saving/gloable/data.dart';
import 'package:power_saving/model/analysis.dart';

class Analysis extends GetxController{
  AnalysisModel?anl;
  
  Future<void> getAnalysis({required int station,required int tech}) async {
    try {
      anl=null;
      final res = await http.get(
        Uri.parse("http://$ip/analysis-single/$station/$tech"),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        anl=AnalysisModel.fromJson(jsonData);
        update(); // returns a String
      
      } 
    // ignore: empty_catches
    } catch (e) {
  
    }
  }
}