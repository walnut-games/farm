import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? color;
  final Gradient? gradient;

  const GlassContainer({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.borderRadius = const BorderRadius.all(Radius.circular(24)), this.color, this.gradient});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white24,
            gradient: gradient ?? const LinearGradient(colors: [Colors.white10, Colors.white12]),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white12, width: 1.2),
            boxShadow: [
              BoxShadow(color: AppTheme.shadow.withAlpha(46), blurRadius: 24, offset: const Offset(0, 12)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
