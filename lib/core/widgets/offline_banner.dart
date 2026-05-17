import 'package:flutter/material.dart';

/// Floating Glassmorphic Network Connectivity Banner
class OfflineBanner extends StatelessWidget {
  final bool isOffline;
  final VoidRefresherCallback? onRetry;

  const OfflineBanner({super.key, required this.isOffline, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      top: isOffline ? 16.0 : -100.0,
      left: 16.0,
      right: 16.0,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withOpacity(0.95), // Red 500
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'أنت غير متصل بالإنترنت',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'يرجى التحقق من اتصال الشبكة الخاص بك.',
                      style: TextStyle(color: Colors.white80, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (onRetry != null)
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef VoidRefresherCallback = void Function();
