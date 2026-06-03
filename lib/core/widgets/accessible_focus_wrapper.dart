import 'package:flutter/material.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

/// A wrapper that adds semantic labels and keyboard focus highlighting
/// to custom interactive elements.
class AccessibleFocusWrapper extends StatefulWidget {
  final Widget child;
  final String semanticLabel;
  final VoidCallback onTap;
  final bool enabled;

  const AccessibleFocusWrapper({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<AccessibleFocusWrapper> createState() => _AccessibleFocusWrapperState();
}

class _AccessibleFocusWrapperState extends State<AccessibleFocusWrapper> {
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.enabled,
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.enabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(
                  color: _isFocused ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
                color: _isHovered && widget.enabled
                    ? AppColors.primaryLight.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
