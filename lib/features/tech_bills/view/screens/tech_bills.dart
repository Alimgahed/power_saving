import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import 'package:power_saving/features/tech_bills/controller/techbills.dart';
import 'package:power_saving/my_widget/sharable.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
class TechBills extends StatelessWidget {
  const TechBills({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Techbills());

    return AppScaffold(
      title: 'قائمة فواتير التقنيات',
      mobileAppBar: _buildAppBar(controller),
      desktopHeader: _buildAppBar(controller),
      body: Obx(() => _buildBody(controller)),
    );
  }

  PreferredSizeWidget _buildAppBar(Techbills controller) {
    return AppBar(
      title: Obx(() => controller.isSearching.value
          ? TextField(
              controller: controller.searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'ابحث في الفواتير...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                controller.onSearchChanged(value);
              },
            )
          : const Text(
              'قائمة فواتير التقنيات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )),
      backgroundColor: const Color(0xFF1E40AF),
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Obx(() => Row(
                children: [
                  if (!controller.isSearching.value) ...[
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: controller.toggleSearch,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: controller.toggleSearch,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () => Get.offNamed('/home'),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildBody(Techbills controller) {
    if (controller.loading.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.techBills.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      slivers: [
        // Search Error Message (if any)
        if (controller.searchError.value.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildSearchError(controller),
          ),

        // Filters Section
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: _buildFiltersSection(controller),
          ),
        ),

        // Header with count
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: _buildHeader(controller),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // Tech Bills Grid
        if (controller.filteredTechBills.isEmpty)
          SliverToBoxAdapter(
            child: _buildNoResultsState(controller),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.55,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final techBill = controller.filteredTechBills[index];
                  final originalIndex = controller.techBills.indexOf(techBill);
                  return _TechBillCard(
                    techBill: techBill,
                    originalIndex: originalIndex,
                    controller: controller,
                  );
                },
                childCount: controller.filteredTechBills.length,
              ),
            ),
          ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  Widget _buildSearchError(Techbills controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange.shade700,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.searchError.value,
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.engineering,
              size: 48,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد فواتير تقنيات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ابدأ بإضافة فاتورة تقنية جديدة',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(Techbills controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.searchController.text.isNotEmpty)
              Text(
                'لم يتم العثور على "${controller.searchController.text}"',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'لا توجد نتائج تطابق الفلتر',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(Techbills controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                'تصفية',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Obx(() {
                if (controller.selectedBranch.value != null ||
                    controller.selectedStation.value != null) {
                  return TextButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('مسح الفلاتر'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Branch Filter
              Expanded(
                child: Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedBranch.value,
                      decoration: InputDecoration(
                        labelText: 'الفرع',
                        prefixIcon: Icon(
                          Icons.business,
                          size: 20,
                          color: Colors.blue.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('كل الفروع'),
                        ),
                        ...controller.branches.map((branch) {
                          return DropdownMenuItem(
                            value: branch,
                            child: Text(branch),
                          );
                        }).toList(),
                      ],
                      onChanged: controller.filterByBranch,
                    )),
              ),
              const SizedBox(width: 12),
              // Station Filter
              Expanded(
                child: SearchableDropdown(
                  tag: 'station_dropdown',
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('كل المحطات'),
                    ),
                    ...controller.stations.map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    controller.filterByStation(value);
                  },
                  validator: null,
                  labelText: "المحطة".tr,
                  hintText: 'اختر المحطة'.tr,
                  prefixIcon: Icons.map,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Techbills controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.engineering,
              color: Colors.blue.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.searchController.text.isNotEmpty ||
                          controller.selectedBranch.value != null ||
                          controller.selectedStation.value != null
                      ? 'نتائج التصفية'
                      : 'إجمالي فواتير التقنيات',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.filteredTechBills.length} فاتورة',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Separate widget for tech bill card
class _TechBillCard extends StatelessWidget {
  final dynamic techBill;
  final int originalIndex;
  final Techbills controller;

  const _TechBillCard({
    required this.techBill,
    required this.originalIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            techBill.stationName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            techBill.technologyName,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          if (techBill.branch != null) ...[
            const SizedBox(height: 4),
            Text(
              techBill.branch!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'السنة: ${techBill.billYear} - الشهر: ${techBill.billMonth}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: _buildChemicalRangesSection(),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Obx(() {
        if (controller.loadingIndex.value == originalIndex) {
          return const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (controller.getFormKey(originalIndex).currentState!
                  .validate()) {
                controller.addTechBills(
                  calculatedWater: double.tryParse(
                        controller.getcalculatedWaterControllers(originalIndex).text) ??
                      0,
                      measuredWater: double.tryParse(
                        controller.getmeasuredWaterControllers(originalIndex).text) ??
                      0,
                  index: originalIndex,
                  id: techBill.techBillId,
                  chlorine: double.tryParse(
                        controller.getChlorineController(originalIndex).text,
                      ) ??
                      0,
                  liquid: double.tryParse(
                        controller.getLiquidAlumController(originalIndex).text,
                      ) ??
                      0,
                  solid: double.tryParse(
                        controller.getSolidAlumController(originalIndex).text,
                      ) ??
                      0,
                  water: double.tryParse(
                        controller
                            .getWaterProducedController(originalIndex)
                            .text,
                      ) ??
                      0,
                );
              }
            },
            icon: const Icon(Icons.save, size: 16),
            label: const Text(
              'حفظ البيانات',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChemicalRangesSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
      ),
      child: Form(
        key: controller.getFormKey(originalIndex),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 16, color: Colors.indigo),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'المدى الفعلي للمواد',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRangeItem(
              'كمية المياه المقاسة',
              Icons.water,
              controller.getmeasuredWaterControllers(originalIndex),
            ),
            const SizedBox(height: 8),
            _buildRangeItem(
              'كمية المياه المحسوبة',
              Icons.water,
              controller.getcalculatedWaterControllers(originalIndex),
            ),
            _buildRangeItem(
              'كمية المياه المنتجة',
              Icons.water,
              controller.getWaterProducedController(originalIndex),
            ),
            const SizedBox(height: 8),
            _buildRangeItem(
              'الكلور',
              Icons.science,
              controller.getChlorineController(originalIndex),
            ),
            const SizedBox(height: 8),
            _buildRangeItem(
              'الشبة السائلة',
              Icons.opacity,
              controller.getLiquidAlumController(originalIndex),
            ),
            const SizedBox(height: 8),
            _buildRangeItem(
              'الشبة الصلبة',
              Icons.ac_unit,
              controller.getSolidAlumController(originalIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeItem(
    String label,
    IconData icon,
    TextEditingController textController,
  ) {
    return CustomTextFormField(
      padding: 4,
      allowOnlyDigits: true,
      controller: textController,
      label: label,
      icon: icon,
    );
  }
}