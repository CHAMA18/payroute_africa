import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/country_data.dart';
import 'package:payroute_desktop/models/account_type.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class CreateAccountPage extends StatefulWidget {
  final AccountType accountType;
  
  const CreateAccountPage({super.key, required this.accountType});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _country = 'NG';
  
  // Animation controllers
  late AnimationController _breatheController;
  late AnimationController _scanController;
  late AnimationController _twinkleController;
  late AnimationController _floatController;
  late AnimationController _particleController;
  late AnimationController _auroraController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  final List<_CreateAccountParticle> _particles = [];
  final List<_CreateAccountGlowOrb> _glowOrbs = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    debugPrint('CreateAccountPage: received account type = ${widget.accountType}');
    
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
      _particles.add(_CreateAccountParticle(
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
      _CreateAccountGlowOrb(x: 0.15, y: 0.2, radius: 200, color: PayRouteColors.vibrantOrange),
      _CreateAccountGlowOrb(x: 0.85, y: 0.3, radius: 250, color: PayRouteColors.electricGlow),
      _CreateAccountGlowOrb(x: 0.5, y: 0.8, radius: 180, color: const Color(0xFF0EA5E9)),
      _CreateAccountGlowOrb(x: 0.2, y: 0.7, radius: 150, color: const Color(0xFF8B5CF6)),
      _CreateAccountGlowOrb(x: 0.8, y: 0.85, radius: 220, color: PayRouteColors.vibrantOrange),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _close() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.login);
  }

  PasswordStrength get _passwordStrength => PasswordStrength.from(_passwordController.text);

  bool _isCreating = false;

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      debugPrint('CreateAccountPage: validation failed');
      return;
    }

    if (_isCreating) return; // Prevent double submission
    
    setState(() => _isCreating = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final accountTypeString = widget.accountType == AccountType.personal ? 'personal' : 'organization';

    debugPrint('CreateAccountPage: creating account (country=$_country, accountType=$accountTypeString)');

    final authProvider = context.read<AuthProvider>();
    
    // Create the Firebase account
    final success = await authProvider.signUp(email, password, accountTypeString);
    
    if (!mounted) return;
    
    setState(() => _isCreating = false);
    
    if (success) {
      // Enable remember me so user stays logged in
      await authProvider.setRememberMe(true);
      
      // Navigate to dashboard
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
    } else {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Failed to create account'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayRouteColors.noirDark,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TopBar(onClose: _close),
                        const SizedBox(height: 28),
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Create Account', style: context.textStyles.headlineMedium?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                                  const SizedBox(height: 8),
                                  Text('Join the multi-rail payment network.', style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.textMuted, height: 1.5)),
                                  const SizedBox(height: 24),
                                  _GlassCard(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          _LabeledInputField(
                                            label: 'Full Name',
                                            hintText: 'John Doe',
                                            controller: _nameController,
                                            keyboardType: TextInputType.name,
                                            icon: Icons.person_outline,
                                            validator: (value) {
                                              final v = (value ?? '').trim();
                                              if (v.isEmpty) return 'Please enter your name.';
                                              if (v.length < 2) return 'Name is too short.';
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          _LabeledInputField(
                                            label: 'Email Address',
                                            hintText: 'john@company.com',
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            icon: Icons.mail_outline,
                                            validator: (value) {
                                              final v = (value ?? '').trim();
                                              if (v.isEmpty) return 'Please enter your email.';
                                              if (!v.contains('@') || !v.contains('.')) return 'Please enter a valid email.';
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          _CountryDropdown(
                                            value: _country,
                                            onChanged: (v) => setState(() => _country = v),
                                          ),
                                          const SizedBox(height: 16),
                                          _PasswordField(
                                            controller: _passwordController,
                                            isVisible: _isPasswordVisible,
                                            strength: _passwordStrength,
                                            onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                            onChanged: (_) {
                                              setState(() {});
                                              // Keep confirm-password validation in sync when password changes.
                                              _formKey.currentState?.validate();
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          _ConfirmPasswordField(
                                            controller: _confirmPasswordController,
                                            passwordController: _passwordController,
                                            isVisible: _isPasswordVisible,
                                            onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                          ),
                                          const SizedBox(height: 18),
                                          _PrimaryGlowButton(
                                            label: _isCreating ? 'Creating...' : 'Create Account',
                                            icon: _isCreating ? Icons.hourglass_empty : Icons.arrow_forward,
                                            onPressed: _isCreating ? () {} : _createAccount,
                                            isLoading: _isCreating,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                                            textAlign: TextAlign.center,
                                            style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.textMuted, height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Center(
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text('Already have an account?', style: context.textStyles.bodySmall?.copyWith(color: PayRouteColors.textMuted)),
                                        const SizedBox(width: 6),
                                        TextButton(
                                          onPressed: () => context.go(AppRoutes.login),
                                          style: TextButton.styleFrom(foregroundColor: PayRouteColors.vibrantOrange, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                                          child: Text('Login', style: context.textStyles.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                                        ),
                                      ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PayRouteColors.noirDark, PayRouteColors.noirBg],
            ),
          ),
        ),
        
        // Aurora waves
        AnimatedBuilder(
          animation: Listenable.merge([_auroraController, _pulseController]),
          builder: (context, _) {
            return CustomPaint(
              painter: _CreateAccountAuroraPainter(
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
              painter: _CreateAccountGridPainter(
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
              painter: _CreateAccountParticlePainter(
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
}

class _TopBar extends StatelessWidget {
  final VoidCallback onClose;

  const _TopBar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/Dynamic.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: PayRouteColors.textMuted),
          style: IconButton.styleFrom(hoverColor: PayRouteColors.white.withValues(alpha: 0.06)),
          tooltip: 'Close',
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: PayRouteColors.noirNavy.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.10)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.30), blurRadius: 32, offset: const Offset(0, 12))],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LabeledInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;
  final String? Function(String?)? validator;

  const _LabeledInputField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.textMuted, letterSpacing: 1.0, fontWeight: FontWeight.w800),
          ),
        ),
        _GlassInputShell(
          leadingIcon: icon,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: context.textStyles.bodyMedium?.copyWith(color: const Color(0xFF4B5563)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassInputShell extends StatefulWidget {
  final IconData leadingIcon;
  final Widget child;
  final Widget? trailing;

  const _GlassInputShell({required this.leadingIcon, required this.child, this.trailing});

  @override
  State<_GlassInputShell> createState() => _GlassInputShellState();
}

class _GlassInputShellState extends State<_GlassInputShell> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final highlight = _focused ? PayRouteColors.vibrantOrange.withValues(alpha: 0.55) : PayRouteColors.white.withValues(alpha: 0.10);
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: PayRouteColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: highlight),
          boxShadow: _focused
              ? [BoxShadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.12), blurRadius: 18, spreadRadius: 0)]
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: Icon(widget.leadingIcon, size: 20, color: _focused ? PayRouteColors.vibrantOrange : const Color(0xFF6B7280)),
            ),
            const SizedBox(width: 10),
            Expanded(child: widget.child),
            if (widget.trailing != null) ...[
              const SizedBox(width: 6),
              widget.trailing!,
              const SizedBox(width: 8),
            ] else
              const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CountryDropdown({required this.value, required this.onChanged});

  String _labelFor(String code) {
    final entry = CountryData.byCode(code);
    if (entry == null) return code;
    if (entry.dialCode.isEmpty) return entry.name;
    return '${entry.name} (+${entry.dialCode})';
  }

  @override
  Widget build(BuildContext context) {
    final countries = CountryData.all;
    final safeValue = countries.any((c) => c.code == value) ? value : (countries.isNotEmpty ? countries.first.code : value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            'COUNTRY',
            style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.textMuted, letterSpacing: 1.0, fontWeight: FontWeight.w800),
          ),
        ),
        _GlassInputShell(
          leadingIcon: Icons.public,
          trailing: const Icon(Icons.expand_more, size: 18, color: Color(0xFF6B7280)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: safeValue,
              dropdownColor: PayRouteColors.noirNavy,
              icon: const SizedBox.shrink(),
              style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white),
              onChanged: (v) {
                if (v == null) return;
                onChanged(v);
              },
              items: countries
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c.code,
                      child: Text(_labelFor(c.code), overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;
  final PasswordStrength strength;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;

  const _PasswordField({
    required this.controller,
    required this.isVisible,
    required this.strength,
    required this.onToggleVisibility,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text('PASSWORD', style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.textMuted, letterSpacing: 1.0, fontWeight: FontWeight.w800)),
        ),
        _GlassInputShell(
          leadingIcon: Icons.lock_outline,
          trailing: IconButton(
            onPressed: onToggleVisibility,
            tooltip: isVisible ? 'Hide password' : 'Show password',
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, size: 18, color: const Color(0xFF6B7280)),
            style: IconButton.styleFrom(hoverColor: PayRouteColors.white.withValues(alpha: 0.06)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            onChanged: onChanged,
            validator: (value) {
              final v = (value ?? '');
              if (v.isEmpty) return 'Please enter a password.';
              if (v.length < 8) return 'Use at least 8 characters.';
              return null;
            },
            style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: context.textStyles.bodyMedium?.copyWith(color: const Color(0xFF4B5563)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _StrengthBar(isActive: strength.level >= 1, color: PayRouteColors.vibrantOrange),
            const SizedBox(width: 6),
            _StrengthBar(isActive: strength.level >= 2, color: PayRouteColors.vibrantOrange.withValues(alpha: 0.30)),
            const SizedBox(width: 6),
            _StrengthBar(isActive: strength.level >= 3, color: PayRouteColors.white.withValues(alpha: 0.10)),
            const SizedBox(width: 6),
            _StrengthBar(isActive: strength.level >= 4, color: PayRouteColors.white.withValues(alpha: 0.10)),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                strength.label,
                key: ValueKey(strength.label),
                style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.vibrantOrange, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isVisible;
  final VoidCallback onToggleVisibility;

  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
    required this.isVisible,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text('CONFIRM PASSWORD', style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.textMuted, letterSpacing: 1.0, fontWeight: FontWeight.w800)),
        ),
        _GlassInputShell(
          leadingIcon: Icons.verified_user_outlined,
          trailing: IconButton(
            onPressed: onToggleVisibility,
            tooltip: isVisible ? 'Hide password' : 'Show password',
            icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, size: 18, color: const Color(0xFF6B7280)),
            style: IconButton.styleFrom(hoverColor: PayRouteColors.white.withValues(alpha: 0.06)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: (value) {
              final v = (value ?? '');
              if (v.isEmpty) return 'Please confirm your password.';
              if (v != passwordController.text) return 'Passwords do not match.';
              return null;
            },
            style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: context.textStyles.bodyMedium?.copyWith(color: const Color(0xFF4B5563)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _StrengthBar({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color: isActive ? color : PayRouteColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _PrimaryGlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const _PrimaryGlowButton({required this.label, required this.icon, required this.onPressed, this.isLoading = false});

  @override
  State<_PrimaryGlowButton> createState() => _PrimaryGlowButtonState();
}

class _PrimaryGlowButtonState extends State<_PrimaryGlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(colors: widget.isLoading 
              ? [PayRouteColors.vibrantOrange.withValues(alpha: 0.6), PayRouteColors.vibrantOrangeDark.withValues(alpha: 0.6)]
              : [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark]),
            boxShadow: [
              BoxShadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.40), blurRadius: 22, spreadRadius: 0, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(PayRouteColors.white),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(widget.label, style: context.textStyles.titleMedium?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
              if (!widget.isLoading) ...[
                const SizedBox(width: 10),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
                  child: Icon(widget.icon, color: PayRouteColors.white, size: 18),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class PasswordStrength {
  final int level; // 1..4
  final String label;

  const PasswordStrength._(this.level, this.label);

  static PasswordStrength from(String password) {
    final p = password.trim();
    if (p.isEmpty) return const PasswordStrength._(1, 'Weak');

    var score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'\d').hasMatch(p) || RegExp(r'[^A-Za-z0-9]').hasMatch(p)) score++;

    final level = (score.clamp(1, 4));
    return PasswordStrength._(
      level,
      switch (level) {
        1 => 'Weak',
        2 => 'Fair',
        3 => 'Good',
        _ => 'Strong',
      },
    );
  }
}

// Data classes for particles and orbs
class _CreateAccountParticle {
  double x, y, size, speed, opacity, angle;
  _CreateAccountParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });
}

class _CreateAccountGlowOrb {
  final double x, y, radius;
  final Color color;
  _CreateAccountGlowOrb({required this.x, required this.y, required this.radius, required this.color});
}

// Aurora wave painter
class _CreateAccountAuroraPainter extends CustomPainter {
  final double animation;
  final double pulseAnimation;

  _CreateAccountAuroraPainter({required this.animation, required this.pulseAnimation});

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
  bool shouldRepaint(_CreateAccountAuroraPainter oldDelegate) =>
      animation != oldDelegate.animation || pulseAnimation != oldDelegate.pulseAnimation;
}

// Perspective grid with wave effect
class _CreateAccountGridPainter extends CustomPainter {
  final double animation;
  final double waveAnimation;

  _CreateAccountGridPainter({required this.animation, required this.waveAnimation});

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
      
      paint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 1.0));
      
      final path = Path();
      path.moveTo(0, y + waveOffset);
      
      for (double x = 0; x <= size.width; x += 10) {
        final localWave = sin(waveAnimation * 2 * pi + x / 80) * 3;
        path.lineTo(x, y + waveOffset + localWave);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Vertical lines with perspective
    for (double x = 0; x < size.width; x += gridSize) {
      final distFromCenter = (x - centerX).abs() / centerX;
      final opacity = 0.06 * (1 - distFromCenter * 0.5);
      
      paint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 1.0));
      
      final path = Path();
      path.moveTo(x, 0);
      
      for (double y = 0; y <= size.height; y += 10) {
        final waveOffset = sin(waveAnimation * 2 * pi + y / 100) * 2;
        path.lineTo(x + waveOffset, y);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_CreateAccountGridPainter oldDelegate) =>
      animation != oldDelegate.animation || waveAnimation != oldDelegate.waveAnimation;
}

// Particle network painter
class _CreateAccountParticlePainter extends CustomPainter {
  final List<_CreateAccountParticle> particles;
  final double animation;
  final double pulseAnimation;

  _CreateAccountParticlePainter({
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
    
    for (var particle in particles) {
      // Update position with subtle movement
      final angle = animation * 2 * pi + particle.angle;
      final dx = cos(angle) * particle.speed * 50;
      final dy = sin(angle) * particle.speed * 50;
      
      final x = ((particle.x * size.width + dx) % size.width + size.width) % size.width;
      final y = ((particle.y * size.height + dy) % size.height + size.height) % size.height;
      
      positions.add(Offset(x, y));
      
      // Draw particle with glow
      final opacity = particle.opacity * (0.8 + pulseAnimation * 0.4);
      paint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 1.0));
      
      canvas.drawCircle(Offset(x, y), particle.size, paint);
      
      // Outer glow
      paint.color = PayRouteColors.electricGlow.withValues(alpha: (opacity * 0.3).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), particle.size * 2, paint);
    }
    
    // Draw connections between nearby particles
    const connectionDistance = 120.0;
    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final distance = (positions[i] - positions[j]).distance;
        if (distance < connectionDistance) {
          final opacity = (1 - distance / connectionDistance) * 0.15;
          linePaint.color = PayRouteColors.electricGlow.withValues(alpha: opacity.clamp(0.0, 1.0));
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_CreateAccountParticlePainter oldDelegate) =>
      animation != oldDelegate.animation || pulseAnimation != oldDelegate.pulseAnimation;
}
