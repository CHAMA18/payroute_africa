import 'dart:math';
import 'package:flutter/material.dart';

/// World-class animation utilities for PayRoute
/// Provides reusable, high-performance animation components

// ============================================================================
// STAGGERED ANIMATION WRAPPER
// ============================================================================

/// Wraps a child widget with staggered fade + slide animation
class StaggeredFadeSlide extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Duration delay;
  final Offset beginOffset;
  final Curve curve;

  const StaggeredFadeSlide({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 600),
    this.delay = const Duration(milliseconds: 80),
    this.beginOffset = const Offset(0, 30),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + (delay * index),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              beginOffset.dx * (1 - value),
              beginOffset.dy * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ============================================================================
// ANIMATED SCALE ON HOVER
// ============================================================================

class AnimatedHoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTap;

  const AnimatedHoverScale({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.onTap,
  });

  @override
  State<AnimatedHoverScale> createState() => _AnimatedHoverScaleState();
}

class _AnimatedHoverScaleState extends State<AnimatedHoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? widget.scale : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}

// ============================================================================
// SHIMMER LOADING EFFECT
// ============================================================================

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF1A1F2E),
    this.highlightColor = const Color(0xFF2A3142),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

// ============================================================================
// PULSING GLOW EFFECT
// ============================================================================

class PulsingGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double minRadius;
  final double maxRadius;
  final Duration duration;

  const PulsingGlow({
    super.key,
    required this.child,
    required this.glowColor,
    this.minRadius = 10,
    this.maxRadius = 25,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
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
        final glowRadius = widget.minRadius +
            (widget.maxRadius - widget.minRadius) * _controller.value;
        final glowOpacity = 0.3 + (_controller.value * 0.4);
        
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: glowOpacity),
                blurRadius: glowRadius,
                spreadRadius: glowRadius * 0.3,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ============================================================================
// FLOATING ANIMATION
// ============================================================================

class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final double offsetY;
  final Duration duration;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.offsetY = 10,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
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
        final offset = sin(_controller.value * pi) * widget.offsetY;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ============================================================================
// ANIMATED COUNTER
// ============================================================================

class AnimatedCounter extends StatelessWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1200),
    this.style,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '$prefix$value$suffix',
          style: style,
        );
      },
    );
  }
}

