import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Particle {
  Offset position;
  Offset velocity;
  double radius;
  double opacity;

  _Particle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.opacity,
  });
}

class NeuralBackground extends StatefulWidget {
  const NeuralBackground({super.key});

  @override
  State<NeuralBackground> createState() => _NeuralBackgroundState();
}

class _NeuralBackgroundState extends State<NeuralBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  static const int _particleCount = 40;
  static const double _connectionDistance = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() => setState(() => _updateParticles()));
    _controller.repeat();
  }

  void _initParticles(Size size) {
    if (_particles.isEmpty) {
      final rng = Random();
      for (int i = 0; i < _particleCount; i++) {
        _particles.add(
          _Particle(
            position: Offset(
              rng.nextDouble() * size.width,
              rng.nextDouble() * size.height,
            ),
            velocity: Offset(
              (rng.nextDouble() - 0.5) * 0.4,
              (rng.nextDouble() - 0.5) * 0.4,
            ),
            radius: rng.nextDouble() * 2 + 1,
            opacity: rng.nextDouble() * 0.5 + 0.2,
          ),
        );
      }
    }
  }

  void _updateParticles() {
    for (final p in _particles) {
      p.position = Offset(
        p.position.dx + p.velocity.dx,
        p.position.dy + p.velocity.dy,
      );
      // Bounce off edges
      if (p.position.dx < 0 || p.position.dx > 1000) {
        p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
      }
      if (p.position.dy < 0 || p.position.dy > 2000) {
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initParticles(constraints.biggest);
        return CustomPaint(
          painter: _NeuralPainter(_particles, _connectionDistance),
          size: constraints.biggest,
        );
      },
    );
  }
}

class _NeuralPainter extends CustomPainter {
  final List<_Particle> particles;
  final double connectionDistance;

  _NeuralPainter(this.particles, this.connectionDistance);

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint();
    final linePaint = Paint()..strokeWidth = 0.5;

    for (int i = 0; i < particles.length; i++) {
      final a = particles[i];

      // Draw dot
      dotPaint.color = AppTheme.accentPrimary.withOpacity(a.opacity);
      canvas.drawCircle(a.position, a.radius, dotPaint);

      // Draw connections
      for (int j = i + 1; j < particles.length; j++) {
        final b = particles[j];
        final dist = (a.position - b.position).distance;
        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.3;
          linePaint.color = AppTheme.accentPrimary.withOpacity(opacity);
          canvas.drawLine(a.position, b.position, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
