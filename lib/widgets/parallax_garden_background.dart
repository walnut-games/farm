import 'package:flutter/material.dart';

class ParallaxGardenBackground extends StatelessWidget {
  final Animation<double> animation;

  const ParallaxGardenBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = animation.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF061F28), Color(0xFF0F362E)],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: -120 + offset * 240,
              right: null,
              child: Opacity(
                opacity: 0.35,
                child: _buildCloud(220, const Color(0xFF1A4A6F)),
              ),
            ),
            Positioned(
              top: 70,
              left: -80 + offset * 160,
              child: Opacity(
                opacity: 0.28,
                child: _buildCloud(180, const Color(0xFF1D4866)),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -180 + offset * 360,
              right: null,
              child: _buildHill(260, Colors.blueGrey.shade900, 0.5),
            ),
            Positioned(
              bottom: 100,
              left: -80 + offset * 280,
              child: _buildHill(320, Colors.green.shade900.withAlpha((0.85 * 255).round()), 0.6),
            ),
            Positioned(
              bottom: 70,
              left: -40 + offset * 220,
              child: _buildTreeLine(280, const Color(0xFF0F2F22), 0.65),
            ),
            Positioned(
              bottom: 42,
              left: offset * 140 - 70,
              child: _buildTreeLine(220, const Color(0xFF153726), 0.8),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCloud(double width, Color color) {
    return Container(
      width: width,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(60),
      ),
    );
  }

  Widget _buildHill(double width, Color color, double heightFactor) {
    return Container(
      width: width,
      height: 120 * heightFactor,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(120 * heightFactor),
          topRight: Radius.circular(120 * heightFactor),
        ),
      ),
    );
  }

  Widget _buildTreeLine(double width, Color color, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withAlpha(0), color.withAlpha((0.9 * 255).round()), color.withAlpha(0)],
            stops: const [0.05, 0.5, 0.95],
          ),
          borderRadius: BorderRadius.circular(180),
        ),
      ),
    );
  }
}
