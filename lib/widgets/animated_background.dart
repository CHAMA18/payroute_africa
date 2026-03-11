import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';

/// Premium animated background with floating orbs and mesh grid
class AnimatedMeshBackground extends StatefulWidget {
  final Brightness brightness;
  final Widget child;
  final bool showGrid;
  final bool showOrbs;
  final bool showParticles;

  const AnimatedMeshBackground({
    super.key,
    required this.brightness,
    required this.child,
    this.showGrid = true,
    this.showOrbs = true,
    this.showParticles = true,
  });

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _gridController;
  late AnimationController _particleController;

  final List<_FloatingOrb> _orbs = [];
  final List<_MeshParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Initialize orbs
    _orbs.addAll([
      _FloatingOrb(
        x: 0.1,
        y: 0.2,
        radius: 180,
        color: PayRouteColors.vibrantOrange,
        speed: 0.3,
      ),
      _FloatingOrb(
        x: 0.85,
        y: 0.15,
        radius: 220,
        color: PayRouteColors.electricGlow,
        speed: 0.25,
      ),
      _FloatingOrb(
        x: 0.6,
        y: 0.75,
        radius: 160,
        color: const Color(0xFF8B5CF6),
        speed: 0.35,
      ),
    ]);

    // Initialize particles
    for (int i = 0; i < 40; i++) {
      _particles.add(_MeshParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.4 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _orbController.dispose();
    _gridController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.brightness == Brightness.dark;
    if (!isDark) {
      return widget.child;
    }

    return Stack(
      children: [
        // Orbs layer
        if (widget.showOrbs)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _OrbsPainter(
                    orbs: _orbs,
                    animation: _orbController.value,
                  ),
                );
              },
            ),
          ),

        // Mesh grid layer
        if (widget.showGrid)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _MeshGridPainter(
                    animation: _gridController.value,
                    color: PayRouteColors.electricGlow.withValues(alpha: 0.03),
                  ),
                );
              },
            ),
          ),

        // Particles layer
        if (widget.showParticles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _MeshParticlesPainter(
                    particles: _particles,
                    animation: _particleController.value,
                    color: PayRouteColors.electricGlow,
                  ),
                );
              },
            ),
          ),

        // Vignette
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),

        // Child content
        widget.child,
      ],
    );
  }
}

class _FloatingOrb {
  double x, y, radius, speed;
  Color color;

  _FloatingOrb({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    required this.speed,
  });
}

class _MeshParticle {
  double x, y, size, speed, opacity;

  _MeshParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _OrbsPainter extends CustomPainter {
  final List<_FloatingOrb> orbs;
  final double animation;

  _OrbsPainter({required this.orbs, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      final offset = animation * 2 * pi * orb.speed;
      final x = size.width * orb.x + sin(offset) * 40;
      final y = size.height * orb.y + cos(offset * 0.7) * 30;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: 0.15),
            orb.color.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: orb.radius));

      canvas.drawCircle(Offset(x, y), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbsPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

class _MeshGridPainter extends CustomPainter {
  final double animation;
  final Color color;

  _MeshGridPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 60.0;
    final waveOffset = animation * 2 * pi;

    // Horizontal lines with wave
    for (double y = 0; y < size.height; y += gridSize) {
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += 10) {
        final wave = sin(waveOffset + x / 100 + y / 150) * 3;
        path.lineTo(x, y + wave);
      }

      final distFromCenter = (y - size.height / 2).abs() / (size.height / 2);
      paint.color = color.withValues(alpha: (0.05 * (1 - distFromCenter * 0.5)).clamp(0.0, 0.1));
      canvas.drawPath(path, paint);
    }

    // Vertical lines with wave
    for (double x = 0; x < size.width; x += gridSize) {
      final path = Path();
      path.moveTo(x, 0);

      for (double y = 0; y <= size.height; y += 10) {
        final wave = sin(waveOffset + y / 100 + x / 150) * 3;
        path.lineTo(x + wave, y);
      }

      final distFromCenter = (x - size.width / 2).abs() / (size.width / 2);
      paint.color = color.withValues(alpha: (0.04 * (1 - distFromCenter * 0.6)).clamp(0.0, 0.08));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_MeshGridPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

class _MeshParticlesPainter extends CustomPainter {
  final List<_MeshParticle> particles;
  final double animation;
  final Color color;

  _MeshParticlesPainter({
    required this.particles,
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.3
      ..style = PaintingStyle.stroke;

    final positions = <Offset>[];

    for (final p in particles) {
      final offset = animation * 2 * pi * p.speed;
      final x = (p.x + sin(offset + p.y * 10) * 0.05) % 1.0;
      final y = (p.y + cos(offset + p.x * 10) * 0.05) % 1.0;

      final pos = Offset(x * size.width, y * size.height);
      positions.add(pos);

      // Glow
      paint.color = color.withValues(alpha: p.opacity * 0.3);
      canvas.drawCircle(pos, p.size * 2.5, paint);

      // Core
      paint.color = Colors.white.withValues(alpha: p.opacity);
      canvas.drawCircle(pos, p.size, paint);
    }

    // Connections
    const connectionDistance = 80.0;
    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final dist = (positions[i] - positions[j]).distance;
        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.1;
          linePaint.color = color.withValues(alpha: opacity);
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_MeshParticlesPainter oldDelegate) =>
      oldDelegate.animation != animation;
}

/// Animated status indicator with pulsing effect
class AnimatedStatusIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final bool isActive;

  const AnimatedStatusIndicator({
    super.key,
    required this.color,
    this.size = 10,
    this.isActive = true,
  });

  @override
  State<AnimatedStatusIndicator> createState() => _AnimatedStatusIndicatorState();
}

class _AnimatedStatusIndicatorState extends State<AnimatedStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
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
        final glowRadius = 4 + _controller.value * 8;
        final glowOpacity = 0.4 + _controller.value * 0.4;

        return Container(
          width: widget.size + glowRadius * 2,
          height: widget.size + glowRadius * 2,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: widget.size + glowRadius,
                height: widget.size + glowRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: glowOpacity * 0.3),
                ),
              ),
              // Core
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: glowOpacity),
                      blurRadius: glowRadius,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Animated number display with counting animation
class AnimatedNumberDisplay extends StatefulWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final int decimals;

  const AnimatedNumberDisplay({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.decimals = 0,
  });

  @override
  State<AnimatedNumberDisplay> createState() => _AnimatedNumberDisplayState();
}

class _AnimatedNumberDisplayState extends State<AnimatedNumberDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumberDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animation = Tween<double>(begin: _previousValue, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
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
      animation: _animation,
      builder: (context, child) {
        final displayValue = widget.decimals > 0
            ? _animation.value.toStringAsFixed(widget.decimals)
            : _animation.value.toInt().toString();
        return Text(
          '${widget.prefix}$displayValue${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

/// Animated card entrance with staggered fade and slide
class AnimatedCardEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Duration staggerDelay;
  final Offset slideOffset;
  final Curve curve;

  const AnimatedCardEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 600),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.slideOffset = const Offset(0, 30),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedCardEntrance> createState() => _AnimatedCardEntranceState();
}

class _AnimatedCardEntranceState extends State<AnimatedCardEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    Future.delayed(widget.staggerDelay * widget.index, () {
      if (mounted) _controller.forward();
    });
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
