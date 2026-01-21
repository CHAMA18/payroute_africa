import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';

/// Shared background used by the Landing Hero + Login page.
///
/// Keeps the same "fintech noir" map + cyan network vibe across entry screens.
class HeroThemeBackground extends StatelessWidget {
  final Animation<double>? linesAnimation;
  final Animation<double>? breathe;
  final Alignment mapAlignment;
  final double mapBaseScale;
  final double mapBaseOpacity;

  const HeroThemeBackground({
    super.key,
    this.linesAnimation,
    this.breathe,
    this.mapAlignment = Alignment.centerRight,
    this.mapBaseScale = 0.9,
    this.mapBaseOpacity = 1.0,
  });

  static const String mapImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBw0XRj5nwDwL8rI3p2dwn8U04_kjQkO1bHRdU4OWbKSMxVRe6KXJwYdyEmAKih9xesOz9uVG9Gh5el5gh1Pmgdw-DP18zuZrYipfbsu28ZAH1y-jmaRSMi7Lc3vG__DSfP2Z4OQ_vtbzwOBhSa-uqyD6j1iyvY8yE_R0Cf8Tw1TtDk-VYikXkF2evdjK3TQHIz5k5odkeSoNcsTU0L1NcJtkgQWp10fi-K2ojFb_0-ifeChIDNsK_Uw3ukQK-qF9I4UQyvaZoiYc0T';

  @override
  Widget build(BuildContext context) {
    // This background is intentionally “hero dark” regardless of theme.
    // It’s an entry screen aesthetic, not a dashboard surface.
    final base = PayRouteColors.heroTeal3;

    Widget mapLayer = ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.4, 0.2, 0.2, 0, 0,
        0.2, 0.5, 0.2, 0, 0,
        0.2, 0.2, 0.4, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: Image.network(
        mapImageUrl,
        fit: BoxFit.contain,
        alignment: mapAlignment,
        errorBuilder: (_, __, ___) => Container(color: base),
      ),
    );

    if (breathe != null) {
      mapLayer = AnimatedBuilder(
        animation: breathe!,
        builder: (context, child) {
          final scale = mapBaseScale + (breathe!.value * 0.03);
          final opacity = (mapBaseOpacity - 0.15) + (breathe!.value * 0.15);
          return Opacity(opacity: opacity.clamp(0.0, 1.0), child: Transform.scale(scale: scale, child: child));
        },
        child: mapLayer,
      );
    } else {
      mapLayer = Opacity(opacity: mapBaseOpacity, child: Transform.scale(scale: mapBaseScale, child: mapLayer));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PayRouteColors.heroTeal1, PayRouteColors.heroTeal2, PayRouteColors.heroTeal3],
            ),
          ),
        ),
        // Subtle pattern overlay
        Positioned.fill(
          child: Opacity(opacity: 0.1, child: CustomPaint(painter: WavePatternPainter())),
        ),
        // Map image
        Positioned.fill(child: mapLayer),
        // Cyan tint overlay
        Container(color: PayRouteColors.electricBlue.withValues(alpha: 0.35)),
        // Dramatic radial focus
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.5, -0.2),
              radius: 1.2,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.6),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        if (linesAnimation != null)
          Positioned.fill(child: CustomPaint(painter: ConnectionLinesPainter(animation: linesAnimation!))),
      ],
    );
  }
}

class WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PayRouteColors.electricBlue
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (double y = 0; y < size.height; y += spacing) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 24) {
        path.quadraticBezierTo(x + 12, y + (x % 48 == 0 ? -10 : 10), x + 24, y);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConnectionLinesPainter extends CustomPainter {
  final Animation<double> animation;

  ConnectionLinesPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = PayRouteColors.electricBlue.withValues(alpha: 0.4)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final path1 = Path();
    path1.moveTo(size.width * 0.28, size.height * 0.35);
    path1.quadraticBezierTo(size.width * 0.5, size.height * 0.38, size.width * 0.82, size.height * 0.42);
    canvas.drawPath(path1, linePaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.28, size.height * 0.35);
    path2.quadraticBezierTo(size.width * 0.38, size.height * 0.55, size.width * 0.68, size.height * 0.72);
    canvas.drawPath(path2, linePaint..color = PayRouteColors.electricBlue.withValues(alpha: 0.3));

    final path3 = Path();
    path3.moveTo(size.width * 0.72, size.height * 0.22);
    path3.quadraticBezierTo(size.width * 0.78, size.height * 0.32, size.width * 0.82, size.height * 0.42);
    canvas.drawPath(path3, linePaint..color = PayRouteColors.electricBlue.withValues(alpha: 0.25));

    final dotPaint = Paint()..color = Colors.white;

    final progress1 = animation.value;
    final pathMetrics1 = path1.computeMetrics().first;
    final tangent1 = pathMetrics1.getTangentForOffset(pathMetrics1.length * progress1);
    if (tangent1 != null) canvas.drawCircle(tangent1.position, 3, dotPaint);

    final progress2 = (animation.value + 0.5) % 1.0;
    final pathMetrics2 = path2.computeMetrics().first;
    final tangent2 = pathMetrics2.getTangentForOffset(pathMetrics2.length * progress2);
    if (tangent2 != null) canvas.drawCircle(tangent2.position, 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant ConnectionLinesPainter oldDelegate) => true;
}
