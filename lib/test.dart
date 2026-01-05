import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MaterialApp(home: AnimatedGauge()));
}

class GaugeController extends GetxController {
  // قيمة العداد
  var currentValue = 0.0.obs;
  
  // القيمة الدنيا والعليا للعداد
  final double minValue = 0.0;
  final double maxValue = 100.0;

  // دالة لتحديث القيمة
  void updateValue(double value) {
    currentValue.value = value.clamp(minValue, maxValue);
  }

  // بدء الأنيميشن للتغيير التدريجي للقيمة
  void startAnimation() {
    for (double i = minValue; i <= maxValue; i += 0.5) {
      Future.delayed(Duration(milliseconds: 10), () {
        updateValue(i);
      });
    }
  }
}

class AnimatedGauge extends StatelessWidget {
  final GaugeController gaugeController = Get.put(GaugeController()); // إنشاء الـ Controller باستخدام GetX

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عداد انميشين دائري'),
      ),
      body: Center(
        child: Obx(() {
          // استخدام Obx لمراقبة التغييرات في القيمة
          return CustomPaint(
            size: Size(300, 300), // تحديد حجم العداد
            painter: GaugePainter(
              currentValue: gaugeController.currentValue.value, // إرسال القيمة المتغيرة
              minValue: gaugeController.minValue,
              maxValue: gaugeController.maxValue,
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          gaugeController.startAnimation(); // بدء الأنيميشن عند الضغط على الزر
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double currentValue;
  final double minValue;
  final double maxValue;

  GaugePainter({required this.currentValue, required this.minValue, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // رسم دائرة خلفية للعداد
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    // رسم المؤشر
    paint.color = Colors.blue;
    paint.strokeWidth = 8;

    // زاوية المؤشر بناءً على القيمة
    double angle = (currentValue - minValue) / (maxValue - minValue) * 2 * pi;

    // رسم المؤشر بناءً على الزاوية المحسوبة
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2),
      Offset(size.width / 2 + cos(angle - pi / 2) * (size.width / 2), 
             size.height / 2 + sin(angle - pi / 2) * (size.width / 2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
