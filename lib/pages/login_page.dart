import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isOrganization = false;
  String? _errorMessage;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _breatheController;
  late AnimationController _scanController;
  late AnimationController _twinkleController;
  late AnimationController _floatController;
  late AnimationController _particleController;
  late AnimationController _auroraController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  final List<_Particle> _particles = [];
  final List<_GlowOrb> _glowOrbs = [];
  final Random _random = Random();

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
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    _auroraController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    
    // Initialize particles
    for (int i = 0; i < 60; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.3 + 0.1,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        angle: _random.nextDouble() * pi * 2,
      ));
    }
    
    // Initialize glow orbs
    _glowOrbs.addAll([
      _GlowOrb(x: 0.15, y: 0.2, radius: 200, color: PayRouteColors.vibrantOrange),
      _GlowOrb(x: 0.85, y: 0.3, radius: 250, color: PayRouteColors.electricGlow),
      _GlowOrb(x: 0.5, y: 0.8, radius: 180, color: const Color(0xFF0EA5E9)),
      _GlowOrb(x: 0.2, y: 0.7, radius: 150, color: const Color(0xFF8B5CF6)),
      _GlowOrb(x: 0.8, y: 0.85, radius: 220, color: PayRouteColors.vibrantOrange),
    ]);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _breatheController.dispose();
    _scanController.dispose();
    _twinkleController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    _auroraController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Basic validation
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email or phone');
      return;
    }
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      
      // Save remember me preference before signing in
      await authProvider.setRememberMe(_rememberMe);
      
      final success = await authProvider.signIn(email, password);

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.dashboard);
      } else {
        setState(() {
          _errorMessage = authProvider.errorMessage ?? 'Login failed. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(text: _emailController.text);
    bool isSubmitting = false;
    String? dialogError;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0f172a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: PayRouteColors.white.withValues(alpha: 0.1),
            ),
          ),
          title: Text(
            'Reset Password',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: PayRouteColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PayRouteColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              if (dialogError != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          dialogError!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Container(
                decoration: BoxDecoration(
                  color: PayRouteColors.noirBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: PayRouteColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: TextField(
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PayRouteColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748b),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF64748b),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: PayRouteColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final email = resetEmailController.text.trim();
                      if (email.isEmpty) {
                        setDialogState(() => dialogError = 'Please enter your email address.');
                        return;
                      }
                      
                      setDialogState(() {
                        isSubmitting = true;
                        dialogError = null;
                      });

                      final authProvider = context.read<AuthProvider>();
                      final success = await authProvider.sendPasswordResetEmail(email);

                      if (!dialogContext.mounted) return;

                      if (success) {
                        Navigator.of(dialogContext).pop();
                        _showSuccessSnackBar('Password reset email sent! Check your inbox.');
                      } else {
                        setDialogState(() {
                          isSubmitting = false;
                          dialogError = authProvider.errorMessage ?? 'Failed to send reset email.';
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: PayRouteColors.vibrantOrange,
                foregroundColor: PayRouteColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(PayRouteColors.white),
                      ),
                    )
                  : const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
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
                      _buildHeader(context),
                      const SizedBox(height: 16),
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
        // Deep space gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0a0a0f),
                Color(0xFF0d1117),
                Color(0xFF070a0d),
              ],
            ),
          ),
        ),
        
        // Animated aurora waves
        AnimatedBuilder(
          animation: _auroraController,
          builder: (context, _) {
            return CustomPaint(
              painter: _AuroraPainter(
                animation: _auroraController.value,
                pulseAnimation: _pulseController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Animated glow orbs
        AnimatedBuilder(
          animation: Listenable.merge([_breatheController, _floatController]),
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            return Stack(
              children: _glowOrbs.map((orb) {
                final breathe = _breatheController.value;
                final float = sin((_floatController.value + orb.x) * pi * 2);
                final xOffset = float * 30;
                final yOffset = cos((_floatController.value + orb.y) * pi * 2) * 20;
                
                return Positioned(
                  left: size.width * orb.x + xOffset - orb.radius,
                  top: size.height * orb.y + yOffset - orb.radius,
                  child: Container(
                    width: orb.radius * 2,
                    height: orb.radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          orb.color.withValues(alpha: 0.15 + breathe * 0.08),
                          orb.color.withValues(alpha: 0.05 + breathe * 0.03),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        
        // Animated mesh grid
        AnimatedBuilder(
          animation: _scanController,
          builder: (context, _) {
            return CustomPaint(
              painter: _PerspectiveGridPainter(
                animation: _scanController.value,
                waveAnimation: _waveController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Floating particles with connections
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, _) {
            return CustomPaint(
              painter: _ParticleNetworkPainter(
                particles: _particles,
                animation: _particleController.value,
                pulseAnimation: _pulseController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Animated scan line
        AnimatedBuilder(
          animation: _scanController,
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            final scanY = size.height * _scanController.value;
            return Positioned(
              top: scanY - 2,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      PayRouteColors.electricGlow.withValues(alpha: 0.3),
                      PayRouteColors.electricGlow.withValues(alpha: 0.6),
                      PayRouteColors.electricGlow.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Floating twinkling stars
        AnimatedBuilder(
          animation: Listenable.merge([_twinkleController, _floatController]),
          builder: (context, child) {
            return Stack(
              children: [
                _buildTwinklingNode(top: 0.12, left: 0.08, size: 3, delay: 0),
                _buildTwinklingNode(top: 0.18, left: 0.92, size: 4, delay: 0.15),
                _buildTwinklingNode(top: 0.35, left: 0.15, size: 5, delay: 0.3),
                _buildTwinklingNode(top: 0.25, left: 0.78, size: 3, delay: 0.45),
                _buildTwinklingNode(top: 0.55, left: 0.05, size: 4, delay: 0.6),
                _buildTwinklingNode(top: 0.65, left: 0.88, size: 6, delay: 0.75),
                _buildTwinklingNode(top: 0.78, left: 0.12, size: 3, delay: 0.2),
                _buildTwinklingNode(top: 0.85, left: 0.95, size: 4, delay: 0.5),
                _buildTwinklingNode(top: 0.42, left: 0.03, size: 5, delay: 0.85),
                _buildTwinklingNode(top: 0.08, left: 0.55, size: 3, delay: 0.35),
                _buildTwinklingNode(top: 0.92, left: 0.45, size: 4, delay: 0.7),
                _buildTwinklingNode(top: 0.72, left: 0.72, size: 5, delay: 0.1),
              ],
            );
          },
        ),
        
        // Center pulse ring effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            final pulseScale = 0.8 + _pulseController.value * 0.4;
            final pulseOpacity = 0.15 - _pulseController.value * 0.1;
            
            return Center(
              child: Container(
                width: size.width * 0.6 * pulseScale,
                height: size.width * 0.6 * pulseScale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PayRouteColors.vibrantOrange.withValues(alpha: pulseOpacity.clamp(0.0, 1.0)),
                    width: 1.5,
                  ),
                ),
              ),
            );
          },
        ),

        // Vignette overlay
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.4,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.4),
                Colors.black.withValues(alpha: 0.85),
              ],
              stops: const [0.0, 0.5, 1.0],
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
    final twinkleScale = 0.5 + (sin(twinkleValue * pi) * 1.0);
    final twinkleOpacity = 0.3 + (sin(twinkleValue * pi) * 0.7);
    
    final floatOffset = sin((_floatController.value + delay) * pi * 2);
    
    return Positioned(
      top: MediaQuery.of(context).size.height * top + (floatOffset * 8),
      left: MediaQuery.of(context).size.width * left + (floatOffset * 5),
      child: Transform.scale(
        scale: twinkleScale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: twinkleOpacity),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.electricGlow.withValues(alpha: twinkleOpacity * 0.8),
                blurRadius: 15,
                spreadRadius: 3,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: twinkleOpacity * 0.5),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      width: 560,
      height: 200,
      child: Image.asset(
        'assets/images/Dynamic.png',
        fit: BoxFit.contain,
      ),
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
                  _buildAccountTypeToggle(context),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
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
                  const SizedBox(height: 16),
                  _buildRememberMeCheckbox(context),
                  const SizedBox(height: 20),
                  _buildLoginButton(context),
                  const SizedBox(height: 24),
                  _buildSocialDivider(context),
                  const SizedBox(height: 24),
                  _buildSocialButtons(context),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: _showForgotPasswordDialog,
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

  Widget _buildAccountTypeToggle(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final toggleWidth = constraints.maxWidth;
        final buttonWidth = (toggleWidth - 8) / 2;

        return Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: PayRouteColors.noirBg.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PayRouteColors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: _isOrganization ? buttonWidth : 0,
                top: 0,
                bottom: 0,
                width: buttonWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: PayRouteColors.vibrantOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isOrganization = false),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle()).copyWith(
                            color: !_isOrganization 
                                ? PayRouteColors.white 
                                : const Color(0xFF94a3b8),
                            fontWeight: !_isOrganization ? FontWeight.w700 : FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<Color?>(
                                tween: ColorTween(
                                  begin: const Color(0xFF64748b),
                                  end: !_isOrganization 
                                      ? PayRouteColors.vibrantOrange 
                                      : const Color(0xFF64748b),
                                ),
                                duration: const Duration(milliseconds: 250),
                                builder: (context, color, child) {
                                  return Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: color,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text('Personal'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isOrganization = true),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle()).copyWith(
                            color: _isOrganization 
                                ? PayRouteColors.white 
                                : const Color(0xFF94a3b8),
                            fontWeight: _isOrganization ? FontWeight.w700 : FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<Color?>(
                                tween: ColorTween(
                                  begin: const Color(0xFF64748b),
                                  end: _isOrganization 
                                      ? PayRouteColors.vibrantOrange 
                                      : const Color(0xFF64748b),
                                ),
                                duration: const Duration(milliseconds: 250),
                                builder: (context, color, child) {
                                  return Icon(
                                    Icons.business_outlined,
                                    size: 16,
                                    color: color,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text('Organization'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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

  Widget _buildRememberMeCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: PayRouteColors.vibrantOrange,
              checkColor: PayRouteColors.white,
              side: BorderSide(
                color: PayRouteColors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Remember me',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: PayRouteColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isLoading
            ? []
            : [
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
        color: _isLoading
            ? PayRouteColors.vibrantOrange.withValues(alpha: 0.6)
            : PayRouteColors.vibrantOrange,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: _isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading) ...[
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(PayRouteColors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Signing in...',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: PayRouteColors.white,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ] else ...[
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  PayRouteColors.white.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF64748b),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  PayRouteColors.white.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            context,
            label: 'Google',
            onTap: () => _handleSocialLogin(context, 'Google'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSocialButton(
            context,
            label: 'GitHub',
            onTap: () => _handleSocialLogin(context, 'GitHub'),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: PayRouteColors.noirBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PayRouteColors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: PayRouteColors.white.withValues(alpha: 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (label == 'Google')
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        height: 1.1,
                      ),
                    ),
                  ),
                )
              else if (label == 'GitHub')
                const Icon(Icons.code, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PayRouteColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSocialLogin(BuildContext context, String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = context.read<AuthProvider>();
    bool success = false;

    if (provider == 'Google') {
      success = await authProvider.signInWithGoogle();
    } else if (provider == 'GitHub') {
      success = await authProvider.signInWithGithub();
    }

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.dashboard);
    } else {
      setState(() {
        _errorMessage = authProvider.errorMessage ?? '$provider login failed. Please try again.';
        _isLoading = false;
      });
    }
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
          // User request: "Create Account" should land on the account-type selection
          // before any further onboarding.
          onTap: () => context.push(AppRoutes.selectAccountType),
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

// Data classes for particles and orbs
class _Particle {
  double x, y, size, speed, opacity, angle;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}

class _GlowOrb {
  final double x, y, radius;
  final Color color;
  _GlowOrb({required this.x, required this.y, required this.radius, required this.color});
}

// Aurora wave painter
class _AuroraPainter extends CustomPainter {
  final double animation;
  final double pulseAnimation;

  _AuroraPainter({required this.animation, required this.pulseAnimation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Multiple aurora waves
    for (int i = 0; i < 3; i++) {
      final path = Path();
      final waveOffset = animation * 2 * pi + i * pi / 3;
      final yBase = size.height * (0.2 + i * 0.15);
      final amplitude = 40.0 + pulseAnimation * 20 + i * 10;
      
      path.moveTo(0, yBase);
      
      for (double x = 0; x <= size.width; x += 5) {
        final y = yBase + 
            sin((x / size.width) * 4 * pi + waveOffset) * amplitude +
            cos((x / size.width) * 2 * pi + waveOffset * 0.5) * amplitude * 0.5;
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          i == 0 
            ? PayRouteColors.vibrantOrange.withValues(alpha: 0.03 + pulseAnimation * 0.02)
            : i == 1 
              ? const Color(0xFF0EA5E9).withValues(alpha: 0.02 + pulseAnimation * 0.015)
              : const Color(0xFF8B5CF6).withValues(alpha: 0.02 + pulseAnimation * 0.01),
          Colors.transparent,
        ],
      );
      
      paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, yBase + amplitude));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) =>
      animation != oldDelegate.animation || pulseAnimation != oldDelegate.pulseAnimation;
}

// Perspective grid with wave effect
class _PerspectiveGridPainter extends CustomPainter {
  final double animation;
  final double waveAnimation;

  _PerspectiveGridPainter({required this.animation, required this.waveAnimation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Horizontal perspective lines
    for (double y = 0; y < size.height; y += gridSize) {
      final distFromCenter = (y - centerY).abs() / centerY;
      final waveOffset = sin(waveAnimation * 2 * pi + y / 100) * 5;
      final opacity = 0.08 * (1 - distFromCenter * 0.5);
      
      paint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 0.15));
      
      final path = Path();
      path.moveTo(0, y + waveOffset);
      
      for (double x = 0; x <= size.width; x += 10) {
        final localWave = sin(waveAnimation * 2 * pi + x / 150 + y / 200) * 3;
        path.lineTo(x, y + waveOffset + localWave);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Vertical lines with fade
    for (double x = 0; x < size.width; x += gridSize) {
      final distFromCenter = (x - centerX).abs() / centerX;
      final opacity = 0.06 * (1 - distFromCenter * 0.6);
      
      paint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 0.12));
      
      final path = Path();
      path.moveTo(x, 0);
      
      for (double y = 0; y <= size.height; y += 10) {
        final localWave = sin(waveAnimation * 2 * pi + y / 150 + x / 200) * 3;
        path.lineTo(x + localWave, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_PerspectiveGridPainter oldDelegate) =>
      animation != oldDelegate.animation || waveAnimation != oldDelegate.waveAnimation;
}

// Particle network painter with connections
class _ParticleNetworkPainter extends CustomPainter {
  final List<_Particle> particles;
  final double animation;
  final double pulseAnimation;

  _ParticleNetworkPainter({
    required this.particles,
    required this.animation,
    required this.pulseAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    // Update and draw particles
    final positions = <Offset>[];
    
    for (final p in particles) {
      // Calculate animated position
      final timeOffset = animation * p.speed;
      final x = (p.x + cos(p.angle + timeOffset * pi * 2) * 0.1) % 1.0;
      final y = (p.y + sin(p.angle + timeOffset * pi * 2) * 0.1) % 1.0;
      
      final pos = Offset(x * size.width, y * size.height);
      positions.add(pos);
      
      // Animated opacity
      final animatedOpacity = p.opacity * (0.7 + sin(animation * pi * 2 + p.angle) * 0.3);
      final animatedSize = p.size * (0.8 + pulseAnimation * 0.4);
      
      // Draw particle glow
      paint.color = PayRouteColors.electricGlow.withValues(alpha: animatedOpacity * 0.3);
      canvas.drawCircle(pos, animatedSize * 3, paint);
      
      // Draw particle core
      paint.color = Colors.white.withValues(alpha: animatedOpacity);
      canvas.drawCircle(pos, animatedSize, paint);
    }
    
    // Draw connections between nearby particles
    const connectionDistance = 120.0;
    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final dist = (positions[i] - positions[j]).distance;
        if (dist < connectionDistance) {
          final opacity = (1 - dist / connectionDistance) * 0.15;
          linePaint.color = PayRouteColors.electricGlow.withValues(alpha: opacity);
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ParticleNetworkPainter oldDelegate) =>
      animation != oldDelegate.animation || pulseAnimation != oldDelegate.pulseAnimation;
}
