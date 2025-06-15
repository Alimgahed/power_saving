import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/technology/technlogy.dart';



class Technology extends StatelessWidget {
  Technology({super.key});

 
  @override
  Widget build(BuildContext context) {
    Get.put(TechnlogyController());
    return Scaffold(
      appBar: AppBar(
    
        title: const Text('قائمة تقنيات الترشيح'),
        backgroundColor: Colors.white,
        
        actions: [
          Row(
            children: [
              TextButton(onPressed: (){
              Get.offNamed('/addTech');
                        }, child: Text("اضاقة تقنية جديدة",style:TextStyle(fontSize: 16,color: Colors.blue) ,)),
                         IconButton(
        icon: const Icon(Icons.arrow_forward, color: Colors.blue),
        onPressed: () {
          
            Get.offNamed('/home');
          
        },
      ),
            ],
          )],
          automaticallyImplyLeading: false, // This is true by default
    
      ),
      body:GetBuilder<TechnlogyController>(
        init:TechnlogyController() ,        builder: (controller) {
          return   GridView.builder(
              itemCount:controller.all_technology.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent:300, // show exactly 3 per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.73, // Wider card (adjust for shape)
              ),
              itemBuilder: (context, index) {
                final tech =controller.all_technology[index];
                return Padding(
              padding: const EdgeInsets.all(12),
              child:Container(
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
    border: Border.all(color: Colors.blue.shade100, width: 1),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tech.technologyName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
         Text(
          "الارقام المرجعية بالنسبة لكمية المياه",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Reusable key-value row
        _buildInfoRow('كهرباء',"${tech.powerPerWater}"),


      

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
  Get.offNamed('/Edittech', arguments:{"Tech":tech} );

           },
            icon: Icon(Icons.edit, color: Colors.blue),
          ),
        ),
      ],
    ),
  ),
)

            );
            
              },
            );
        },
      )
    );
  }
}
Widget _buildInfoRow(String key, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          key,
          style: const TextStyle(color: Colors.black54),
        ),
        Spacer(),
        Text(
          value,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    ),
  );
}
