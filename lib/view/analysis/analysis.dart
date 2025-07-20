import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/controller/analysis/analysis.dart';
import 'package:power_saving/main.dart';
import 'dart:convert';

import 'package:power_saving/model/analysis.dart';

class AnalysisView extends StatelessWidget {
  // Safe way to get arguments that handles null case
  final int? station = Get.arguments != null ? Get.arguments['station'] : null;
  final int? tech = Get.arguments != null ? Get.arguments['tech'] : null;

  final Analysis controller = Get.put(Analysis());

  @override
  Widget build(BuildContext context) {
    // Check if arguments are null (page reload) and navigate to home
    if (station == null || tech == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
      // Return a loading screen while navigating
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('جاري إعادة التوجيه...'),
            ],
          ),
        ),
      );
    }

    // Fetch analysis data when widget builds (only if we have valid arguments)
    controller.getAnalysis(station: station!, tech: tech!);

    return WillPopScope(
      onWillPop: () async {
        // Navigate to home instead of going back
        Get.offAllNamed('/home'); // or Get.offAllNamed('/') depending on your home route
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'تحليل البيانات والرسوم البيانية',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF1E40AF),
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white), // Changed to home icon
                  onPressed: () {
                    Get.offAllNamed('/home'); // Navigate to home instead of back
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          body: GetBuilder<Analysis>(
            builder: (controller) {
              if (controller.anl == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E40AF)),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'جاري تحميل البيانات...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Check if we have images
              List<String> images = _extractImages(controller.anl!);
              
              if (images.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.analytics,
                          size: 48,
                          color: Colors.orange.shade300,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'لا توجد بيانات تحليلية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'لم يتم العثور على رسوم بيانية لهذا التحليل',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => Get.offAllNamed('/home'),
                        icon: const Icon(Icons.home),
                        label: const Text('العودة للرئيسية'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E40AF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Analysis Charts Grid
                    _buildChartsGrid(images),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to check if this is a reload and navigate to home
  void _checkForReloadAndNavigate() {
    // This method is no longer needed since we handle it in build method
    // But keeping it for reference if needed later
  }

  // Extract base64 images from the analysis model
  List<String> _extractImages(AnalysisModel analysisModel) {
    List<String> images = [];
    
    // Extract images based on your actual model structure
    try {
      if (analysisModel.clorhine.isNotEmpty) images.add(analysisModel.clorhine);
      if (analysisModel.soild.isNotEmpty) images.add(analysisModel.soild);
      if (analysisModel.liquid.isNotEmpty) images.add(analysisModel.liquid);
      if (analysisModel.power.isNotEmpty) images.add(analysisModel.power);
    } catch (e) {
      // Handle any parsing errors
      print('Error extracting images: $e');
      // On error, also navigate to home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
    }
    
    return images;
  }

  Widget _buildChartsGrid(List<String> images) {
    return Wrap(
      spacing: 8, // horizontal spacing between items
      runSpacing: 8, // vertical spacing between lines
      alignment: WrapAlignment.center,
      children: List.generate(images.length, (index) {
        return Container(
          width: (width - 30) / 2, // Responsive width for 2 columns
          height: 450, // Fixed height for consistent cards
          child: _buildChartCard(images[index], index + 1, _getChartTitle(index)),
        );
      }),
    );
  }

  // Helper method to get proper chart titles
  String _getChartTitle(int index) {
    switch (index) {
      case 0:
        return 'الكلور';
      case 1:
        return 'الشبة الصلبة';
      case 2:
        return 'الشبة السائلة';
      case 3:
        return 'الطاقة';
      default:
        return 'الرسم البياني ${index + 1}';
    }
  }

  Widget _buildChartCard(String base64Image, int chartNumber, String chartTitle) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(base64Image, chartTitle),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.show_chart,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      chartTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chart Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 350, // Fixed height for image area
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    base64Decode(base64Image),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.grey.shade400,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'خطأ في تحميل الصورة',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String base64Image, String chartTitle) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            // Background
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Image Container
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: width * 0.95,
                  maxHeight: height * 0.85,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.show_chart,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$chartTitle ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Image
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Image.memory(
                            base64Decode(base64Image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}