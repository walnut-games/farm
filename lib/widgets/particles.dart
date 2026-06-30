import 'dart:math';
import 'package:flutter/material.dart';

class FallingLeavesWidget extends StatefulWidget {
  const FallingLeavesWidget({super.key});

  @override
  State<FallingLeavesWidget> createState() => _FallingLeavesWidgetState();
}

class _FallingLeavesWidgetState extends State<FallingLeavesWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Leaf> _leaves = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _initLeaves();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..addListener(_updateLeaves)
      ..repeat();
  }

  void _initLeaves() {
    final count = 18 + _random.nextInt(8);
    for (var i = 0; i < count; i++) {
      _leaves.add(_Leaf.random(_random));
    }
  }

  void _updateLeaves() {
    for (final leaf in _leaves) {
      leaf.y += leaf.speed * 0.016;
      leaf.x += sin(leaf.phase + leaf.y * 0.02) * leaf.sway;
      leaf.rotation += leaf.rotationSpeed * 0.02;
      if (leaf.y > leaf.maxHeight) {
        leaf.reset(_random, leaf.maxWidth);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LeafPainter(leaves: _leaves),
      size: Size.infinite,
    );
  }
}

class _Leaf {
  double x;
  double y;
  double size;
  double speed;
  double sway;
  double rotation;
  double rotationSpeed;
  double phase;
  Color color;
  final double maxWidth;
  final double maxHeight;

  _Leaf({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.sway,
    required this.rotation,
    required this.rotationSpeed,
    required this.phase,
    required this.color,
    required this.maxWidth,
    required this.maxHeight,
  });

  factory _Leaf.random(Random random) {
    final maxWidth = 400.0 + random.nextDouble() * 400.0;
    final maxHeight = 800.0 + random.nextDouble() * 600.0;
    return _Leaf(
      x: random.nextDouble() * maxWidth,
      y: random.nextDouble() * maxHeight,
      size: 10 + random.nextDouble() * 12,
      speed: 50 + random.nextDouble() * 100,
      sway: 8 + random.nextDouble() * 8,
      rotation: random.nextDouble() * pi * 2,
      rotationSpeed: 0.4 + random.nextDouble() * 0.6,
      phase: random.nextDouble() * pi * 2,
      color: Colors.primaries[random.nextInt(7)].withValues(alpha: 0.7),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  void reset(Random random, double width) {
    x = random.nextDouble() * width;
    y = -20.0 - random.nextDouble() * 100.0;
    speed = 50 + random.nextDouble() * 100;
    sway = 8 + random.nextDouble() * 8;
    rotation = random.nextDouble() * pi * 2;
    rotationSpeed = 0.4 + random.nextDouble() * 0.6;
    phase = random.nextDouble() * pi * 2;
    size = 10 + random.nextDouble() * 12;
    color = Color.lerp(Colors.green.shade300, Colors.brown.shade600, random.nextDouble())!.withValues(alpha: 0.75);
  }
}

class _LeafPainter extends CustomPainter {
  final List<_Leaf> leaves;

  _LeafPainter({required this.leaves});

  @override
  void paint(Canvas canvas, Size size) {
    for (final leaf in leaves) {
      final paint = Paint()..color = leaf.color;
      final center = Offset(leaf.x % size.width, leaf.y % size.height);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(leaf.rotation);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: leaf.size, height: leaf.size * 0.6), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) => true;
}
