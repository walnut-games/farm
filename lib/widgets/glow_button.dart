import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlowButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final bool enabled;

  const GlowButton({super.key, required this.child, this.onPressed, this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20), this.enabled = true});

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.onPressed != null;
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glow = 0.28 + (_pulseController.value * 0.18);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: enabled
                  ? [AppTheme.accent.withAlpha(242), AppTheme.gold.withAlpha(230)]
                  : [Colors.white12, Colors.white10],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: enabled
                ? [
                    BoxShadow(color: AppTheme.accent.withAlpha((glow * 255).round()), blurRadius: 24, spreadRadius: 2),
                    BoxShadow(color: AppTheme.gold.withAlpha((glow * 0.6 * 255).round()), blurRadius: 32, spreadRadius: 1),
                  ]
                : [const BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(18),
              splashColor: AppTheme.gold.withAlpha(64),
              highlightColor: AppTheme.accent.withAlpha(36),
              child: Padding(
                padding: widget.padding,
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