// ============================================================================
// ANIMATED PROGRESS BAR
// ============================================================================

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Duration duration;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final double borderRadius;
  final bool showGlow;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.duration = const Duration(milliseconds: 800),
    this.backgroundColor = const Color(0xFF1A1F2E),
    this.progressColor = const Color(0xFFF97316),
    this.height = 8,
    this.borderRadius = 4,
    this.showGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: showGlow
                    ? [
                        BoxShadow(
                          color: progressColor.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// RIPPLE ANIMATION (Pulsing rings)
// ============================================================================

class RippleAnimation extends StatefulWidget {
  final Color color;
  final double size;
  final int rippleCount;
  final Duration duration;

  const RippleAnimation({
    super.key,
    required this.color,
    this.size = 100,
    this.rippleCount = 3,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(
              progress: _controller.value,
              color: widget.color,
              rippleCount: widget.rippleCount,
            ),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int rippleCount;

  _RipplePainter({
    required this.progress,
    required this.color,
    required this.rippleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < rippleCount; i++) {
      final rippleProgress = (progress + i / rippleCount) % 1.0;
      final radius = maxRadius * rippleProgress;
      final opacity = (1 - rippleProgress) * 0.6;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ============================================================================
// GRADIENT BORDER ANIMATION
// ============================================================================

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double borderWidth;
  final double borderRadius;
  final Duration duration;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    required this.colors,
    this.borderWidth = 2,
    this.borderRadius = 16,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              startAngle: _controller.value * 2 * pi,
              colors: [...widget.colors, widget.colors.first],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.borderWidth),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0B0E14),
                borderRadius:
                    BorderRadius.circular(widget.borderRadius - widget.borderWidth),
              ),
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// ============================================================================
// TYPEWRITER TEXT ANIMATION
// ============================================================================

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDuration;
  final Duration startDelay;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDuration = const Duration(milliseconds: 50),
    this.startDelay = Duration.zero,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    final totalDuration = widget.charDuration * widget.text.length;
    _controller = AnimationController(vsync: this, duration: totalDuration);
    
    _controller.addListener(() {
      if (!mounted) return;
      final charIndex = (_controller.value * widget.text.length).floor();
      setState(() {
        _displayText = widget.text.substring(0, charIndex.clamp(0, widget.text.length));
      });
    });
    
    // Use async method to handle the delay properly
    _startAnimation();
  }
  
  Future<void> _startAnimation() async {
    try {
      await Future.delayed(widget.startDelay);
      if (mounted) {
        await _controller.forward();
      }
    } catch (e) {
      debugPrint('TypewriterText animation error: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: widget.style,
    );
  }
}

// ============================================================================
// MORPHING BACKGROUND
// ============================================================================

class MorphingBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Widget? child;

  const MorphingBackground({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 8),
    this.child,
  });

  @override
  State<MorphingBackground> createState() => _MorphingBackgroundState();
}

class _MorphingBackgroundState extends State<MorphingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
          painter: _MorphingBackgroundPainter(
            colors: widget.colors,
            animation: _controller.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _MorphingBackgroundPainter extends CustomPainter {
  final List<Color> colors;
  final double animation;

  _MorphingBackgroundPainter({
    required this.colors,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < colors.length; i++) {
      final offset = animation * 2 * pi + i * (pi / colors.length);
      final x = size.width * (0.3 + 0.4 * sin(offset));
      final y = size.height * (0.3 + 0.4 * cos(offset * 0.7));
      final radius = size.width * (0.3 + 0.1 * sin(offset * 2));

      paint.shader = RadialGradient(
        colors: [
          colors[i].withValues(alpha: 0.3),
          colors[i].withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MorphingBackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

// ============================================================================
// PARTICLE FIELD BACKGROUND
// ============================================================================

class ParticleField extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double maxSpeed;
  final double maxSize;
  final bool showConnections;
  final double connectionDistance;

  const ParticleField({
    super.key,
    this.particleCount = 50,
    this.particleColor = const Color(0xFF22D3EE),
    this.maxSpeed = 0.5,
    this.maxSize = 3,
    this.showConnections = true,
    this.connectionDistance = 100,
  });

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ParticleData> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_ParticleData(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        vx: (_random.nextDouble() - 0.5) * widget.maxSpeed,
        vy: (_random.nextDouble() - 0.5) * widget.maxSpeed,
        size: _random.nextDouble() * widget.maxSize + 1,
        opacity: _random.nextDouble() * 0.5 + 0.3,
      ));
    }
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
        // Update particles
        for (final p in _particles) {
          p.x += p.vx * 0.01;
          p.y += p.vy * 0.01;
          if (p.x < 0 || p.x > 1) p.vx *= -1;
          if (p.y < 0 || p.y > 1) p.vy *= -1;
          p.x = p.x.clamp(0.0, 1.0);
          p.y = p.y.clamp(0.0, 1.0);
        }

        return CustomPaint(
          painter: _ParticleFieldPainter(
            particles: _particles,
            color: widget.particleColor,
            showConnections: widget.showConnections,
            connectionDistance: widget.connectionDistance,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ParticleData {
  double x, y, vx, vy, size, opacity;
  _ParticleData({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.opacity,
  });
}

class _ParticleFieldPainter extends CustomPainter {
  final List<_ParticleData> particles;
  final Color color;
  final bool showConnections;
  final double connectionDistance;

  _ParticleFieldPainter({
    required this.particles,
    required this.color,
    required this.showConnections,
    required this.connectionDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final positions = <Offset>[];

    for (final p in particles) {
      final pos = Offset(p.x * size.width, p.y * size.height);
      positions.add(pos);

      // Draw glow
      paint.color = color.withValues(alpha: p.opacity * 0.3);
      canvas.drawCircle(pos, p.size * 3, paint);

      // Draw core
      paint.color = color.withValues(alpha: p.opacity);
      canvas.drawCircle(pos, p.size, paint);
    }

    // Draw connections
    if (showConnections) {
      for (int i = 0; i < positions.length; i++) {
        for (int j = i + 1; j < positions.length; j++) {
          final dist = (positions[i] - positions[j]).distance;
          if (dist < connectionDistance) {
            final opacity = (1 - dist / connectionDistance) * 0.2;
            linePaint.color = color.withValues(alpha: opacity);
            canvas.drawLine(positions[i], positions[j], linePaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ParticleFieldPainter oldDelegate) => true;
}

// ============================================================================
// PAGE TRANSITION HELPERS
// ============================================================================

class FadeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Offset beginOffset;

  const FadeSlideTransition({
    super.key,
    required this.animation,
    required this.child,
    this.beginOffset = const Offset(0, 0.1),
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      ),
    );
  }
}

/// Custom page route with fade + slide transition
class AnimatedPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AnimatedPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeSlideTransition(
              animation: animation,
              child: child,
            );
          },
        );
}
