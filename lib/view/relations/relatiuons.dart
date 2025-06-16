import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/relations/relation.dart';
import 'package:power_saving/my_widget/sharable.dart';

class RelatiuonsSCREAN extends StatelessWidget {
  const RelatiuonsSCREAN({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Relation());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة الربط'),
          backgroundColor: Colors.white,

          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.offNamed('/Addrelation');
                  },
                  child: Text(
                    "اضاقة ربط جديد",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                  onPressed: () {
                    Get.offNamed('/home');
                  },
                ),
              ],
            ),
          ],
          automaticallyImplyLeading: false, // This is true by default
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<Relation>(
            builder: (controller) {
              return GridView.builder(
                itemCount: controller.allrelations.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, // show exactly 3 per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final Relation = controller.allrelations[index];
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Relation.stationName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Reusable key-value row
                            infoRowWidget(
                              'نوع التقنية :',
                              Relation.technologyName!,
                            ),
                            SizedBox(height: 10),
                            infoRowWidget(
                              'رقم الاشتراك:',
                              "${Relation.accountNumber}",
                            ),
                            SizedBox(height: 10),
                            infoRowWidget(
                              'الحالة',
                              Relation.relationStatus == true
                                  ? "نشط"
                                  : "غير نشط",
                            ),
                            Relation.relationStatus == true
                                ? Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () async {
                                      await controller.editRelation(
                                        Relation.stationGaugeTechnologyId!,
                                        "تم إلغاء الربط بنجاح",
                                      );
                                    },
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                                )
                                : Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () async {
                                      await controller.editRelation(
                                        Relation.stationGaugeTechnologyId!,
                                        "تم تفعيل الربط بنجاح",
                                      );
                                    },
                                    icon: Icon(Icons.done, color: Colors.green),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
