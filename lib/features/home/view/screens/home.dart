import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'dart:ui' as ui;

import 'package:power_saving/features/home/controller/home.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'package:power_saving/features/home/view/widgets/enterprise_sidebar.dart';
import 'package:power_saving/core/widgets/responsive_wrapper.dart';
import 'package:power_saving/features/home/view/widgets/consumpation_card.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/features/home/home_constant/constant.dart';
import 'package:power_saving/global/data.dart';

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
    Get.put(HomeController());
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: ResponsiveWrapper(
        mobile: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          drawer: HomeDrawer(),
          body: SafeArea(child: _buildBody(context)),
        ),
        desktop: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Row(
              children: [
                EnterpriseSidebar(),
                Expanded(child: _buildBody(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.loading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'جاري تحميل البيانات...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: HomeTypography.bodySmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final data = controller.consumptionModel;
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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(_T.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(context),
              const SizedBox(height: _T.spacing),
              _buildStatsGrid(context, controller),
              const SizedBox(height: _T.spacing),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 950;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInsightsSummaryCard(data)),
                        const SizedBox(width: _T.spacing),
                        Expanded(child: _buildResourcePerformanceCard(data)),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildInsightsSummaryCard(data),
                      const SizedBox(height: _T.spacing),
                      _buildResourcePerformanceCard(data),
                    ],
                  );
                },
              ),
              const SizedBox(height: _T.spacing),
              _buildAlertsCenterCard(controller),
              const SizedBox(height: _T.spacing),
            ],
          ),
        );
      },
    );
  }

  // ─── Welcome Header ─────────────────────────────────────────────────────

  Widget _buildWelcomeHeader(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'ar').format(now);

    // Time-based personal greeting
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'صباح الخير';
    } else if (hour < 17) {
      greeting = 'مساء الخير';
    } else {
      greeting = 'طاب مساؤك';
    }


    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppGradients.header,
        borderRadius: BorderRadius.circular(_T.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_T.radius),
        child: Stack(
          children: [
            // Decorative Glowing Bubbles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),
            Positioned(
              right: 150,
              bottom: -40,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // Content Padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section
                  LayoutBuilder(
                    builder: (context, headerConstraints) {
                      final isMobile = headerConstraints.maxWidth < 650;
                      final mainRowChildren = [
                        // Drawer Toggle
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const SizedBox(width: 12),
                        // User Profile Glass Avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('images/Gemini_Generated_Image_f6db4f6db4f6db4f.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Greeting and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting، ${user?.username ?? 'المستخدم'} 👋',
                                style: const TextStyle(
                                  fontSize: HomeTypography.greeting,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_rounded,
                                    size: 14,
                                    color: Color(0xFF6EE7B7),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'نظام إدارة الطاقة والمياه والمواد الكيماوية • لوحة المراقبة الذكية',
                                      style: TextStyle(
                                        fontSize: HomeTypography.greetingSub,
                                        color: Colors.white.withOpacity(0.92),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (!isMobile) ...[
                          const SizedBox(width: 20),
                          // Calendar & Status Pills
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Date Pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: HomeTypography.caption,
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Online Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF34D399,
                                    ).withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'النظام متصل',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: HomeTypography.badge,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ];

                      return isMobile
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  mainRowChildren[0],
                                  const SizedBox(width: 16),
                                  Expanded(child: mainRowChildren[2]),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Date on mobile
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: HomeTypography.caption,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: mainRowChildren,
                          );
                    },
                  ),

                  // Embedded Glass Micro-Stats
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats Grid ──────────────────────────────────────────────────────────

  Widget _buildStatsGrid(BuildContext context, HomeController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int cols = 7;
        if (width < 1200) cols = 4;
        if (width < 750) cols = 2;
        if (width < 450) cols = 1;

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
        data.overPowerConsump ?? [],
        'الكهرباء',
        Icons.bolt_rounded,
        AppColors.warningDark,
        AppGradients.warning,
      ),
      _TabConfig(
        'مياه بدون طاقة',
        data.Waterformissingpower ?? [],
        'مياة بدون طاقة',
        Icons.priority_high_rounded,
        AppColors.errorDark,
        AppGradients.danger,
      ),
      _TabConfig(
        'الإنارة الزائدة',
        data.overpowerfor0water ?? [],
        'الإنارة',
        Icons.lightbulb_rounded,
        AppColors.orangeDark,
        AppGradients.orange,
      ),
      _TabConfig(
        'تجاوز الكلور',
        data.overChlorineConsump ?? [],
        'الكلور',
        Icons.science_rounded,
        AppColors.infoDark,
        AppGradients.info,
      ),
      _TabConfig(
        'الشبة السائلة',
        data.overLiquidAlumConsump ?? [],
        'الشبة السائلة',
        Icons.opacity_rounded,
        AppColors.primary,
        AppGradients.primary,
      ),
      _TabConfig(
        'الشبة الصلبة',
        data.overSolidAlumConsump ?? [],
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
                                        '${t.list.length}',
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
                              t.list,
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
        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
          itemCount: list.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 330,
          ),
          itemBuilder:
              (context, index) => ConsumptionCard(
                item: list[index],
                label: label,
                icon: icon,
                color: color,
              ),
        );
      },
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
              subtitle: 'مستهدف اليوم: 300,000 م³ • كفاءة الإنتاج: 94%',
              progressGradient: AppGradients.info,
              icon: Icons.water_drop_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'استهلاك الطاقة الكهربائية',
              value: '${data.power?.toStringAsFixed(0) ?? '0'} كيلوواط',
              subtitle:
                  'معدل كفاءة الطاقة: 1.2 كيلوواط/م³ • حالة التوريد: مستقر',
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
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: HomeTypography.resourceSub,
            color: AppColors.textSecondary,
          ),
        ),
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

// ─── Tab Config (extended with gradient) ─────────────────────────────────────

class _TabConfig {
  final String title;
  final List<OverConsump> list;
  final String label;
  final IconData icon;
  final Color accentColor;
  final LinearGradient gradient;

  _TabConfig(
    this.title,
    this.list,
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
