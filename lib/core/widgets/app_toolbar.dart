import 'package:power_saving/core/widgets/app_drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';

/// Keeps navigation physically left while preserving the content's language.
class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolbar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.leftActions = const [],
    this.centerTitle = true,
  });

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final List<Widget> leftActions;
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
        title: leftActions.isEmpty
            ? content(title)
            : LayoutBuilder(builder: (context, constraints) => Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(mainAxisSize: MainAxisSize.min,
                        children: leftActions.map(content).toList()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Align(alignment: Alignment.center, child: content(title))),
                ],
              )),
        actions: [
          ...?actions?.map(content),
          if (Scaffold.maybeOf(context)?.hasDrawer == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: AppDrawerButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
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
