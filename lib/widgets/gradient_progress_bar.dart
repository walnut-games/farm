import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;
  final String label;
  final Color startColor;
  final Color endColor;
  final String percentage;

  const GradientProgressBar({super.key, required this.value, required this.label, required this.startColor, required this.endColor, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.text)),
            Text(percentage, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.gold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 14,
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(14)),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value.clamp(0.0, 1.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 650),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [startColor, endColor]),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: endColor.withAlpha(46), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 4))],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
