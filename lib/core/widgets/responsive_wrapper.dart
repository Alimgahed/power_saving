import 'package:flutter/material.dart';

/// A global wrapper for responsive layouts across the application.
/// It automatically handles switching between Mobile, Tablet, and Desktop layouts.
class ResponsiveWrapper extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveWrapper({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  // Layout breakpoints based on our audit recommendations
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 750;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 750 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        }
        else if (constraints.maxWidth >= 750) {
          return tablet ?? desktop; // fallback to desktop layout if tablet not provided
        }
        else {
          return mobile;
        }
      },
    );
  }
}
