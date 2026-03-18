import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/support_chat_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _pulseController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _HeroSection(
                pulseController: _pulseController,
                glowController: _glowController,
              ),
              const _ReliabilitySection(),
              const _CostSavingsSection(),
              const _GlobalReachSection(),
            ],
          ),
          // Page indicators
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (index) {
                  final isActive = _currentPage == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: 6,
                    height: isActive ? 24 : 6,
                    decoration: BoxDecoration(
                      color: isActive 
                          ? PayRouteColors.vibrantOrange 
                          : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: PayRouteColors.vibrantOrange.withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ] : null,
                    ),
                  );
                }),
              ),
            ),
          ),
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

class _HeroSection extends StatelessWidget {
  final AnimationController pulseController;
  final AnimationController glowController;
  
  const _HeroSection({
    required this.pulseController,
    required this.glowController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 800;
    
    return Container(
      color: const Color(0xFF0A0A0A),
      child: Stack(
        children: [
          // Base dark background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0A0A0A),
            ),
          ),
          
          // Africa map - responsive positioning
          Positioned(
            top: isWide ? -size.height * 0.1 : 0,
            right: isWide ? -size.width * 0.05 : -size.width * 0.3,
            bottom: isWide ? -size.height * 0.1 : size.height * 0.2,
            width: isWide ? size.width * 0.85 : size.width * 1.4,
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/Africa_continent_map_outline_silhouette_black_1769371561752.jpg',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          

          
          // Left side gradient for content readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF0A0A0A).withValues(alpha: 0.95),
                    const Color(0xFF0A0A0A).withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                  stops: [0.0, isWide ? 0.25 : 0.15, isWide ? 0.45 : 0.35, isWide ? 0.7 : 0.6],
                ),
              ),
            ),
          ),
          
