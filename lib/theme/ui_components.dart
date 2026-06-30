import 'package:flutter/material.dart';

class AppTheme {
  static const bg = Color(0xFF08170F);
  static const panel = Color(0xFF102E23);
  static const panelAlt = Color(0xFF143A2B);
  static const text = Color(0xFFE8F3E8);
  static const gold = Color(0xFFF6C85F);
  static const neon = Color(0xFF7AF0B6);
  static const muted = Color(0xFF9EB8A0);
  static const accent = Color(0xFF6AD5AF);
  static const shadow = Color(0xFF000000);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF071510), Color(0xFF112A1F), Color(0xFF16372B)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF173F33), Color(0xFF0D1F16)],
  );

  static final BoxDecoration glassPanel = BoxDecoration(
    color: Colors.white24,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white12, width: 1.2),
    boxShadow: [
      BoxShadow(color: shadow.withAlpha(61), blurRadius: 28, offset: const Offset(0, 14)),
    ],
    backgroundBlendMode: BlendMode.overlay,
  );

  static final BoxDecoration glowBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: const LinearGradient(colors: [Color(0xFF6FF5C0), Color(0xFFF8D868)]),
    boxShadow: [
      BoxShadow(color: neon.withAlpha(71), blurRadius: 24, spreadRadius: 3),
    ],
  );

  static TextTheme textTheme(TextTheme base) => base.copyWith(
        displayLarge: base.displayLarge?.copyWith(fontSize: 42, fontWeight: FontWeight.w800, color: text, letterSpacing: 0.8),
        displayMedium: base.displayMedium?.copyWith(fontSize: 32, fontWeight: FontWeight.w700, color: text),
        displaySmall: base.displaySmall?.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: text),
        headlineMedium: base.headlineMedium?.copyWith(fontSize: 22, fontWeight: FontWeight.w700, color: text),
        headlineSmall: base.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: text),
        titleLarge: base.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: text),
        bodyLarge: base.bodyLarge?.copyWith(fontSize: 14, height: 1.5, color: text),
        bodyMedium: base.bodyMedium?.copyWith(fontSize: 13, color: muted),
      );
}
