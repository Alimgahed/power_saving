import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/voltage/financial.dart';

// ignore: use_key_in_widget_constructors
class SunburstPage extends StatelessWidget {
  final FinancialController controller = Get.put(FinancialController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("نسبة توزيع انتاج المياة",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFF1E40AF),
        actions: [
            IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      Get.offNamed('/home');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
        ],
      ),
      body: GetBuilder<FinancialController>(
        builder: (c) {
          if (c.loading.value || c.iframeElement == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: HtmlElementView(viewType: 'sunburst-chart'),
          );
        },
      ),
    );
  }
}
