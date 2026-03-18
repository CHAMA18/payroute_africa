import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/support_chat_widget.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _particleController;
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050810),
      body: Stack(
        children: [
          // Animated background particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) => CustomPaint(
                painter: _CelebrationParticlesPainter(
                  progress: _particleController.value,
                ),
              ),
            ),
          ),
          
          // Glowing radial gradient background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final pulseValue = 0.15 + (_pulseController.value * 0.1);
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        PayRouteColors.fintechNoirPrimary.withValues(alpha: pulseValue),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated success icon
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: _SuccessIcon(pulseController: _pulseController),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Congratulations text
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      PayRouteColors.fintechNoirPrimary,
                                      PayRouteColors.fintechNoirPrimaryLight,
                                      Colors.white,
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Congratulations!',
                                    style: context.textStyles.displaySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'You have successfully set up your account!',
                                  style: context.textStyles.titleLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Success details card
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 1.2),
                            child: const _SuccessDetailsCard(),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Continue button
                        Opacity(
                          opacity: _fadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 1.5),
                            child: _ContinueButton(onPressed: _goToDashboard),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          
          // Corner logo
          const _CornerLogo(),
          // AI Chat Widget
          const Positioned(
            right: 20,
            bottom: 20,
            child: SupportChatWidget(),
          ),
        ],
      ),
    );
  }
}

class _SuccessIcon extends StatefulWidget {
  final AnimationController pulseController;
  
  const _SuccessIcon({required this.pulseController});

  @override
  State<_SuccessIcon> createState() => _SuccessIconState();
}

class _SuccessIconState extends State<_SuccessIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.pulseController, _rippleController]),
      builder: (context, child) {
        final glowIntensity = 0.3 + (widget.pulseController.value * 0.3);
        final ripple = _rippleController.value;
        
        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple rings
              for (int i = 0; i < 3; i++)
                Builder(builder: (context) {
                  final ringProgress = (ripple + i * 0.33) % 1.0;
                  final ringScale = 1.0 + ringProgress * 0.6;
                  final ringOpacity = (1 - ringProgress) * 0.4;
                  
                  return Transform.scale(
                    scale: ringScale,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: PayRouteColors.fintechNoirPrimary.withValues(alpha: ringOpacity),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
              
              // Main icon container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      PayRouteColors.fintechNoirPrimary,
                      PayRouteColors.fintechNoirPrimaryLight,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PayRouteColors.fintechNoirPrimary.withValues(alpha: glowIntensity),
                      blurRadius: 60,
                      spreadRadius: 20,
                    ),
                    BoxShadow(
                      color: PayRouteColors.fintechNoirPrimaryLight.withValues(alpha: glowIntensity * 0.5),
                      blurRadius: 100,
                      spreadRadius: 30,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Inner glow ring
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3 + widget.pulseController.value * 0.2),
                          width: 2,
                        ),
                      ),
                    ),
                    // Check icon with scale animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF050810),
                            size: 70,
                          ),
                        );
                      },
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

class _SuccessDetailsCard extends StatelessWidget {
  const _SuccessDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.verified_user_outlined,
            label: 'Account Status',
            value: 'Verified',
            valueColor: PayRouteColors.fintechNoirPrimary,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.access_time_rounded,
            label: 'Application Review',
            value: 'Complete',
            valueColor: Colors.greenAccent,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.shield_outlined,
            label: 'Security Level',
            value: 'Bank-Grade',
            valueColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: context.textStyles.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        Text(
          value,
          style: context.textStyles.bodyMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 280,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.fintechNoirPrimary,
                PayRouteColors.fintechNoirPrimaryLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.fintechNoirPrimary.withValues(alpha: _isHovered ? 0.5 : 0.3),
                blurRadius: _isHovered ? 35 : 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Go to Dashboard',
                style: context.textStyles.titleMedium?.copyWith(
                  color: const Color(0xFF050810),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF050810),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CelebrationParticlesPainter extends CustomPainter {
  final double progress;
  final Random _random = Random(42);

  _CelebrationParticlesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final particleCount = 80;
    
    // Floating particles
    for (int i = 0; i < particleCount; i++) {
      final seed = _random.nextDouble();
      final x = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;
      final y = (baseY + progress * size.height * (0.5 + seed * 0.5)) % size.height;
      
      final particleProgress = (progress + seed) % 1.0;
      final alpha = (0.3 + sin(particleProgress * 3.14159) * 0.4) * 0.6;
      
      final radius = 2.0 + _random.nextDouble() * 3.0;
      
      final colorChoice = i % 5;
      Color color;
      switch (colorChoice) {
        case 0:
          color = PayRouteColors.fintechNoirPrimary.withValues(alpha: alpha);
          break;
        case 1:
          color = PayRouteColors.fintechNoirPrimaryLight.withValues(alpha: alpha);
          break;
        case 2:
          color = const Color(0xFF22C55E).withValues(alpha: alpha);
          break;
        case 3:
          color = const Color(0xFF3B82F6).withValues(alpha: alpha);
          break;
        default:
          color = Colors.white.withValues(alpha: alpha * 0.5);
      }
      
      final paint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    
    // Confetti streaks
    final confettiPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 30; i++) {
      final seed = _random.nextDouble();
      final confettiX = ((_random.nextDouble() * size.width) + sin((progress + seed) * pi * 4) * 20) % size.width;
      final confettiY = ((progress * 2 + seed) * size.height) % size.height;
      final rotation = (progress + seed) * pi * 4;
      
      final confettiAlpha = (1 - (confettiY / size.height)) * 0.8;
      final colorIndex = i % 4;
      
      Color confettiColor;
      switch (colorIndex) {
        case 0:
          confettiColor = PayRouteColors.fintechNoirPrimary;
          break;
        case 1:
          confettiColor = PayRouteColors.fintechNoirPrimaryLight;
          break;
        case 2:
          confettiColor = const Color(0xFF22C55E);
          break;
        default:
          confettiColor = const Color(0xFF3B82F6);
      }
      
      confettiPaint.color = confettiColor.withValues(alpha: confettiAlpha.clamp(0.0, 0.8));
      
      canvas.save();
      canvas.translate(confettiX, confettiY);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-4, -1, 8, 2),
          const Radius.circular(1),
        ),
        confettiPaint,
      );
      canvas.restore();
    }
    
    // Sparkle stars
    final starPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 15; i++) {
      final seed = _random.nextDouble();
      final starX = _random.nextDouble() * size.width;
      final starY = _random.nextDouble() * size.height;
      final twinkle = sin((progress * 4 + seed * pi * 2)) * 0.5 + 0.5;
      
      starPaint.color = Colors.white.withValues(alpha: twinkle * 0.8);
      
      // Draw 4-point star
      final starSize = 3.0 + twinkle * 3;
      final path = Path();
      path.moveTo(starX, starY - starSize);
      path.lineTo(starX + starSize * 0.3, starY);
      path.lineTo(starX, starY + starSize);
      path.lineTo(starX - starSize * 0.3, starY);
      path.close();
      path.moveTo(starX - starSize, starY);
      path.lineTo(starX, starY + starSize * 0.3);
      path.lineTo(starX + starSize, starY);
      path.lineTo(starX, starY - starSize * 0.3);
      path.close();
      
      canvas.drawPath(path, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _CornerLogo extends StatelessWidget {
  const _CornerLogo();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: 24,
      child: Opacity(
        opacity: 0.4,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Image.asset(
            'assets/images/Dynamic_Logo_for_PayRoute_Africa_1.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
