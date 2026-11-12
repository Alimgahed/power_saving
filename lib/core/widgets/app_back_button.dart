import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

/// Pops the existing stack; uses the screen's declared destination at the root.
class AppBackButton extends StatefulWidget {
  const AppBackButton({super.key, this.onRootBack});
  final VoidCallback? onRootBack;

  @override
  State<AppBackButton> createState() => _AppBackButtonState();
}

class _AppBackButtonState extends State<AppBackButton> {
  bool _handlingBack = false;

  Future<void> _goBack() async {
    if (_handlingBack) return;
    final navigator = Navigator.of(context);
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) return;
    _handlingBack = true;
    try {
      // A true result also means a PopScope veto handled the request.
      // Only an unhandled back request may use the root destination.
      final handled = await navigator.maybePop();
      if (handled || !mounted || !navigator.mounted) return;
      if (route != null && (!route.isCurrent || ModalRoute.of(context) != route)) return;
      if (widget.onRootBack != null) {
        widget.onRootBack!();
      } else if (route?.settings.name != '/home') {
        navigator.pushReplacementNamed('/home');
      }
    } finally {
      _handlingBack = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.paddingXS,
      vertical: 4,
    ),
    child: IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: const Icon(Icons.arrow_back, textDirection: TextDirection.ltr),
      color: Colors.white,
      onPressed: _goBack,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    ),
  );
}
