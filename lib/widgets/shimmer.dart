import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const AppShimmer({super.key, this.height = 16, this.width = double.infinity, this.borderRadius});

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
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
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, -0.3),
              end: Alignment(1 + _controller.value * 2, 0.3),
              colors: [Colors.grey.shade800, Colors.grey.shade700, Colors.grey.shade800],
            ),
          ),
        );
      },
    );
  }
}
