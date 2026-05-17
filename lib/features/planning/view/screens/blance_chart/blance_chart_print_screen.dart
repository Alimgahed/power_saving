import 'package:power_saving/global/html_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/helpers/extensions.dart';
import 'package:power_saving/features/planning/controller/blance_chart/blance_chart.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/area_station.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/chart_sctions.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/places_table.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/report_header.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/station_table.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/summery.dart';
import 'package:power_saving/features/planning/view/widgets/balance_widgets/water_table.dart';

/// Professional Print Screen - Renders complete content for printing
class BalanceChartPrintScreen extends StatefulWidget {
  const BalanceChartPrintScreen({super.key});

  @override
  State<BalanceChartPrintScreen> createState() => _BalanceChartPrintScreenState();
}

class _BalanceChartPrintScreenState extends State<BalanceChartPrintScreen> {
  bool _isPrinting = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BalanceChartController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF1E40AF),
      elevation: 0,
      title: const Text(
        'نتائج منحنى الاتزان',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Row(
          children: [
              ElevatedButton.icon(
        onPressed: _isPrinting ? null : () => _handlePrint(controller),
        icon: _isPrinting 
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Icon(Icons.print_outlined, size: AppDimensions.iconS),
        label: Text(_isPrinting ? 'جاري التحضير...' : 'طباعة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textWhite,
          foregroundColor: AppColors.primary,
          elevation: AppDimensions.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
      SizedBox(width: AppDimensions.paddingS),
            Container(
                margin: const EdgeInsets.only(left: AppDimensions.paddingL),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: AppColors.textWhite),
                  onPressed: () {
                    Get.offNamed('/BlanceCart');
                    
                  
                  
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.overlayBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                  ),
                ),
              ),
      
          ],
        ),
        const SizedBox(width: 8),
      ],
    ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Obx(() {
              if (controller.balanceData.value == null) {
                return const Center(child: Text('لا توجد بيانات للطباعة'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildPrintContent(controller),
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Build the complete print content
  Widget _buildPrintContent(BalanceChartController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const ReportHeader(),
          const Divider(height: 1, thickness: 2),
          if (controller.balanceData.value?.areaData != null)
            AreaSection(controller: controller),
          ChartSection(controller: controller),
          SummarySection(controller: controller),
          WaterDataTable(controller: controller),
          if (controller.balanceData.value?.areaData != null) ...[
            StationsTable(controller: controller),
            PlacesTable(controller: controller),
          ],
        ],
      ),
    );
  }

 

 
  void _handlePrint(BalanceChartController controller) {
    setState(() => _isPrinting = true);

    // Generate the printable HTML content for the screen
    final printContent = generateEnhancedPrintHtml(controller);
    openHtmlReport(printContent);

    setState(() => _isPrinting = false);
  }
  

String generateEnhancedPrintHtml(BalanceChartController controller) {
    final formattedDate = getCurrentDate();
    final reportTitle = 'تقرير منحنى الاتزان المائي';
    final areaData = controller.balanceData.value?.areaData;
    final chartBase64 = controller.balanceData.value?.chart ?? '';
    final balanceData = controller.balanceData.value?.balncedata ?? [];

    String areaInfoSection = _generateAreaInfoSection(areaData);
    String summarySection = _generateSummarySection(balanceData);
    String chartSection = _generateChartSection(chartBase64);
    String waterDataTable = _generateWaterDataTable(balanceData);
    String stationsTable = _generateStationsTable(areaData?.stations);
    String placesTable = _generatePlacesTable(areaData?.places);

    return '''
  <!DOCTYPE html>
  <html dir="rtl">
  <head>
    <meta charset="UTF-8">
    <title>$reportTitle</title>
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { 
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        direction: rtl; 
        background: white; 
        color: #1f2937; 
        line-height: 1.6;
      }
      .print-container { 
        max-width: 1200px; 
        margin: 0 auto; 
        padding: 20px; 
      }
      
      /* Header Styles */
      .header { 
        text-align: center; 
        margin-bottom: 30px; 
        padding: 32px; 
        background: linear-gradient(135deg, #1E40AF, #3B82F6); 
        color: white; 
        border-radius: 12px;
        box-shadow: 0 8px 25px rgba(30, 64, 175, 0.3);
      }
      .header .icon { 
        font-size: 48px; 
        margin-bottom: 12px; 
        display: block; 
      }
      .header h1 { 
        font-size: 28px; 
        margin-bottom: 8px; 
        font-weight: bold; 
      }
      .header p { 
        font-size: 14px; 
        opacity: 0.9; 
      }
      
      /* Area Information Section */
      .area-section { 
        background: #EBF8FF; 
        padding: 24px; 
        margin-bottom: 24px; 
        border-radius: 12px; 
        border-left: 4px solid #3B82F6;
      }
      .area-section h3 { 
        color: #1E40AF; 
        font-size: 20px; 
        margin-bottom: 16px; 
        display: flex; 
        align-items: center; 
      }
      .area-section .icon { 
        margin-left: 8px; 
        font-size: 24px; 
      }
      .area-info { 
        display: grid; 
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
        gap: 16px; 
      }
      .area-info-item { 
        background: white; 
        padding: 12px; 
        border-radius: 8px; 
        box-shadow: 0 2px 4px rgba(0,0,0,0.1); 
      }
      .area-info-item .label { 
        color: #6B7280; 
        font-size: 14px; 
        font-weight: 500; 
      }
      .area-info-item .value { 
        color: #111827; 
        font-size: 16px; 
        font-weight: bold; 
        margin-top: 4px; 
      }
      
      /* Summary Section */
      .summary-section { 
        background: #F9FAFB; 
        padding: 24px; 
        margin-bottom: 24px; 
        border-radius: 12px; 
        border: 1px solid #E5E7EB;
      }
      .summary-section h3 { 
        font-size: 20px; 
        margin-bottom: 16px; 
        color: #111827; 
      }
      .summary-cards { 
        display: grid; 
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
        gap: 16px; 
      }
      .summary-card { 
        background: white; 
        padding: 16px; 
        border-radius: 8px; 
        border: 2px solid; 
        text-align: center; 
      }
      .summary-card.blue { border-color: #DBEAFE; }
      .summary-card.green { border-color: #D1FAE5; }
      .summary-card.orange { border-color: #FED7AA; }
      .summary-card.purple { border-color: #E9D5FF; }
      .summary-card .title { 
        font-size: 12px; 
        color: #6B7280; 
        margin-bottom: 8px; 
      }
      .summary-card .value { 
        font-size: 18px; 
        font-weight: bold; 
      }
      .summary-card.blue .value { color: #2563EB; }
      .summary-card.green .value { color: #059669; }
      .summary-card.orange .value { color: #D97706; }
      .summary-card.purple .value { color: #7C3AED; }
      
      /* Chart Section */
      .chart-section { 
        background: white; 
        padding: 24px; 
        margin-bottom: 24px; 
        border-radius: 12px; 
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
      }
      .chart-section h3 { 
        color: #1E40AF; 
        font-size: 20px; 
        margin-bottom: 16px; 
        display: flex; 
        align-items: center; 
      }
      .chart-container { 
        text-align: center; 
        padding: 16px; 
      }
      .chart-container img { 
        max-width: 100%; 
        height: auto; 
        border-radius: 8px; 
        box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
      }
      .no-chart { 
        height: 300px; 
        background: #F3F4F6; 
        border-radius: 8px; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        color: #6B7280; 
        font-size: 16px; 
      }
      
      /* Table Styles */
      .table-section { 
        background: white; 
        border-radius: 12px; 
        overflow: hidden; 
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); 
        margin-bottom: 24px; 
      }
      .table-header { 
        padding: 20px 24px 16px; 
        background: #F8FAFC; 
        border-bottom: 2px solid #E2E8F0; 
      }
      .table-header h3 { 
        color: #1E40AF; 
        font-size: 20px; 
        display: flex; 
        align-items: center; 
      }
      .table-header .icon { 
        margin-left: 8px; 
        font-size: 24px; 
      }
      .table-container { 
        overflow-x: auto; 
      }
      table { 
        width: 100%; 
        border-collapse: collapse; 
      }
      th { 
        background: #1E40AF; 
        color: white; 
        padding: 12px 8px; 
        text-align: center; 
        font-weight: bold; 
        font-size: 10px; 
        border-right: 1px solid rgba(255,255,255,0.2); 
        white-space: nowrap; 
      }
      th:last-child { border-right: none; }
      td { 
        padding: 10px 8px; 
        border-bottom: 1px solid #F1F5F9; 
        text-align: center; 
        font-size: 9px; 
        border-right: 1px solid #F1F5F9; 
      }
      td:last-child { border-right: none; }
      tr:nth-child(even) { background: #F8FAFC; }
      tr:hover { background: #EBF8FF; }
      
      /* Stations Table */
      .stations-table th { background: #EA580C; }
      .stations-table .table-header h3 { color: #EA580C; }
      
      /* Places Table */
      .places-table th { background: #059669; }
      .places-table .table-header h3 { color: #059669; }
      
      /* Footer */
      .footer { 
        margin-top: 40px; 
        text-align: center; 
        padding: 24px; 
        background: #F3F4F6; 
        border-radius: 12px; 
        border-top: 4px solid #E5E7EB; 
      }
      .footer hr { 
        border: none; 
        height: 1px; 
        background: #D1D5DB; 
        margin-bottom: 16px; 
      }
      .footer p { 
        color: #6B7280; 
        font-size: 12px; 
        margin-bottom: 4px; 
      }
      .footer .time { 
        color: #9CA3AF; 
        font-size: 11px; 
      }
      
      /* Print Styles */
      @media print { 
        body { background: white !important; } 
        .no-print { display: none !important; } 
        .print-container { padding: 10px; }
        .table-section { break-inside: avoid; }
        .chart-section { break-inside: avoid; }
        .summary-section { break-inside: avoid; }
      }
      
      /* Icons */
      .icon { display: inline-block; }
      .icon::before {
        content: attr(data-icon);
        font-family: 'Arial Unicode MS', sans-serif;
      }
    </style>
  </head>
  <body>
    <div class="print-container">
      <!-- Header -->
      <div class="header">
        <span class="icon">💧</span>
        <h1>$reportTitle</h1>
        <p>تاريخ الطباعة: $formattedDate</p>
      </div>

      $areaInfoSection
      $summarySection
      $chartSection
      $waterDataTable
      $stationsTable
      $placesTable

     
    </div>
  </body>
  </html>
  ''';
  }

  String _generateAreaInfoSection(dynamic areaData) {
    if (areaData == null) return '';
    
    return '''
      <div class="area-section">
        <h3><span class="icon">📍</span>معلومات المنطقة</h3>
        <div class="area-info">
          <div class="area-info-item">
            <div class="label">اسم المنطقة</div>
            <div class="value">${areaData.areaName}</div>
          </div>
          <div class="area-info-item">
            <div class="label">عدد الأماكن</div>
            <div class="value">${areaData.places.length} موقع</div>
          </div>
          <div class="area-info-item">
            <div class="label">عدد المحطات</div>
            <div class="value">${areaData.stations?.length ?? 0} محطة</div>
          </div>
        </div>
      </div>
    ''';
  }

  String _generateSummarySection(List<dynamic> data) {
    if (data.isEmpty) return '';
    
    final firstYear = data.first;
    final lastYear = data.last;
    
    return '''
      <div class="summary-section">
        <h3>الملخص الإحصائي</h3>
        <div class="summary-cards">
          <div class="summary-card blue">
            <div class="title">إجمالي السكان (بداية)</div>
            <div class="value">${formatNumber(firstYear.population.toDouble())}</div>
          </div>
          <div class="summary-card green">
            <div class="title">إجمالي السكان (نهاية)</div>
            <div class="value">${formatNumber(lastYear.population.toDouble())}</div>
          </div>
          <div class="summary-card orange">
            <div class="title">الإنتاج الحالي</div>
            <div class="value">${formatNumber(lastYear.currentProduction.toDouble())} م³/يوم</div>
          </div>
          <div class="summary-card purple">
            <div class="title">السعة القصوى</div>
            <div class="value">${formatNumber(lastYear.maxProduction.toDouble())} م³/يوم</div>
          </div>
        </div>
      </div>
    ''';
  }

  String _generateChartSection(String chartBase64) {
    return '''
      <div class="chart-section">
        <h3><span class="icon">📊</span>منحنى الاتزان المائي</h3>
        <div class="chart-container">
          ${chartBase64.isNotEmpty 
            ? '<img src="data:image/png;base64,$chartBase64" alt="منحنى الاتزان المائي" />'
            : '<div class="no-chart">لا يوجد رسم بياني</div>'
          }
        </div>
      </div>
    ''';
  }

  String _generateWaterDataTable(List<dynamic> data) {
    if (data.isEmpty) return '';
    
    String rows = data.map((row) => '''
      <tr>
        <td>${row.year}</td>
        <td>${formatNumber(row.population.toDouble())}</td>
        <td>${formatNumber(row.waterNeed.toDouble())}</td>
        <td>${formatNumber(row.qDemandedMonthlyAvg.toDouble())}</td>
        <td>${formatNumber(row.qDemandedDailyAvg.toDouble())}</td>
        <td>${formatNumber(row.qDemandedHourly.toDouble())}</td>
        <td>${formatNumber(row.qFire.toDouble())}</td>
        <td>${formatNumber(row.currentProduction.toDouble())}</td>
        <td>${formatNumber(row.maxProduction.toDouble())}</td>
      </tr>
    ''').join('');

    return '''
      <div class="table-section">
        <div class="table-header">
          <h3><span class="icon">📋</span>جدول البيانات المائية التفصيلي</h3>
        </div>
        <div class="table-container">
          <table>
            <thead>
              <tr>
          <th>Year</th>
          <th>Population</th>
          <th>Water Demand<br>(m³/day)</th>
          <th>Monthly Average<br>(m³/day)</th>
          <th>Daily Average<br>(m³/day)</th>
          <th>Hourly<br>(m³/h)</th>
          <th>Fire Water<br>(L/s)</th>
          <th>Current Production<br>(m³/day)</th>
          <th>Max Capacity<br>(m³/day)</th>
              </tr>
            </thead>
            <tbody>
              $rows
            </tbody>
          </table>
        </div>
      </div>
    ''';
  }

  String _generateStationsTable(List<dynamic>? stations) {
    if (stations == null || stations.isEmpty) return '';
    
    String rows = stations.map((station) => '''
      <tr>
        <td>${station.stationName}</td>
        <td>${station.stationType}</td>
        <td>${formatNumber((station.stationWaterCapacity ?? 0).toDouble())}</td>
      </tr>
    ''').join('');

    return '''
      <div class="table-section stations-table">
        <div class="table-header">
          <h3><span class="icon">🏭</span>محطات المياه (${stations.length} محطة)</h3>
        </div>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>اسم المحطة</th>
                <th>النوع</th>
                <th>السعة (م³/يوم)</th>
              </tr>
            </thead>
            <tbody>
              $rows
            </tbody>
          </table>
        </div>
      </div>
    ''';
  }

  String _generatePlacesTable(List<dynamic>? places) {
    if (places == null || places.isEmpty) return '';
    
    String rows = places.map((place) {
     
      
      return '''
        <tr>
          <td>${place.areaName}</td>
          <td>${place.branchName}</td>
          <td>${place.placeName}</td>
          <td>${place.placeTypeName}</td>
     
        </tr>
      ''';
    }).join('');

    return '''
      <div class="table-section places-table">
        <div class="table-header">
          <h3><span class="icon">🏘️</span>الأماكن </h3>
        </div>
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>المنطقة</th>
                <th>الفرع</th>
                <th>المكان</th>
                <th>نوع المكان</th>
               
              </tr>
            </thead>
            <tbody>
              $rows
            </tbody>
          </table>
        </div>
      </div>
    ''';
  }
  // Generate printable HTML for the entire screen content


 
}