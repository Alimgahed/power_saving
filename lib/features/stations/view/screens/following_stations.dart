import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/widgets/app_scaffold.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';
import 'package:power_saving/features/stations/controller/following_stations_controller.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';

class FollowingStationsScreen extends StatelessWidget {
  const FollowingStationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'متابعة المحطات',
      showDrawer: false,
      desktopHeader: const SizedBox.shrink(),
      mobileAppBar:
          const CustomAppBar(title: 'متابعة المحطات', backRoute: '/home'),
      body: GetBuilder<FollowingStationsController>(
        init: FollowingStationsController(),
        builder: (controller) {
          return Column(
            children: [
              // ─── Compact Header Bar ───
              _buildHeader(),

              // ─── Main Content (no scroll needed) ───
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ─── Selection Card ───
                          _buildSelectionCard(controller),

                          const SizedBox(height: 20),

                          // ─── Station Info + Action ───
                          if (controller.selectedStation != null)
                            _buildStationInfoCard(controller),

                          if (controller.selectedStation != null &&
                              controller.selectedStation!.techs.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: _buildWarningBanner(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Header
  // ═══════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: const BoxDecoration(gradient: AppGradients.header),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.ev_station, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'متابعة المحطات',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'اختر المحطة والتكنولوجيا لعرض التحليل التفصيلي',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.offNamed('/home'),
            icon: const Icon(Icons.arrow_circle_left_outlined,
                color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Selection Card — dropdowns side by side on web
  // ═══════════════════════════════════════════════════════
  Widget _buildSelectionCard(FollowingStationsController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Icon(Icons.tune, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'اختيار المحطة والتكنولوجيا',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dropdowns row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station dropdown
              Expanded(
                flex: 3,
                child: _buildStationDropdown(controller),
              ),
              const SizedBox(width: 16),

              // Tech dropdown
              Expanded(
                flex: 3,
                child: _buildTechDropdown(controller),
              ),
              const SizedBox(width: 16),

              // Action button
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: (controller.selectedStation != null &&
                          controller.selectedTech != null)
                      ? () {
                          Get.toNamed(
                            '/analysis',
                            arguments: {
                              'station': controller.selectedStation?.stationId,
                              'tech': controller.selectedTech?.technologyId,
                            },
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textMuted,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.analytics_outlined, size: 20),
                  label: const Text(
                    'عرض التحليل',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Station Dropdown
  // ═══════════════════════════════════════════════════════
  Widget _buildStationDropdown(FollowingStationsController controller) {
    return DropdownSearch<Station>(
      compareFn: (a, b) => a.stationId == b.stationId,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: const BoxConstraints(maxHeight: 350),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'ابحث عن المحطة...',
            prefixIcon:
                const Icon(Icons.search, color: AppColors.textMuted, size: 20),
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(12),
          elevation: 8,
        ),
      ),
      items: (filter, loadProps) => controller.stations.toList(),
      itemAsString: (Station u) => u.stationName,
      selectedItem: controller.selectedStation,
      onChanged: controller.onStationChanged,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: 'اختر المحطة',
          labelText: 'المحطة',
          prefixIcon: const Icon(Icons.location_city,
              color: AppColors.primary, size: 20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Tech Dropdown
  // ═══════════════════════════════════════════════════════
  Widget _buildTechDropdown(FollowingStationsController controller) {
    final hasTechs = controller.selectedStation != null &&
        controller.selectedStation!.techs.isNotEmpty;

    if (!hasTechs) {
      return IgnorePointer(
        child: Opacity(
          opacity: 0.5,
          child: DropdownSearch<TechnologyModel>(
            compareFn: (a, b) => a.technologyId == b.technologyId,
            enabled: false,
            items: (filter, loadProps) => <TechnologyModel>[],
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'اختر المحطة أولاً',
                labelText: 'التكنولوجيا',
                prefixIcon: const Icon(Icons.memory,
                    color: AppColors.textMuted, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: AppColors.cardBackgroundMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DropdownSearch<TechnologyModel>(
      compareFn: (a, b) => a.technologyId == b.technologyId,
      popupProps: PopupProps.menu(
        showSearchBox: false,
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(12),
          elevation: 8,
        ),
      ),
      items: (filter, loadProps) => controller.selectedStation!.techs,
      itemAsString: (TechnologyModel u) => u.technologyName,
      selectedItem: controller.selectedTech,
      onChanged: controller.onTechChanged,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: 'اختر نوع التكنولوجيا',
          labelText: 'التكنولوجيا',
          prefixIcon: const Icon(Icons.memory,
              color: AppColors.primary, size: 20),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Station Info Card
  // ═══════════════════════════════════════════════════════
  Widget _buildStationInfoCard(FollowingStationsController controller) {
    final station = controller.selectedStation!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'بيانات المحطة المختارة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoChip(Icons.location_city, 'المحطة', station.stationName,
                  AppColors.primary),
              const SizedBox(width: 12),
              _infoChip(Icons.business, 'الفرع', station.branchName,
                  AppColors.teal),
              const SizedBox(width: 12),
              _infoChip(Icons.water_drop, 'مصدر المياه',
                  station.waterSourceName, AppColors.info),
              const SizedBox(width: 12),
              _infoChip(Icons.category, 'النوع', station.stationType,
                  AppColors.purple),
              const SizedBox(width: 12),
              _infoChip(
                  Icons.speed,
                  'السعة',
                  '${station.stationWaterCapacity} م³',
                  AppColors.warning),
              const SizedBox(width: 12),
              _infoChip(Icons.memory, 'التكنولوجيا',
                  '${station.techs.length}', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(
      IconData icon, String label, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // Warning Banner
  // ═══════════════════════════════════════════════════════
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: AppColors.warningDark, size: 22),
          const SizedBox(width: 12),
          Text(
            'لا يوجد تكنولوجيا مسجلة لهذه المحطة.',
            style: TextStyle(
              color: AppColors.warningDark,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
