import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';

class SelectAccountTypePage extends StatefulWidget {
  const SelectAccountTypePage({super.key});

  @override
  State<SelectAccountTypePage> createState() => _SelectAccountTypePageState();
}

enum AccountType { personal, organization }

class _SelectAccountTypePageState extends State<SelectAccountTypePage> {
  AccountType _selected = AccountType.personal;

  void _returnToWelcome() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.home);
  }

  void _continue() {
    // This flow is intentionally lightweight for now. You can wire the next step
    // (personal vs org onboarding) once the destination pages are confirmed.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selected == AccountType.personal
              ? 'Personal account selected. Next step not yet implemented.'
              : 'Organization account selected. Next step not yet implemented.',
        ),
        backgroundColor: PayRouteColors.noirNavy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PayRouteColors.noirDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _NoirMeshBackdrop(),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: _Header(onBack: _returnToWelcome),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1120),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              _StepIntro(),
                              const SizedBox(height: 44),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isNarrow = constraints.maxWidth < 860;
                                  final personalCard = AccountTypeCard(
                                    title: 'Personal Account',
                                    description:
                                        'An elite dashboard for individuals seeking seamless multi-rail routing. Send and receive funds across borders with localized efficiency and institutional-grade security.',
                                    icon: Icons.person,
                                    active: _selected == AccountType.personal,
                                    bullets: const ['Cross-border P2P transfers', 'Smart asset management'],
                                    onTap: () => setState(() => _selected = AccountType.personal),
                                  );
                                  final organizationCard = AccountTypeCard(
                                    title: 'Organization',
                                    description:
                                        'Scale your enterprise with our robust API-first architecture. Automated treasury management, bulk payouts, and deep liquidity across the African continent.',
                                    icon: Icons.corporate_fare,
                                    active: _selected == AccountType.organization,
                                    bullets: const ['Full API & Webhook Access', 'Multi-user Treasury Controls'],
                                    onTap: () => setState(() => _selected = AccountType.organization),
                                  );

                                  if (isNarrow) {
                                    return Column(
                                      children: [
                                        personalCard,
                                        const SizedBox(height: 20),
                                        organizationCard,
                                      ],
                                    );
                                  }

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(child: personalCard),
                                      const SizedBox(width: 20),
                                      Expanded(child: organizationCard),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              _BottomPanel(onContinue: _continue),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

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
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [PayRouteColors.fintechNoirPrimary, PayRouteColors.fintechNoirPrimaryLight],
                ),
              ),
              child: const Icon(Icons.shield, color: PayRouteColors.noirBg, size: 22),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                style: context.textStyles.titleLarge?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                children: const [
                  TextSpan(text: 'FINTECH'),
                  TextSpan(text: 'NOIR', style: TextStyle(color: PayRouteColors.fintechNoirPrimary)),
                ],
              ),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onBack,
          style: TextButton.styleFrom(
            foregroundColor: PayRouteColors.textMuted,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          icon: const Icon(Icons.arrow_back, size: 16, color: PayRouteColors.textMuted),
          label: Text(
            'Return to Welcome',
            style: context.textStyles.bodySmall?.copyWith(color: PayRouteColors.textMuted, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _StepIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.22)),
            ),
            child: Text(
              'STEP 01: IDENTIFICATION',
              style: context.textStyles.labelSmall?.copyWith(
                color: PayRouteColors.fintechNoirPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.textStyles.displayMedium?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w900, height: 1.05),
              children: [
                const TextSpan(text: 'Choose your '),
                TextSpan(
                  text: 'pathway',
                  style: context.textStyles.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [PayRouteColors.fintechNoirPrimary, PayRouteColors.fintechNoirPrimaryLight],
                      ).createShader(const Rect.fromLTWH(0, 0, 420, 80)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Select the account type that best aligns with your financial infrastructure requirements in the African market.',
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLarge?.copyWith(color: PayRouteColors.white.withValues(alpha: 0.45)),
          ),
        ],
      ),
    );
  }
}

class AccountTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool active;
  final List<String> bullets;
  final VoidCallback onTap;

  const AccountTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.active,
    required this.bullets,
    required this.onTap,
  });

  @override
  State<AccountTypeCard> createState() => _AccountTypeCardState();
}

