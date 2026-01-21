import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_theme_background.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onGetStarted;

  const HeroSection({super.key, required this.onGetStarted});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _pulseController1;
  late AnimationController _pulseController2;
  late AnimationController _pulseController3;
  late AnimationController _pulseController4;
  late AnimationController _lineAnimationController;
  late AnimationController _contentAnimationController;
  late AnimationController _arrowBounceController;

  late Animation<double> _badgeFade;
  late Animation<double> _headlineFade;
  late Animation<Offset> _headlineSlide;
  late Animation<double> _descFade;
  late Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();
    _pulseController1 = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseController2 = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseController3 = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseController4 = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _lineAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    
    // Content entrance animation
    _contentAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    
    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: const Interval(0, 0.3, curve: Curves.easeOut)),
    );
    _headlineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: const Interval(0.15, 0.5, curve: Curves.easeOut)),
    );
    _headlineSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic)),
    );
    _descFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: const Interval(0.4, 0.7, curve: Curves.easeOut)),
    );
    _ctaFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: const Interval(0.55, 0.85, curve: Curves.easeOut)),
    );
    
    // Bouncing arrow animation
    _arrowBounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _pulseController2.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _pulseController3.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _pulseController4.forward();
    });
    
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _pulseController1.dispose();
    _pulseController2.dispose();
    _pulseController3.dispose();
    _pulseController4.dispose();
    _lineAnimationController.dispose();
    _contentAnimationController.dispose();
    _arrowBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 480;
    final isMedium = screenWidth < 800;
    
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HeroThemeBackground(linesAnimation: _lineAnimationController),
          // Pulsing cyan nodes with labels
          _buildPulsingNodeWithLabel(top: 0.35, left: 0.28, size: 12, controller: _pulseController1, label: 'LAGOS_HUB_01', labelOnRight: true),
          _buildPulsingNodeWithLabel(top: 0.42, right: 0.18, size: 10, controller: _pulseController2),
          _buildPulsingNodeWithLabel(top: 0.22, right: 0.28, size: 8, controller: _pulseController3, isElectricBlue: true),
          // South Africa (Johannesburg) hub node
          _buildPulsingNodeWithLabel(bottom: 0.30, right: 0.28, size: 12, controller: _pulseController4, label: 'JHB_CORE', labelOnRight: false),
          // Navigation bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(isSmall ? 16 : 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.2)),
                            boxShadow: [BoxShadow(color: PayRouteColors.white.withValues(alpha: 0.15), blurRadius: 20)],
                          ),
                          child: const Icon(Icons.hub, color: PayRouteColors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text('PayRoute', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    // Join button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.2)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 15)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onGetStarted,
                            hoverColor: PayRouteColors.white.withValues(alpha: 0.1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: isSmall ? 16 : 24, vertical: 10),
                              child: Text(
                                isSmall ? 'JOIN' : 'JOIN',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: PayRouteColors.white, letterSpacing: isSmall ? 2.2 : 3, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main centered content - moved upward
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 40),
                child: Column(
                  children: [
                    const SizedBox(height: 100), // Space for nav
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _contentAnimationController,
                        builder: (context, child) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge with cyan theme
                            FadeTransition(
                              opacity: _badgeFade,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: PayRouteColors.electricBlue.withValues(alpha: 0.3)),
                                  boxShadow: [BoxShadow(color: PayRouteColors.electricBlue.withValues(alpha: 0.15), blurRadius: 20)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Pulsing indicator
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        AnimatedBuilder(
                                          animation: _pulseController1,
                                          builder: (context, child) => Container(
                                            width: 8 + _pulseController1.value * 4,
                                            height: 8 + _pulseController1.value * 4,
                                            decoration: BoxDecoration(
                                              color: PayRouteColors.electricBlue.withValues(alpha: 0.75 - _pulseController1.value * 0.75),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(color: PayRouteColors.electricBlue, borderRadius: BorderRadius.circular(4)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'NEURAL NET ACTIVE',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: PayRouteColors.electricBlue, letterSpacing: 3, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Headline with slide-up animation
                            SlideTransition(
                              position: _headlineSlide,
                              child: FadeTransition(
                                opacity: _headlineFade,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: isSmall ? screenWidth : screenWidth * 0.65),
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: PayRouteColors.white,
                                        fontWeight: FontWeight.w800,
                                        height: 1.05,
                                        fontSize: screenWidth > 800
                                            ? 72
                                            : isSmall
                                                ? 38
                                                : isMedium
                                                    ? 44
                                                    : 48,
                                        letterSpacing: -1,
                                        shadows: [Shadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 16, offset: const Offset(0, 6))],
                                      ),
                                      children: [
                                        const TextSpan(text: 'Empowering\nthe African '),
                                        TextSpan(
                                          text: 'Economy.',
                                          style: TextStyle(
                                            foreground: Paint()
                                              ..shader = const LinearGradient(
                                                colors: [PayRouteColors.electricBlue, Color(0xFF9FFFEF), Colors.white],
                                              ).createShader(const Rect.fromLTWH(0, 0, 350, 80)),
                                            shadows: [
                                              Shadow(color: PayRouteColors.electricBlue.withValues(alpha: 0.6), blurRadius: 20),
                                              Shadow(color: PayRouteColors.electricBlue.withValues(alpha: 0.3), blurRadius: 40),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Description
                            FadeTransition(
                              opacity: _descFade,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(left: BorderSide(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.6), width: 3)),
                                ),
                                padding: const EdgeInsets.only(left: 20),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 420),
                                  child: Text(
                                    'High-definition payment routing infrastructure. Crisp, instant, and borderless for the next generation.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFFD1D5DB),
                                      fontWeight: FontWeight.w500,
                                      height: 1.7,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // CTA Buttons
                            FadeTransition(
                              opacity: _ctaFade,
                              child: Row(
                                children: [
                                  // Get Started button
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.5), blurRadius: 50, spreadRadius: 2)],
                                      border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.2)),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: widget.onGetStarted,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: PayRouteColors.vibrantOrange,
                                        foregroundColor: PayRouteColors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Get Started', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.arrow_forward, size: 20, color: PayRouteColors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Play button
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: PayRouteColors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.2)),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {},
                                        hoverColor: PayRouteColors.white.withValues(alpha: 0.1),
                                        child: const Center(child: Icon(Icons.play_arrow, color: PayRouteColors.white, size: 24)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Scroll down indicator with bouncing arrow
                    AnimatedBuilder(
                      animation: _arrowBounceController,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _arrowBounceController.value * 12),
                        child: Opacity(
                          opacity: 0.7 + _arrowBounceController.value * 0.3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'SCROLL TO EXPLORE',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: PayRouteColors.electricBlue.withValues(alpha: 0.8),
                                  letterSpacing: 4,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: 36,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: PayRouteColors.electricBlue.withValues(alpha: 0.4), width: 1.5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: PayRouteColors.electricBlue,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: PayRouteColors.electricBlue.withValues(alpha: 0.8),
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          // Bottom gradient fade
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.9)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingNodeWithLabel({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required AnimationController controller,
    String? label,
    bool labelOnRight = true,
    bool isElectricBlue = false,
  }) {
    final nodeColor = isElectricBlue ? PayRouteColors.electricBlue : Colors.white;
    final glowColor = PayRouteColors.electricBlue;
    
    return Positioned(
      top: top != null ? MediaQuery.of(context).size.height * top : null,
      bottom: bottom != null ? MediaQuery.of(context).size.height * bottom : null,
      left: left != null ? MediaQuery.of(context).size.width * left : null,
      right: right != null ? MediaQuery.of(context).size.width * right : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null && !labelOnRight)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: PayRouteColors.electricBlue.withValues(alpha: 0.5)),
              ),
              child: Text(label, style: const TextStyle(color: PayRouteColors.electricBlue, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w500)),
            ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: nodeColor,
                borderRadius: BorderRadius.circular(size / 2),
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.7 + controller.value * 0.3),
                    blurRadius: 15 + controller.value * 10,
                    spreadRadius: controller.value * 5,
                  ),
                ],
              ),
            ),
          ),
          if (label != null && labelOnRight)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: PayRouteColors.electricBlue.withValues(alpha: 0.5)),
              ),
              child: Text(label, style: const TextStyle(color: PayRouteColors.electricBlue, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.w500)),
            ),
        ],
      ),
    );
  }
}

// Painters moved to `HeroThemeBackground` for reuse across entry screens.
