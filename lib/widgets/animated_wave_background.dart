import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWaveBackground extends StatefulWidget {
  final Widget child;
  const AnimatedWaveBackground({super.key, required this.child});

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
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
        return CustomPaint(
          painter: _WavePainter(progress: _controller.value),
          child: widget.child,
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double progress;
  const _WavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final path = Path();
    final height = size.height;
    final width = size.width;
    path.moveTo(0, height * 0.7);
    for (int i = 0; i <= 4; i++) {
      final x = width * i / 4;
      final y = height * (0.7 + 0.04 * (i % 2 == 0 ? 1 : -1) * (1 + 0.1 * math.sin((progress * 2 * math.pi) + i)));
      path.lineTo(x, y);
    }
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0xFF0A281E).withAlpha(102), const Color(0xFF0F432E).withAlpha(51)],
    ).createShader(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(path, paint);

    final particles = Paint()..color = const Color(0xFF7AF0B6).withAlpha(20);
    for (int j = 0; j < 10; j++) {
      final dx = width * ((j * 0.16 + progress) % 1);
      final dy = height * (0.15 + 0.12 * math.sin(progress * 2 * math.pi + j));
      canvas.drawCircle(Offset(dx, dy), 4.5, particles);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => oldDelegate.progress != progress;
}
