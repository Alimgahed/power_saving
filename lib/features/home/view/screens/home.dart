import 'package:power_saving/features/home/view/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'dart:ui' as ui;

import 'package:power_saving/features/home/controller/home.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'package:power_saving/features/home/view/widgets/consumpation_card.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/features/home/view/widgets/navigation_helper.dart';

// ─── Layout tokens (colors via AppColors / AppGradients) ─────────────────────

class _T {
  static const double radius = 20;
  static const double cardRadius = 16;
  static const double spacing = 24;

  static final BoxShadow shadowSubtle = BoxShadow(
    color: AppColors.primary.withOpacity(0.04),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RxInt activeAlertTab = 0.obs;

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
        backgroundColor: AppColors.background,
        drawer: HomeDrawer(),
        body: Stack(
          children: [
            // Subtle Background Image
            Positioned.fill(
              child: Opacity(
                opacity: 1, // Adjust opacity for a perfect watermark effect
                child: Image.asset(
                  'images/home_bg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
            // Main Content
            SafeArea(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.loading.value) {
        return _buildLoadingSkeleton(context);
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(_T.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(context),
            const SizedBox(height: _T.spacing),
            _buildStatsGrid(context, controller),
            _buildQuickActions(context),
            const SizedBox(height: _T.spacing),
            GetBuilder<HomeController>(
              builder: (ctrl) {
                final data = ctrl.consumptionModel;
                if (data == null) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(_T.radius),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد بيانات متاحة حالياً',
                            style: TextStyle(
                              fontSize: HomeTypography.body,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTop5StationsCard(data),
                    const SizedBox(height: _T.spacing),
                    _buildAlertsCenterCard(ctrl),
                    const SizedBox(height: _T.spacing),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }

  // ─── Loading Skeleton ────────────────────────────────────────────────────

  Widget _buildLoadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(_T.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonContainer(height: 120, width: double.infinity, radius: _T.radius),
          const SizedBox(height: _T.spacing),
          LayoutBuilder(builder: (context, constraints) {
             final width = constraints.maxWidth;
             int cols = 7;
             if (width < 1200) cols = 4;
             if (width < 750) cols = 2;
             if (width < 450) cols = 1;
             final double cardHeight = cols == 1 ? 105 : 155;
             return GridView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: cols,
                 crossAxisSpacing: 16,
                 mainAxisSpacing: 16,
                 childAspectRatio: cols == 1 ? (width / cardHeight) : (width / cols) / cardHeight,
               ),
               itemCount: cols == 1 ? 4 : 7,
               itemBuilder: (_, __) => const _SkeletonContainer(radius: _T.cardRadius),
             );
          }),
          const SizedBox(height: _T.spacing),
          const _SkeletonContainer(height: 380, width: double.infinity, radius: _T.radius),
        ],
      ),
    );
  }

  // ─── Welcome Header ─────────────────────────────────────────────────────

  Widget _buildWelcomeHeader(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'صباح الخير';
    } else if (hour < 17) {
      greeting = 'مساء الخير';
    } else {
      greeting = 'طاب مساؤك';
    }

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.menu, color: AppColors.primary, size: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: 'القائمة الرئيسية',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting، ${user?.username ?? 'المستخدم'} 👋',
                style: TextStyle(
                  fontSize: HomeTypography.greeting,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE، d MMMM yyyy', 'ar').format(DateTime.now()), // Or just DateFormat('yyyy-MM-dd') if ar locale fails, but we'll use yyyy-MM-dd for safety
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Stats Grid ──────────────────────────────────────────────────────────

  Widget _buildStatsGrid(BuildContext context, HomeController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        // Optimized breakpoints for better text visibility
        int cols = 7;
        if (width < 1400) cols = 4;
        if (width < 900) cols = 2;
        if (width < 500) cols = 1;

        final double cardHeight = cols == 1 ? 105 : 155;
        final int rows = (7 / cols).ceil();
        final double totalHeight = (rows * cardHeight) + ((rows - 1) * 16);

        return SizedBox(
          height: totalHeight,
          child: Obx(() {
            final moneyVal = controller.animatedMoney.value ?? 0;
            final waterVal = controller.animatedWater.value ?? 0;
            final saintionVal = controller.saintion.value ?? 0;
            final powerVal = controller.animatedPower.value ?? 0;
            final chlorineVal = controller.animatedChlorine.value ?? 0;
            final liquidAlumVal = controller.animatedLiquidAlum.value ?? 0;
            final solidAlumVal = controller.animatedSolidAlum.value ?? 0;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio:
                  cols == 1
                      ? (width / cardHeight)
                      : (width / cols) / cardHeight,
              children: [
                _HoverStatCard(
                  title: 'إجمالي التكلفة',
                  targetValue: moneyVal,
                  suffix: 'جنيه',
                  icon: Icons.attach_money_rounded,
                  gradient: AppGradients.success,
                  progress: 0.85,
                ),
                _HoverStatCard(
                  title: 'المياه المنتجة',
                  targetValue: waterVal,
                  suffix: 'م³',
                  icon: Icons.water_drop_rounded,
                  gradient: AppGradients.primary,
                  progress: 0.75,
                ),
                _HoverStatCard(
                  title: 'المياه المرفوعة',
                  targetValue: saintionVal,
                  suffix: 'م³',
                  icon: Icons.upload_rounded,
                  gradient: AppGradients.purple,
                  progress: 0.65,
                ),
                _HoverStatCard(
                  title: 'الكهرباء المستهلكة',
                  targetValue: powerVal,
                  suffix: 'واط',
                  icon: Icons.bolt_rounded,
                  gradient: AppGradients.warning,
                  progress: 0.45,
                ),
                _HoverStatCard(
                  title: 'كمية الكلور',
                  targetValue: chlorineVal,
                  suffix: 'كجم',
                  icon: Icons.science_rounded,
                  gradient: AppGradients.info,
                  progress: 0.35,
                ),
                _HoverStatCard(
                  title: 'الشبة السائلة',
                  targetValue: liquidAlumVal,
                  suffix: 'كجم',
                  icon: Icons.opacity_rounded,
                  gradient: AppGradients.orange,
                  progress: 0.55,
                ),
                _HoverStatCard(
                  title: 'الشبة الصلبة',
                  targetValue: solidAlumVal,
                  suffix: 'كجم',
                  icon: Icons.grain_rounded,
                  gradient: AppGradients.purple,
                  progress: 0.25,
                ),
              ],
            );
          }),
        );
      },
    );
  }

  // Chart Card removed

  // ─── Alerts Center ───────────────────────────────────────────────────────

  Widget _buildAlertsCenterCard(HomeController controller) {
    final data = controller.consumptionModel;
    if (data == null) return const SizedBox.shrink();

    final tabs = [
      _TabConfig(
        'تجاوز الكهرباء',
        data.overPowerConsumpCount,
        () => data.overPowerConsump,
        'الكهرباء',
        Icons.bolt_rounded,
        AppColors.warningDark,
        AppGradients.warning,
      ),
      _TabConfig(
        'مياه بدون طاقة',
        data.waterForMissingPowerCount,
        () => data.Waterformissingpower,
        'مياة بدون طاقة',
        Icons.priority_high_rounded,
        AppColors.errorDark,
        AppGradients.danger,
      ),
      _TabConfig(
        'الإنارة الزائدة',
        data.overPowerFor0WaterCount,
        () => data.overpowerfor0water,
        'الإنارة',
        Icons.lightbulb_rounded,
        AppColors.orangeDark,
        AppGradients.orange,
      ),
      _TabConfig(
        'تجاوز الكلور',
        data.overChlorineConsumpCount,
        () => data.overChlorineConsump,
        'الكلور',
        Icons.science_rounded,
        AppColors.infoDark,
        AppGradients.info,
      ),
      _TabConfig(
        'الشبة السائلة',
        data.overLiquidAlumConsumpCount,
        () => data.overLiquidAlumConsump,
        'الشبة السائلة',
        Icons.opacity_rounded,
        AppColors.primary,
        AppGradients.primary,
      ),
      _TabConfig(
        'الشبة الصلبة',
        data.overSolidAlumConsumpCount,
        () => data.overSolidAlumConsump,
        'الشبة الصلبة',
        Icons.grain_rounded,
        AppColors.purpleDark,
        AppGradients.purple,
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: _DashCard(
        headerGradient: AppGradients.danger,
        icon: Icons.warning_amber_rounded,
        title: 'مركز التنبيهات وإدارة التجاوزات',
        subtitle: 'اضغط على أي تصنيف لاستعراض المحطات المتجاوزة للحد الأقصى',
        child: Column(
          children: [
            // Tab Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final bool isScrollable = width < 850;
                final bool showFullTitle = width > 1000;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackgroundMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    onTap: (index) => activeAlertTab.value = index,
                    isScrollable: isScrollable,
                    indicator: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: HomeTypography.tab,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: HomeTypography.tab,
                    ),
                    dividerColor: Colors.transparent,
                    tabs:
                        tabs.map((t) {
                          final int index = tabs.indexOf(t);
                          final displayTitle =
                              showFullTitle ? t.title : t.label;
                          return Tab(
                            child: Obx(() {
                              final bool isSelected =
                                  activeAlertTab.value == index;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      t.icon,
                                      size: 16,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      displayTitle,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.white.withOpacity(0.25)
                                                : t.accentColor.withOpacity(
                                                  0.12,
                                                ),
                                        borderRadius: BorderRadius.circular(6),
                                        border:
                                            isSelected
                                                ? null
                                                : Border.all(
                                                  color: t.accentColor
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                      ),
                                      child: Text(
                                        '${t.count}',
                                        style: TextStyle(
                                          fontSize: HomeTypography.badge,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isSelected
                                                  ? Colors.white
                                                  : t.accentColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          );
                        }).toList(),
                  ),
                );
              },
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 380,
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children:
                      tabs
                          .map(
                            (t) => _buildViolationsGrid(
                              t.lazyList(),
                              t.label,
                              t.icon,
                              t.accentColor,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViolationsGrid(
    List<OverConsump> list,
    String label,
    IconData icon,
    Color color,
  ) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        color: color,
        message: 'لا توجد تجاوزات للحدود',
        description:
            'جميع المحطات تعمل بشكل ممتاز وضمن النطاق المسموح به لهذه المادة.',
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const double cardWidth = 300;
        int columns = (constraints.maxWidth / cardWidth).floor().clamp(1, 10);
        const double spacing = 16.0;
        double availableWidth = constraints.maxWidth;
        // -16 for left/right padding of the list view
        double itemWidth = (availableWidth - (spacing * (columns - 1)) - 16) / columns;

        int rowCount = (list.length / columns).ceil();

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
          itemCount: rowCount,
          itemBuilder: (context, rowIndex) {
            int startIndex = rowIndex * columns;
            
            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(columns, (colIndex) {
                  int itemIndex = startIndex + colIndex;
                  
                  Widget child;
                  if (itemIndex >= list.length) {
                    child = SizedBox(width: itemWidth);
                  } else {
                    child = SizedBox(
                      width: itemWidth,
                      child: ConsumptionCard(
                        item: list[itemIndex],
                        label: label,
                        icon: icon,
                        color: color,
                      ),
                    );
                  }

                  if (colIndex < columns - 1) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [child, SizedBox(width: spacing)],
                    );
                  }
                  return child;
                }),
              ),
            );
          },
        );
      },
    );
  }

  // ─── Quick Actions ───────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    final actions = <Widget>[
      if (_hasAccess([1, 2, 6, 7]))
        _buildActionCard(
          icon: Icons.location_city_rounded,
          label: 'المحطات',
          gradient: AppGradients.primary,
          onTap: () => NavigationHelper().navigateWithAuth('/Stations'),
        ),
      if (_hasAccess([1, 3]))
        _buildActionCard(
          icon: Icons.speed_rounded,
          label: 'العدادات',
          gradient: AppGradients.info,
          onTap: () => NavigationHelper().navigateWithAuth('/Countrts'),
        ),
      if (_hasAccess([1, 3]))
        _buildActionCard(
          icon: Icons.receipt_long_rounded,
          label: 'الفواتير',
          gradient: AppGradients.success,
          onTap: () => NavigationHelper().navigateWithAuth('./bills'),
        ),
      if (_hasAccess([1, 2, 3, 7]))
        _buildActionCard(
          icon: Icons.receipt_rounded,
          label: 'فواتير التقنيات',
          gradient: AppGradients.orange,
          onTap: () => NavigationHelper().navigateWithAuth('./techBill'),
        ),
      if (_hasAccess([1, 2, 4, 3, 6, 7]))
        _buildActionCard(
          icon: Icons.analytics_rounded,
          label: 'التقارير',
          gradient: AppGradients.purple,
          onTap: () => NavigationHelper().navigateWithAuth('./Reports'),
        ),
      if (_hasAccess([1, 2, 3, 7]))
        _buildActionCard(
          icon: Icons.settings_suggest_rounded,
          label: 'التكنولوجيا',
          gradient: AppGradients.warning,
          onTap: () => NavigationHelper().navigateWithAuth('/Technology'),
        ),
      if (_hasAccess([1, 4, 6, 7]))
        _buildActionCard(
          icon: Icons.science_rounded,
          label: 'الكيماويات',
          gradient: AppGradients.teal,
          onTap: () => NavigationHelper().navigateWithAuth('/Chemicals'),
        ),
      if (_hasAccess([1]))
        _buildActionCard(
          icon: Icons.people_alt_rounded,
          label: 'المستخدمين',
          gradient: AppGradients.header,
          onTap: () => NavigationHelper().navigateWithAuth('/all_users'),
        ),
    ];

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'إجراءات سريعة',
                style: TextStyle(
                  fontSize: HomeTypography.consumptionTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int cols = actions.length < 6 ? actions.length : 6;
            if (cols < 1) cols = 1;
            
            double childAspectRatio = 3.5;
            if (width < 1200) {
              cols = actions.length < 5 ? actions.length : 5;
              if (cols < 1) cols = 1;
              childAspectRatio = 3.1;
            }
            if (width < 800) {
              cols = actions.length < 4 ? actions.length : 4;
              if (cols < 1) cols = 1;
              childAspectRatio = 2.7;
            }
            if (width < 500) {
              cols = actions.length < 3 ? actions.length : 3;
              if (cols < 1) cols = 1;
              childAspectRatio = 2.2;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: childAspectRatio,
              children: actions,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    final accentColor = gradient.colors.first;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: accentColor.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor: accentColor.withOpacity(0.12),
          highlightColor: accentColor.withOpacity(0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasAccess(List<int> allowedGroups) {
    if (user == null) return false;
    return allowedGroups.contains(user!.groupId);
  }

  // ─── Top 5 Stations Card ───────────────────────────────────────────────

  Widget _buildTop5StationsCard(ConsumptionModel data) {
    if (data.max5 == null) return const SizedBox.shrink();
    final max5 = data.max5!;

    return _DashCard(
      headerGradient: AppGradients.teal,
      icon: Icons.leaderboard_rounded,
      title: 'أعلى 5 محطات استهلاكاً',
      subtitle: 'ترتيب المحطات حسب أعلى استهلاك للمياه والطاقة والكلور',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTop5Section(
                      title: 'إنتاج المياه',
                      icon: Icons.water_drop_rounded,
                      gradient: AppGradients.info,
                      entries: max5.topWater,
                      unit: 'م³',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTop5Section(
                      title: 'استهلاك الطاقة',
                      icon: Icons.bolt_rounded,
                      gradient: AppGradients.warning,
                      entries: max5.topPower,
                      unit: 'كيلوواط',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTop5Section(
                      title: 'استهلاك الكلور',
                      icon: Icons.science_rounded,
                      gradient: AppGradients.purple,
                      entries: max5.topChlorine,
                      unit: 'كجم',
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _buildTop5Section(
                  title: 'إنتاج المياه',
                  icon: Icons.water_drop_rounded,
                  gradient: AppGradients.info,
                  entries: max5.topWater,
                  unit: 'م³',
                ),
                const SizedBox(height: 20),
                _buildTop5Section(
                  title: 'استهلاك الطاقة',
                  icon: Icons.bolt_rounded,
                  gradient: AppGradients.warning,
                  entries: max5.topPower,
                  unit: 'كيلوواط',
                ),
                const SizedBox(height: 20),
                _buildTop5Section(
                  title: 'استهلاك الكلور',
                  icon: Icons.science_rounded,
                  gradient: AppGradients.purple,
                  entries: max5.topChlorine,
                  unit: 'كجم',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTop5Section({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required List<TopStationEntry> entries,
    required String unit,
  }) {
    final accentColor = gradient.colors.first;
    return Container(
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.08), accentColor.withOpacity(0.02)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: HomeTypography.bodySmall,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Entries list
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'لا توجد بيانات',
                style: TextStyle(
                  fontSize: HomeTypography.caption,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ...entries.asMap().entries.map((mapEntry) {
              final index = mapEntry.key;
              final entry = mapEntry.value;
              final isFirst = index == 0;
              return _buildTop5EntryRow(
                rank: index + 1,
                entry: entry,
                unit: unit,
                accentColor: accentColor,
                gradient: gradient,
                isLeader: isFirst,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTop5EntryRow({
    required int rank,
    required TopStationEntry entry,
    required String unit,
    required Color accentColor,
    required LinearGradient gradient,
    required bool isLeader,
  }) {
    final numberFormat = NumberFormat('#,##0', 'ar');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: accentColor.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Rank badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: isLeader ? gradient : null,
                  color: isLeader ? null : AppColors.cardBackgroundMuted,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isLeader
                      ? [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: HomeTypography.badge,
                      fontWeight: FontWeight.bold,
                      color: isLeader ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Station info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.stationName,
                      style: TextStyle(
                        fontSize: HomeTypography.bodySmall,
                        fontWeight: isLeader ? FontWeight.bold : FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.branchName,
                      style: const TextStyle(
                        fontSize: HomeTypography.caption,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Value and percent
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${numberFormat.format(entry.totalValue)} $unit',
                    style: TextStyle(
                      fontSize: HomeTypography.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${entry.percent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: HomeTypography.badge,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (entry.percent / 100).clamp(0.0, 1.0),
              backgroundColor: accentColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Insights Summary ────────────────────────────────────────────────────

  Widget _buildInsightsSummaryCard(ConsumptionModel data) {
    final int totalAlerts =
        (data.overPowerConsump?.length ?? 0) +
        (data.Waterformissingpower?.length ?? 0) +
        (data.overpowerfor0water?.length ?? 0) +
        (data.overChlorineConsump?.length ?? 0) +
        (data.overLiquidAlumConsump?.length ?? 0) +
        (data.overSolidAlumConsump?.length ?? 0) +
        (data.overWaterStations?.length ?? 0);

    final bool hasAlerts = totalAlerts > 0;

    return _DashCard(
      headerGradient: AppGradients.purple,
      icon: Icons.analytics_rounded,
      title: 'الملخص التحليلي وحالة المرافق',
      subtitle: 'نظرة شاملة وسريعة على مؤشرات الأداء الحالية',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Alert banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppGradients.surfaceBanner(isAlert: hasAlerts),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasAlerts
                      ? AppColors.error.withOpacity(0.45)
                      : AppColors.success.withOpacity(0.55),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: hasAlerts ? AppGradients.danger : AppGradients.success,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasAlerts
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasAlerts
                              ? 'يوجد تجاوزات تحتاج مراجعة'
                              : 'حالة ممتازة',
                          style: TextStyle(
                            fontSize: HomeTypography.bodySmall,
                            fontWeight: FontWeight.bold,
                            color: hasAlerts
                                ? AppColors.errorDark
                                : AppColors.successDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasAlerts
                              ? 'تم رصد $totalAlerts تجاوزاً في المحطات'
                              : 'لم يتم رصد أي تجاوزات تشغيلية',
                          style: TextStyle(
                            fontSize: HomeTypography.caption,
                            color: hasAlerts
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildInsightRow(
              'تجاوز استهلاك الكهرباء',
              data.overPowerConsump?.length ?? 0,
              AppGradients.warning,
            ),
            _buildInsightRow(
              'عدادات مياه بدون طاقة إلكترونية',
              data.Waterformissingpower?.length ?? 0,
              AppGradients.danger,
            ),
            _buildInsightRow(
              'الإنارة والعدادات المهملة',
              data.overpowerfor0water?.length ?? 0,
              AppGradients.orange,
            ),
            _buildInsightRow(
              'تجاوزات الكلور المضاف',
              data.overChlorineConsump?.length ?? 0,
              AppGradients.info,
            ),
            _buildInsightRow(
              'تجاوزات الشبة السائلة',
              data.overLiquidAlumConsump?.length ?? 0,
              AppGradients.primary,
            ),
            _buildInsightRow(
              'تجاوزات الشبة الصلبة',
              data.overSolidAlumConsump?.length ?? 0,
              AppGradients.purple,
            ),
            _buildInsightRow(
              'محطات تجاوزت الطاقة التصميمية',
              data.overWaterStations?.length ?? 0,
              AppGradients.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcePerformanceCard(ConsumptionModel data) {
    return _DashCard(
      headerGradient: AppGradients.info,
      icon: Icons.assessment_rounded,
      title: 'مؤشرات الاستهلاك والإنتاج الإجمالية',
      subtitle:
          'نظرة كمية شاملة على إنتاجية المياه واستهلاك الطاقة والموارد الكيماوية',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResourceProgressSection(
              title: 'إنتاج المياه الصالحة للشرب',
              value: '${data.water?.toStringAsFixed(0) ?? '0'} م³',
              subtitle: '',
              progressGradient: AppGradients.info,
              icon: Icons.water_drop_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'استهلاك الطاقة الكهربائية',
              value: '${data.power?.toStringAsFixed(0) ?? '0'} كيلوواط',
              subtitle: '',
              progressGradient: AppGradients.warning,
              icon: Icons.bolt_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'المواد الكيماوية المستهلكة',
              value:
                  '${((data.chlorine ?? 0) + (data.liquidAlum ?? 0) + (data.solidAlum ?? 0)).toStringAsFixed(0)} كجم',
              subtitle:
                  'الكلور: ${data.chlorine?.toStringAsFixed(0) ?? '0'} كجم • الشبة: ${((data.liquidAlum ?? 0) + (data.solidAlum ?? 0)).toStringAsFixed(0)} كجم',
              progressGradient: AppGradients.purple,
              icon: Icons.science_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'معالجة الصرف الصحي والبيئة',
              value: '${data.sanitaion?.toStringAsFixed(0) ?? '0'} م³',
              subtitle: "",
              progressGradient: AppGradients.teal,
              icon: Icons.eco_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceProgressSection({
    required String title,
    required String value,
    required String subtitle,
    required LinearGradient progressGradient,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: progressGradient.colors.first),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: HomeTypography.resourceTitle,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: HomeTypography.resourceValue,
                fontWeight: FontWeight.bold,
                color: progressGradient.colors.first,
              ),
            ),
          ],
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: HomeTypography.resourceSub,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInsightRow(String label, int count, LinearGradient gradient) {
    final color = gradient.colors.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: HomeTypography.insightLabel,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: count > 0 ? gradient : null,
              color: count > 0 ? null : AppColors.borderLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow:
                  count > 0
                      ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: HomeTypography.insightCount,
                fontWeight: FontWeight.bold,
                color: count > 0 ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Over Capacity Stations Card removed
}

// ─── Reusable Dashboard Card ──────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final LinearGradient headerGradient;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _DashCard({
    required this.headerGradient,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = headerGradient.colors.first;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(_T.radius),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [_T.shadowSubtle],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(_T.radius),
                topRight: Radius.circular(_T.radius),
              ),
              gradient: AppGradients.cardHeaderTint(accentColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: headerGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: HomeTypography.cardTitle,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: HomeTypography.cardSubtitle,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          child,
        ],
      ),
    );
  }
}

// ─── Animated Skeleton Container ──────────────────────────────────────────

class _SkeletonContainer extends StatefulWidget {
  final double? width;
  final double? height;
  final double radius;

  const _SkeletonContainer({this.width, this.height, this.radius = 16});

  @override
  State<_SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<_SkeletonContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.2 + (_controller.value * 0.4),
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ─── Tab Config (extended with gradient) ─────────────────────────────────────

class _TabConfig {
  final String title;
  final int count;
  final List<OverConsump> Function() lazyList;
  final String label;
  final IconData icon;
  final Color accentColor;
  final LinearGradient gradient;

  _TabConfig(
    this.title,
    this.count,
    this.lazyList,
    this.label,
    this.icon,
    this.accentColor,
    this.gradient,
  );
}

// ─── Hover Reactive KPI Card Widget ──────────────────────────────────────────

class _HoverStatCard extends StatefulWidget {
  final String title;
  final num targetValue;
  final String suffix;
  final IconData icon;
  final LinearGradient gradient;
  final double progress;

  const _HoverStatCard({
    required this.title,
    required this.targetValue,
    required this.suffix,
    required this.icon,
    required this.gradient,
    required this.progress,
  });

  @override
  State<_HoverStatCard> createState() => _HoverStatCardState();
}

class _HoverStatCardState extends State<_HoverStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final startColor = widget.gradient.colors.first;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform:
            _isHovered
                ? (Matrix4.identity()..scale(1.025))
                : Matrix4.identity(),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(_T.cardRadius),
          border: Border.all(
            color: _isHovered ? startColor.withOpacity(0.4) : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: startColor.withOpacity(_isHovered ? 0.12 : 0.04),
              blurRadius: _isHovered ? 24 : 16,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: widget.targetValue.toDouble()),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            final formatted = NumberFormat('#,###').format(val.round());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: HomeTypography.resourceValue,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: startColor.withOpacity(
                              _isHovered ? 0.45 : 0.35,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$formatted ${widget.suffix}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: HomeTypography.statTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
