import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? color;
  final Gradient? gradient;

  const GlassContainer({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.borderRadius = const BorderRadius.all(Radius.circular(24)), this.color, this.gradient});

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 8),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.color ?? Colors.white24,
              gradient: widget.gradient ?? const LinearGradient(colors: [Colors.white10, Colors.white12]),
              borderRadius: widget.borderRadius,
              border: Border.all(color: Colors.white12, width: 1.2),
              boxShadow: [
                BoxShadow(color: AppTheme.shadow.withAlpha(46), blurRadius: 24, offset: const Offset(0, 12)),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
