import 'dart:math';
import 'package:flutter/material.dart';

class RainbowGlitterBackground extends StatefulWidget {
  final Widget child;
  const RainbowGlitterBackground({super.key, required this.child});

  @override
  State<RainbowGlitterBackground> createState() => _RainbowGlitterBackgroundState();
}

class _RainbowGlitterBackgroundState extends State<RainbowGlitterBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getRainbowColors(_controller.value),
            ),
          ),
          child: CustomPaint(
            painter: _GlitterPainter(_controller.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  List<Color> _getRainbowColors(double t) {
    // t goes 0→1; shift hues by a full 60° so it loops seamlessly
    // (each color slot is 60° apart, so shifting by 60° returns to the same pattern)
    final hueShift = t * 60;
    return [
      HSLColor.fromAHSL(1.0, (0 + hueShift) % 360, 0.7, 0.3).toColor(),
      HSLColor.fromAHSL(1.0, (60 + hueShift) % 360, 0.7, 0.25).toColor(),
      HSLColor.fromAHSL(1.0, (120 + hueShift) % 360, 0.7, 0.3).toColor(),
      HSLColor.fromAHSL(1.0, (180 + hueShift) % 360, 0.7, 0.25).toColor(),
      HSLColor.fromAHSL(1.0, (240 + hueShift) % 360, 0.7, 0.3).toColor(),
      HSLColor.fromAHSL(1.0, (300 + hueShift) % 360, 0.7, 0.25).toColor(),
    ];
  }
}

class _GlitterPainter extends CustomPainter {
  final double animValue;
  final Random _random = Random(42); // Fixed seed for consistent glitter positions

  _GlitterPainter(this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const glitterCount = 80;

    for (int i = 0; i < glitterCount; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final baseAlpha = _random.nextDouble();

      // Each glitter particle twinkles at its own phase
      final phase = _random.nextDouble() * 2 * pi;
      final twinkle = (sin(animValue * 2 * pi * 2 + phase) + 1) / 2;
      final alpha = (baseAlpha * 0.3 * twinkle).clamp(0.0, 1.0);

      paint.color = Colors.white.withValues(alpha: alpha);
      final radius = 1.0 + _random.nextDouble() * 2.0;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlitterPainter oldDelegate) {
    return oldDelegate.animValue != animValue;
  }
}
