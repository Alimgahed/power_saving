import 'package:flutter/material.dart';

/// Elite high-performance VSync-aware shimmering placeholder for asynchronous layouts
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFE2E8F0), // Slate 200
                Color(0xFFF1F5F9), // Slate 100
                Color(0xFFE2E8F0), // Slate 200
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 2), -0.3),
              end: Alignment(1.0 + (_controller.value * 2), 0.3),
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer card mockup to represent an asynchronous enterprise dashboard statistic block
class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerLoading(width: 80, height: 16),
          SizedBox(height: 12),
          ShimmerLoading(width: 140, height: 28),
          SizedBox(height: 8),
          ShimmerLoading(width: 100, height: 14),
        ],
      ),
    );
  }
}
