import 'package:flutter/material.dart';
import 'package:power_saving/core/widgets/app_back_button.dart';
import 'package:power_saving/core/widgets/app_toolbar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backRoute;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backRoute,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppToolbar(
      title: Text(title),
      centerTitle: true,
      leading:
          showBackButton
              ? AppBackButton(
                onRootBack: () {
                  // Public registration retains its public login destination.
                  final destination = backRoute == '/Login' ? '/Login' : '/home';
                  if (ModalRoute.of(context)?.settings.name != destination) {
                    Navigator.of(context).pushReplacementNamed(destination);
                  }
                },
              )
              : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
