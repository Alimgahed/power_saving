import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';

/// Keeps navigation physically left while preserving the content's language.
class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolbar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    Widget content(Widget child) =>
        Directionality(textDirection: direction, child: child);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: leading,
        title: content(title),
        actions: [
          ...?actions?.map(content),
          if (Scaffold.maybeOf(context)?.hasDrawer == true)
            IconButton(
              tooltip: 'القائمة',
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
        ],
        centerTitle: centerTitle,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.header),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