class _AccountTypeCardState extends State<AccountTypeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final baseBorder = widget.active
        ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.65)
        : PayRouteColors.white.withValues(alpha: 0.08);
    final hoverBorder = PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.35);
    final borderColor = _hovered ? hoverBorder : baseBorder;
    final lift = (_hovered ? 8.0 : 0.0) + (widget.active ? 2.0 : 0.0);
    final glow = widget.active ? 0.10 : (_hovered ? 0.06 : 0.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..translate(0.0, -lift)..scale(_hovered ? 1.01 : 1.0),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.active
                  ? [
                      PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.06),
                      PayRouteColors.white.withValues(alpha: 0.02),
                    ]
                  : [
                      PayRouteColors.white.withValues(alpha: 0.035),
                      PayRouteColors.white.withValues(alpha: 0.012),
                    ],
            ),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              if (glow > 0)
                BoxShadow(
                  color: PayRouteColors.fintechNoirPrimary.withValues(alpha: glow),
                  blurRadius: 42,
                  offset: const Offset(0, 18),
                ),
              BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 36, offset: const Offset(0, 18)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 2,
                right: 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.active
                          ? PayRouteColors.fintechNoirPrimary
                          : PayRouteColors.white.withValues(alpha: _hovered ? 0.25 : 0.16),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.active ? PayRouteColors.fintechNoirPrimary : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _IconTile(icon: widget.icon, active: widget.active, hovered: _hovered),
                  const SizedBox(height: 18),
                  Text(
                    widget.title,
                    style: context.textStyles.headlineSmall?.copyWith(color: PayRouteColors.white, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white.withValues(alpha: 0.62), height: 1.55),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 1,
                    color: PayRouteColors.white.withValues(alpha: 0.06),
                  ),
                  const SizedBox(height: 16),
                  for (final bullet in widget.bullets) ...[
                    _FeatureRow(active: widget.active, hovered: _hovered, label: bullet),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final IconData icon;
  final bool active;
  final bool hovered;

  const _IconTile({required this.icon, required this.active, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final isHighlighted = active || hovered;
    final bg = isHighlighted ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.12) : PayRouteColors.white.withValues(alpha: 0.05);
    final border = isHighlighted ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.22) : PayRouteColors.white.withValues(alpha: 0.10);
    final iconColor = isHighlighted ? PayRouteColors.fintechNoirPrimary : PayRouteColors.white.withValues(alpha: 0.45);

    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Center(
        child: Icon(icon, size: 44, color: iconColor),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final bool active;
  final bool hovered;
  final String label;

  const _FeatureRow({required this.active, required this.hovered, required this.label});

  @override
  Widget build(BuildContext context) {
    final iconColor = (active || hovered) ? PayRouteColors.fintechNoirPrimary : PayRouteColors.white.withValues(alpha: 0.18);
    return Row(
      children: [
        Icon(Icons.check_circle, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: context.textStyles.bodyMedium?.copyWith(color: PayRouteColors.white.withValues(alpha: 0.82)),
          ),
        ),
      ],
    );
  }
}

class _BottomPanel extends StatelessWidget {
  final VoidCallback onContinue;

  const _BottomPanel({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.white.withValues(alpha: 0.035),
                PayRouteColors.white.withValues(alpha: 0.012),
              ],
            ),
            border: Border.all(color: PayRouteColors.white.withValues(alpha: 0.08)),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 720;
              final left = Row(
                children: [
                  Icon(Icons.info_outline, color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.7), size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can upgrade from Personal to Organization later. Need assistance? Talk to an advisor.',
                      style: context.textStyles.bodySmall?.copyWith(color: PayRouteColors.white.withValues(alpha: 0.55), height: 1.5),
                    ),
                  ),
                ],
              );

              final button = _OrangeGlowButton(onPressed: onContinue);

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    left,
                    const SizedBox(height: 14),
                    button,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 16),
                  SizedBox(width: 260, child: button),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OrangeGlowButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _OrangeGlowButton({required this.onPressed});

  @override
  State<_OrangeGlowButton> createState() => _OrangeGlowButtonState();
}

class _OrangeGlowButtonState extends State<_OrangeGlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [PayRouteColors.fintechNoirPrimary, PayRouteColors.fintechNoirPrimaryLight],
            ),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.fintechNoirPrimary.withValues(alpha: _hovered ? 0.40 : 0.26),
                blurRadius: _hovered ? 46 : 34,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue Setup',
                style: context.textStyles.titleMedium?.copyWith(color: PayRouteColors.noirBg, fontWeight: FontWeight.w900, letterSpacing: 0.1),
              ),
              const SizedBox(width: 10),
              AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                offset: _hovered ? const Offset(0.12, 0) : Offset.zero,
                child: const Icon(Icons.arrow_forward, color: PayRouteColors.noirBg, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: PayRouteColors.white.withValues(alpha: 0.06)))),
      child: Text(
        '© 2024 Fintech Noir Africa. All Rights Reserved.',
        textAlign: TextAlign.center,
        style: context.textStyles.labelSmall?.copyWith(color: PayRouteColors.white.withValues(alpha: 0.22), letterSpacing: 1.4),
      ),
    );
  }
}

class _NoirMeshBackdrop extends StatelessWidget {
  const _NoirMeshBackdrop();

  static const String textureUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDusnzvMo6aVuvjp479_KtpYn3n9V3ne82nGF1sfqi3HIKzeH9HQ4WqFvzfL9SxQMwmkPISMFxsZuiCSIMBgnq8x1X-NhUJTpS6Sz02mHgdXA3e2-KOYg9OtTSAhlt0ssxObeADjE0qEsvh7CdiAQfGRC6P6zuznrE6cS0jIALlQBkyI8HCeKbiDydpoG9qybbpxpaOR1eRVnf5K1na8YuVt7sjgyL-PydxYisFWI30sbqpEHkNaz47OIO56Hr2v-uKP4whqCl6nkRU';

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [PayRouteColors.noirBg, PayRouteColors.noirDark],
                ),
              ),
            ),
            // Mesh-like radial gradients (subtle, “premium glass”)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-1.0, -1.0),
                  radius: 1.05,
                  colors: [
                    PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(1.0, 1.0),
                  radius: 1.08,
                  colors: [
                    Colors.blue.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45],
                ),
              ),
            ),
            Opacity(
              opacity: 0.02,
              child: Image.network(
                textureUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
