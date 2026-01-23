import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/country_data.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _country = 'NG';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      debugPrint('CreateAccountPage: validation failed; continuing to account type.');
    }

    debugPrint('CreateAccountPage: create account requested (country=$_country)');

    // User request: after clicking “Create Account”, navigate to the account-type
    // selection screen (HTML parity page). Firebase wiring can be added later.
    context.go(AppRoutes.selectAccountType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayRouteColors.noirDark,
      body: Stack(
        children: [
          const _MeshGradientBackdrop(),
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
                                            label: 'Create Account',
                                            icon: Icons.arrow_forward,
                                            onPressed: _createAccount,
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
}

class _MeshGradientBackdrop extends StatelessWidget {
  const _MeshGradientBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PayRouteColors.noirDark, PayRouteColors.noirBg],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.15,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.35),
                ],
              ),
            ),
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
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark],
                ),
                boxShadow: [BoxShadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.20), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.hub, color: PayRouteColors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Text('PayRoute', style: context.textStyles.titleLarge?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
          ],
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

  const _PrimaryGlowButton({required this.label, required this.icon, required this.onPressed});

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
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [PayRouteColors.vibrantOrange, PayRouteColors.vibrantOrangeDark]),
            boxShadow: [
              BoxShadow(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.40), blurRadius: 22, spreadRadius: 0, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label, style: context.textStyles.titleMedium?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
              const SizedBox(width: 10),
              AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                offset: _hovered ? const Offset(0.15, 0) : Offset.zero,
                child: Icon(widget.icon, color: PayRouteColors.white, size: 18),
              ),
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
