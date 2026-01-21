import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/hero_theme_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _breatheController;
  late AnimationController _scanController;
  late AnimationController _twinkleController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _breatheController.dispose();
    _scanController.dispose();
    _twinkleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(context),
                      const SizedBox(height: 40),
                      _buildGlassPanel(context),
                      const SizedBox(height: 32),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        HeroThemeBackground(
          linesAnimation: _scanController,
          breathe: _breatheController,
          mapAlignment: Alignment.centerRight,
          mapBaseScale: 0.82,
          mapBaseOpacity: 0.9,
        ),

        // Floating twinkling nodes
        AnimatedBuilder(
          animation: Listenable.merge([_twinkleController, _floatController]),
          builder: (context, child) {
            return Stack(
              children: [
                _buildTwinklingNode(
                  top: 0.35,
                  left: 0.45,
                  size: 6,
                  delay: 0,
                ),
                _buildTwinklingNode(
                  top: 0.42,
                  left: 0.58,
                  size: 4,
                  delay: 0.375,
                ),
                _buildTwinklingNode(
                  top: 0.55,
                  left: 0.40,
                  size: 8,
                  delay: 0.125,
                ),
                _buildTwinklingNode(
                  top: 0.28,
                  left: 0.52,
                  size: 4,
                  delay: 0.55,
                ),
                _buildTwinklingNode(
                  top: 0.60,
                  left: 0.65,
                  size: 6,
                  delay: 0.75,
                ),
              ],
            );
          },
        ),

        // Vignette overlay for readability
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.55),
                Colors.black,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwinklingNode({
    required double top,
    required double left,
    required double size,
    required double delay,
  }) {
    final twinkleValue = ((_twinkleController.value + delay) % 1.0);
    final twinkleScale = 0.8 + (sin(twinkleValue * pi) * 0.7);
    final twinkleOpacity = 0.2 + (sin(twinkleValue * pi) * 0.8);
    
    final floatOffset = sin((_floatController.value + delay) * pi * 2);
    
    return Positioned(
      top: MediaQuery.of(context).size.height * top + (floatOffset * 5),
      left: MediaQuery.of(context).size.width * left + (floatOffset * 3),
      child: Transform.scale(
        scale: twinkleScale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: PayRouteColors.electricGlow.withValues(alpha: twinkleOpacity),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.electricGlow.withValues(alpha: twinkleOpacity * 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Logo icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.vibrantOrange,
                PayRouteColors.vibrantOrangeDark,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
                blurRadius: 50,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: PayRouteColors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.hub,
                  size: 32,
                  color: PayRouteColors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      PayRouteColors.white.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Title
        Text(
          'PayRoute',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: PayRouteColors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Secure Gateway badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    PayRouteColors.electricBlue.withValues(alpha: 0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: PayRouteColors.electricBlue.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'SECURE GATEWAY',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PayRouteColors.electricGlow,
                  letterSpacing: 3,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: PayRouteColors.electricGlow.withValues(alpha: 0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 32,
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PayRouteColors.electricBlue.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: PayRouteColors.electricBlue.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0f172a).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: PayRouteColors.white.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Top highlight line
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      PayRouteColors.electricBlue.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Form content
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputField(
                    context,
                    label: 'EMAIL / PHONE',
                    icon: Icons.person_outline,
                    placeholder: 'Enter identifier',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    context,
                    label: 'PASSWORD',
                    icon: Icons.lock_outline,
                    placeholder: '••••••••',
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 28),
                  _buildLoginButton(context),
                  const SizedBox(height: 32),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot Credentials?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PayRouteColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCreateAccountButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String placeholder,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF94a3b8),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: PayRouteColors.noirBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: PayRouteColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && _obscurePassword,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: isPassword && _obscurePassword ? 3 : 0.5,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748b),
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF64748b),
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF475569),
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: PayRouteColors.vibrantOrange.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF7c2d12).withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: PayRouteColors.vibrantOrange,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => context.go(AppRoutes.dashboard),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PayRouteColors.white,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: PayRouteColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PayRouteColors.white.withValues(alpha: 0.05),
        ),
        color: PayRouteColors.white.withValues(alpha: 0.05),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(AppRoutes.createAccount),
          borderRadius: BorderRadius.circular(12),
          hoverColor: PayRouteColors.white.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New User Registration',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PayRouteColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.person_add_outlined,
                  size: 16,
                  color: const Color(0xFF64748b),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 14,
            color: PayRouteColors.electricGlow,
          ),
          const SizedBox(width: 8),
          Text(
            'END-TO-END ENCRYPTED',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF94a3b8),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
