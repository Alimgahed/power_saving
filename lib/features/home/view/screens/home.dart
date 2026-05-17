import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'dart:ui' as ui;

import 'package:power_saving/features/home/controller/home.dart';
import 'package:power_saving/features/home/model/home.dart';
import 'package:power_saving/features/home/view/widgets/home_app_bar.dart';
import 'package:power_saving/features/home/view/widgets/home_drawer.dart';
import 'package:power_saving/features/home/view/widgets/consumpation_card.dart';
import 'package:power_saving/features/home/view/widgets/water_stations_card.dart';
import 'package:power_saving/features/home/view/widgets/empaty.dart';
import 'package:power_saving/global/data.dart';
import 'package:power_saving/global/iframe_platform.dart';

// ─── Theme Tokens ────────────────────────────────────────────────────────────

class _T {
  // Gradient palettes
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient successGrad = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient warningGrad = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient dangerGrad = LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient purpleGrad = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cyanGrad = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient orangeGrad = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient tealGrad = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Header diagonal gradient
  static const LinearGradient headerGrad = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const double radius = 20;
  static const double cardRadius = 16;
  static const double spacing = 24;
  static const double spacingSm = 16;

  // ─── Professional SaaS Color Extensions ───────────────────────────────────
  static const Color primary = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryHover = Color(0xFF1D4ED8);
  static const Color primarySurface = Color(0xFFEFF6FF);
  static const Color primaryBorder = Color(0xFFDBEAFE);

