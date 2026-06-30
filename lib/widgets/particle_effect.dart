import 'dart:math';
import 'package:flutter/material.dart';

class ParticleEffect extends StatefulWidget {
  final String type;

  const ParticleEffect({super.key, required this.type});

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(18, (_) => _Particle.random(widget.type, _random));
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..addListener(() {
        setState(() {
          for (final particle in _particles) {
            particle.update(_controller.value);
          }
        });
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ParticlePainter(particles: _particles, progress: _controller.value),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  final Offset start;
  Offset position;
  final double speed;
  final Color color;
  final double radius;
  final String type;
  final double direction;

  _Particle({
    required this.start,
    required this.position,
    required this.speed,
    required this.color,
    required this.radius,
    required this.type,
    required this.direction,
  });

  factory _Particle.random(String type, Random random) {
    final start = Offset(140 + random.nextDouble() * 240, 220 + random.nextDouble() * 260);
    final direction = random.nextDouble() * pi * 2;
    final radius = type == 'coins' ? 6 + random.nextDouble() * 6 : 4 + random.nextDouble() * 5;
    return _Particle(
      start: start,
      position: start,
      speed: 40 + random.nextDouble() * 80,
      color: _colorForType(type, random),
      radius: radius,
      type: type,
      direction: direction,
    );
  }

  static Color _colorForType(String type, Random random) {
    switch (type) {
      case 'water':
        return Colors.lightBlueAccent.withAlpha((0.75 * 255).round());
      case 'dust':
        return Colors.brown.shade300.withAlpha((0.75 * 255).round());
      case 'coins':
        return Colors.amberAccent.withAlpha((0.9 * 255).round());
      case 'leaves':
      default:
        return Colors.lightGreenAccent.withAlpha((0.8 * 255).round());
    }
  }

  void update(double progress) {
    final distance = speed * progress * 1.8;
    position = Offset(
      start.dx + cos(direction) * distance,
      start.dy + sin(direction) * distance + progress * 120,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final particle in particles) {
      final alpha = ((1 - progress).clamp(0.0, 1.0) * 255).round();
      paint.color = particle.color.withAlpha(alpha);
      if (particle.type == 'coins') {
        canvas.drawCircle(particle.position, particle.radius, paint);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 1.5;
        canvas.drawCircle(particle.position, particle.radius * 0.6, paint);
        paint.style = PaintingStyle.fill;
      } else {
        canvas.drawCircle(particle.position, particle.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