          // Bottom gradient fade
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xFF0A0A0A).withValues(alpha: 0.8),
                    const Color(0xFF0A0A0A),
                  ],
                  stops: const [0.0, 0.6, 0.85, 1.0],
                ),
              ),
            ),
          ),
          
          // Animated glowing dots for cities - orange theme
          _AnimatedCityDot(
            left: isWide ? size.width * 0.38 : size.width * 0.25,
            top: size.height * 0.38,
            label: 'LAGOS_HUB_01',
            showLabel: true,
            pulseController: pulseController,
            color: PayRouteColors.vibrantOrange,
          ),
          _AnimatedCityDot(
            right: isWide ? size.width * 0.25 : size.width * 0.15,
            top: size.height * 0.32,
            pulseController: pulseController,
            color: PayRouteColors.vibrantOrange,
          ),
          _AnimatedCityDot(
            right: isWide ? size.width * 0.32 : size.width * 0.22,
            top: size.height * 0.18,
            size: 8,
            pulseController: pulseController,
            color: PayRouteColors.vibrantOrange,
          ),
          _AnimatedCityDot(
            right: isWide ? size.width * 0.28 : size.width * 0.2,
            bottom: size.height * 0.35,
            label: 'JHB_CORE',
            labelOnRight: false,
            showLabel: true,
            pulseController: pulseController,
            color: PayRouteColors.vibrantOrange,
          ),
          
          // Navigation bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 48 : 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/Dynamic.png',
                    height: isWide ? 160 : 128,
                    fit: BoxFit.contain,
                  ),
                  // Join button
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.selectAccountType),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom content - responsive layout
          Positioned(
            left: 0,
            right: isWide ? null : 0,
            bottom: 0,
            child: Container(
              width: isWide ? size.width * 0.5 : null,
              padding: EdgeInsets.fromLTRB(isWide ? 48 : 32, 0, isWide ? 48 : 32, isWide ? 64 : 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Neural Net Active badge - now orange themed
                  AnimatedBuilder(
                    animation: pulseController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: PayRouteColors.vibrantOrange,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(
                                      249, 115, 22, 
                                      0.6 + pulseController.value * 0.4,
                                    ),
                                    blurRadius: 10 + pulseController.value * 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Neural Net Active',
                              style: TextStyle(
                                color: PayRouteColors.vibrantOrange,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  
                  // Main headline - responsive font size
                  Text(
                    'Empowering the',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWide ? 56 : 42,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Text(
                    'African',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWide ? 56 : 42,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      letterSpacing: -1.5,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [PayRouteColors.vibrantOrange, Color(0xFFFFB366)],
                    ).createShader(bounds),
                    child: Text(
                      'Economy.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWide ? 56 : 42,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  // Subtext
                  Container(
                    padding: const EdgeInsets.only(left: 18),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: PayRouteColors.vibrantOrange.withValues(alpha: 0.8),
                          width: 3,
                        ),
                      ),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 420 : 340),
                      child: Text(
                        'High-definition payment routing infrastructure. Crisp, instant, and borderless for the next generation.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: isWide ? 17 : 15,
                          fontWeight: FontWeight.w400,
                          height: 1.7,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 44),
                  
                  // CTA buttons
                  Row(
                    children: [
                      // Get Started button - enhanced glow
                      AnimatedBuilder(
                        animation: pulseController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    249, 115, 22, 
                                    0.3 + pulseController.value * 0.15,
                                  ),
                                  blurRadius: 40 + pulseController.value * 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: FilledButton(
                              onPressed: () => context.go(AppRoutes.login),
                              style: FilledButton.styleFrom(
                                backgroundColor: PayRouteColors.vibrantOrange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 22),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Get Started',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 18),
                      // Play button
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isWide ? 0 : 20),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class _AnimatedCityDot extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final String? label;
  final bool showLabel;
  final bool labelOnRight;
  final double size;
  final AnimationController pulseController;
  final Color color;
  
  const _AnimatedCityDot({
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.label,
    this.showLabel = false,
    this.labelOnRight = true,
    this.size = 12,
    required this.pulseController,
    this.color = PayRouteColors.vibrantOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLabel && !labelOnRight && label != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(
                        (255 * (0.8 + pulseController.value * 0.2)).toInt(),
                        (color.r * 255).toInt(),
                        (color.g * 255).toInt(),
                        (color.b * 255).toInt(),
                      ),
                      blurRadius: 18 + pulseController.value * 12,
                      spreadRadius: 3 + pulseController.value * 4,
                    ),
                  ],
                ),
              ),
              if (showLabel && labelOnRight && label != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: color.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ReliabilitySection extends StatelessWidget {
  const _ReliabilitySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PayRouteColors.earthClay,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/abstract_data_flow_blue_1773256565430.jpg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Accent bar
                  Container(
                    width: 64,
                    height: 4,
                    color: PayRouteColors.vibrantTeal,
                  ),
                  const SizedBox(height: 32),
                  
                  // Heading
                  const Text(
                    'Unmatched',
                    style: TextStyle(
                      color: PayRouteColors.earthSand,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    'Reliability',
                    style: TextStyle(
                      color: PayRouteColors.earthSand,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: PayRouteColors.vibrantTeal,
                              size: 36,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              '99.9%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Our multi-rail system ensures that your payments never fail. If one path closes, three more open instantly.',
                          style: TextStyle(
                            color: PayRouteColors.earthSand.withValues(alpha: 0.8),
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // City names
                  Row(
                    children: [
                      Text(
                        'Lagos',
                        style: TextStyle(
                          color: PayRouteColors.earthSand.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: PayRouteColors.vibrantTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nairobi',
                        style: TextStyle(
                          color: PayRouteColors.earthSand.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: PayRouteColors.vibrantTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Accra',
                        style: TextStyle(
                          color: PayRouteColors.earthSand.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CostSavingsSection extends StatelessWidget {
  const _CostSavingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PayRouteColors.earthSand,
      child: SafeArea(
        child: Column(
          children: [
            // Top content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pioneering',
                      style: TextStyle(
                        color: PayRouteColors.earthClay,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Cost Savings',
                      style: TextStyle(
                        color: PayRouteColors.earthClay,
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aggregating FX rates across 54 markets to find you the absolute floor.',
                      style: TextStyle(
                        color: PayRouteColors.earthClay.withValues(alpha: 0.7),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Pricing card
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: PayRouteColors.earthClay.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Standard route
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Standard Route',
                                style: TextStyle(
                                  color: PayRouteColors.earthClay.withValues(alpha: 0.4),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$42.50 Fee',
                                style: TextStyle(
                                  color: PayRouteColors.earthClay.withValues(alpha: 0.3),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.trending_down,
                              color: PayRouteColors.vibrantOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Divider
                      Container(
                        height: 1,
                        color: PayRouteColors.earthClay.withValues(alpha: 0.05),
                      ),
                      const SizedBox(height: 20),
                      
                      // PayRoute optimized
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PayRoute Opti',
                                style: TextStyle(
                                  color: PayRouteColors.vibrantTeal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  const Text(
                                    '\$12.80',
                                    style: TextStyle(
                                      color: PayRouteColors.earthClay,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Fee',
                                    style: TextStyle(
                                      color: PayRouteColors.vibrantTeal,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: PayRouteColors.vibrantTeal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'SAVED 68%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // CTA button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: PayRouteColors.earthClay,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Saving Now',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.bolt, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalReachSection extends StatelessWidget {
  const _GlobalReachSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PayRouteColors.earthBlack,
      child: Stack(
        children: [
          // Background map
          Positioned.fill(
            child: Transform.scale(
              scale: 1.25,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/Africa_continent_map_outline_silhouette_black_1769371561752.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1,
                              width: 32,
                              color: PayRouteColors.vibrantGold,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Instant Global Reach',
                              style: TextStyle(
                                color: PayRouteColors.vibrantGold,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 1,
                              width: 32,
                              color: PayRouteColors.vibrantGold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Headline
                        const Text(
                          'One API.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'A Whole ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: 'Continent.',
                                style: TextStyle(
                                  color: PayRouteColors.vibrantGold,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          'Connect once, settle everywhere. From M-Pesa in Kenya to GTBank in Nigeria, we\'ve unified the landscape for you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Feature cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FeatureCard(
                              icon: Icons.public,
                              iconColor: PayRouteColors.vibrantGold,
                              title: '54 Markets',
                              subtitle: 'Full coverage.',
                            ),
                            const SizedBox(width: 16),
                            _FeatureCard(
                              icon: Icons.speed,
                              iconColor: PayRouteColors.vibrantTeal,
                              title: 'Real-time',
                              subtitle: 'Instant settlements.',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Footer
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151311),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Links and social
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Links
                          Wrap(
                            spacing: 32,
                            runSpacing: 12,
                            children: [
                              _FooterLink(label: 'About Us'),
                              _FooterLink(label: 'Services'),
                              _FooterLink(label: 'Contact'),
                              _FooterLink(label: 'Privacy Policy'),
                            ],
                          ),
                          // Social icons
                          Row(
                            children: [
                              _SocialButton(icon: Icons.share),
                              const SizedBox(width: 12),
                              _SocialButton(icon: Icons.alternate_email),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      const SizedBox(height: 24),
                      
                      // Bottom row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: PayRouteColors.vibrantOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.hub,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'PAYROUTE',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          // Copyright
                          Text(
                            '© 2024 PAYROUTE INC.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  
  const _FooterLink({required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  
  const _SocialButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.grey.shade500,
        size: 18,
      ),
    );
  }
}