  // Soft Slate Surfaces (calm for eyes)
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundMuted = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // High-Legibility Slate Typography
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF475569);
  static const Color textLight = Color(0xFF64748B);

  // Subtle Interactive Elevations & Gradients
  static final BoxShadow shadowSubtle = BoxShadow(
    color: const Color(0xFF1E40AF).withOpacity(0.04),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  static final BoxShadow shadowHover = BoxShadow(
    color: const Color(0xFF1E40AF).withOpacity(0.08),
    blurRadius: 24,
    offset: const Offset(0, 8),
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _T.background,
        appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
        drawer: HomeDrawer(),
        body: _buildBody(context),
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
                    gradient: _T.primaryGrad,
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
                    fontSize: 14,
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
                      fontSize: 16,
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

    final initial =
        (user?.username ?? 'U').trim().isNotEmpty
            ? (user?.username ?? 'U').trim()[0].toUpperCase()
            : 'U';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _T.headerGrad,
        borderRadius: BorderRadius.circular(_T.radius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.35),
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
                        // User Profile Glass Avatar
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
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
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                              ),
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
                                  fontSize: 28,
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
                                        fontSize: 14.5,
                                        color: Colors.white.withOpacity(0.9),
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
                                        fontSize: 12,
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
                                        fontSize: 11,
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
                                        fontSize: 11,
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

        final double cardHeight = cols == 1 ? 95 : 140;
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
                  gradient: _T.successGrad,
                  progress: 0.85,
                ),
                _HoverStatCard(
                  title: 'المياه المنتجة',
                  targetValue: waterVal,
                  suffix: 'م³',
                  icon: Icons.water_drop_rounded,
                  gradient: _T.primaryGrad,
                  progress: 0.75,
                ),
                _HoverStatCard(
                  title: 'المياه المرفوعة',
                  targetValue: saintionVal,
                  suffix: 'م³',
                  icon: Icons.upload_rounded,
                  gradient: _T.purpleGrad,
                  progress: 0.65,
                ),
                _HoverStatCard(
                  title: 'الكهرباء المستهلكة',
                  targetValue: powerVal,
                  suffix: 'واط',
                  icon: Icons.bolt_rounded,
                  gradient: _T.warningGrad,
                  progress: 0.45,
                ),
                _HoverStatCard(
                  title: 'كمية الكلور',
                  targetValue: chlorineVal,
                  suffix: 'كجم',
                  icon: Icons.science_rounded,
                  gradient: _T.cyanGrad,
                  progress: 0.35,
                ),
                _HoverStatCard(
                  title: 'الشبة السائلة',
                  targetValue: liquidAlumVal,
                  suffix: 'كجم',
                  icon: Icons.opacity_rounded,
                  gradient: _T.orangeGrad,
                  progress: 0.55,
                ),
                _HoverStatCard(
                  title: 'الشبة الصلبة',
                  targetValue: solidAlumVal,
                  suffix: 'كجم',
                  icon: Icons.grain_rounded,
                  gradient: _T.purpleGrad,
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
        const Color(0xFFD97706),
        _T.warningGrad,
      ),
      _TabConfig(
        'مياه بدون طاقة',
        data.Waterformissingpower ?? [],
        'مياة بدون طاقة',
        Icons.priority_high_rounded,
        const Color(0xFFDC2626),
        _T.dangerGrad,
      ),
      _TabConfig(
        'الإنارة الزائدة',
        data.overpowerfor0water ?? [],
        'الإنارة',
        Icons.lightbulb_rounded,
        const Color(0xFFEA580C),
        _T.orangeGrad,
      ),
      _TabConfig(
        'تجاوز الكلور',
        data.overChlorineConsump ?? [],
        'الكلور',
        Icons.science_rounded,
        const Color(0xFF0891B2),
        _T.cyanGrad,
      ),
      _TabConfig(
        'الشبة السائلة',
        data.overLiquidAlumConsump ?? [],
        'الشبة السائلة',
        Icons.opacity_rounded,
        const Color(0xFF1E40AF),
        _T.primaryGrad,
      ),
      _TabConfig(
        'الشبة الصلبة',
        data.overSolidAlumConsump ?? [],
        'الشبة الصلبة',
        Icons.grain_rounded,
        const Color(0xFF7C3AED),
        _T.purpleGrad,
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: _DashCard(
        headerGradient: _T.dangerGrad,
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
                    color: _T.cardBackgroundMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    onTap: (index) => activeAlertTab.value = index,
                    isScrollable: isScrollable,
                    indicator: BoxDecoration(
                      gradient: _T.primaryGrad,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: _T.primary.withOpacity(0.35),
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
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
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
                                      size: 14,
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
                                          fontSize: 10,
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
      headerGradient: _T.purpleGrad,
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
                gradient: LinearGradient(
                  colors:
                      hasAlerts
                          ? [const Color(0xFFFEF2F2), const Color(0xFFFFF5F5)]
                          : [const Color(0xFFECFDF5), const Color(0xFFF0FDF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color:
                      hasAlerts
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFF6EE7B7),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: hasAlerts ? _T.dangerGrad : _T.successGrad,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      hasAlerts
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 18,
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
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color:
                                hasAlerts
                                    ? const Color(0xFF991B1B)
                                    : const Color(0xFF065F46),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasAlerts
                              ? 'تم رصد $totalAlerts تجاوزاً في المحطات'
                              : 'لم يتم رصد أي تجاوزات تشغيلية',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                hasAlerts
                                    ? const Color(0xFFB91C1C)
                                    : const Color(0xFF047857),
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
              _T.warningGrad,
            ),
            _buildInsightRow(
              'عدادات مياه بدون طاقة إلكترونية',
              data.Waterformissingpower?.length ?? 0,
              _T.dangerGrad,
            ),
            _buildInsightRow(
              'الإنارة والعدادات المهملة',
              data.overpowerfor0water?.length ?? 0,
              _T.orangeGrad,
            ),
            _buildInsightRow(
              'تجاوزات الكلور المضاف',
              data.overChlorineConsump?.length ?? 0,
              _T.cyanGrad,
            ),
            _buildInsightRow(
              'تجاوزات الشبة السائلة',
              data.overLiquidAlumConsump?.length ?? 0,
              _T.primaryGrad,
            ),
            _buildInsightRow(
              'تجاوزات الشبة الصلبة',
              data.overSolidAlumConsump?.length ?? 0,
              _T.purpleGrad,
            ),
            _buildInsightRow(
              'محطات تجاوزت الطاقة التصميمية',
              data.overWaterStations?.length ?? 0,
              _T.tealGrad,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcePerformanceCard(ConsumptionModel data) {
    return _DashCard(
      headerGradient: _T.cyanGrad,
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
              progress: 0.78,
              progressGradient: _T.cyanGrad,
              icon: Icons.water_drop_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'استهلاك الطاقة الكهربائية',
              value: '${data.power?.toStringAsFixed(0) ?? '0'} كيلوواط',
              subtitle:
                  'معدل كفاءة الطاقة: 1.2 كيلوواط/م³ • حالة التوريد: مستقر',
              progress: 0.65,
              progressGradient: _T.warningGrad,
              icon: Icons.bolt_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'المواد الكيماوية المستهلكة',
              value:
                  '${((data.chlorine ?? 0) + (data.liquidAlum ?? 0) + (data.solidAlum ?? 0)).toStringAsFixed(0)} كجم',
              subtitle:
                  'الكلور: ${data.chlorine?.toStringAsFixed(0) ?? '0'} كجم • الشبة: ${((data.liquidAlum ?? 0) + (data.solidAlum ?? 0)).toStringAsFixed(0)} كجم',
              progress: 0.82,
              progressGradient: _T.purpleGrad,
              icon: Icons.science_rounded,
            ),
            const SizedBox(height: 18),
            _buildResourceProgressSection(
              title: 'معالجة الصرف الصحي والبيئة',
              value: '${data.sanitaion?.toStringAsFixed(0) ?? '0'} م³',
              subtitle: 'نسبة التغطية: 100% • كفاءة المعالجة البيئية: ممتازة',
              progress: 0.90,
              progressGradient: _T.tealGrad,
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
    required double progress,
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
                Icon(icon, size: 16, color: progressGradient.colors.first),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: progressGradient.colors.first,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(height: 8, color: AppColors.borderLight),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      gradient: progressGradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
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
                style: TextStyle(
                  fontSize: 15,
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
                fontSize: 13.5,
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
        color: _T.cardBackground,
        borderRadius: BorderRadius.circular(_T.radius),
        border: Border.all(color: _T.border, width: 1),
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
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.04),
                  accentColor.withOpacity(0.01),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
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
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _T.textDark,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _T.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _T.border),
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
          color: _T.cardBackground,
          borderRadius: BorderRadius.circular(_T.cardRadius),
          border: Border.all(
            color: _isHovered ? startColor.withOpacity(0.4) : _T.border,
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
                          color: _T.textMuted,
                          fontSize: 14,
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
                      child: Icon(widget.icon, color: Colors.white, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$formatted ${widget.suffix}',
                  style: const TextStyle(
                    color: _T.textDark,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      backgroundColor: startColor.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(startColor),
                    ),
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
