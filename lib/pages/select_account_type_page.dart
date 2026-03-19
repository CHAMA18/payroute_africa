import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/models/account_type.dart';
import 'package:payroute_desktop/utils/animations.dart';
import 'package:payroute_desktop/widgets/animated_background.dart';
import 'package:payroute_desktop/widgets/support_chat_widget.dart';

class SelectAccountTypePage extends StatefulWidget {
  const SelectAccountTypePage({super.key});

  @override
  State<SelectAccountTypePage> createState() => _SelectAccountTypePageState();
}

class _SelectAccountTypePageState extends State<SelectAccountTypePage> {
  AccountType _selectedType = AccountType.personal;

  void _goBack() {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.login);
  }

  void _continueSetup() {
    debugPrint('SelectAccountTypePage: selected account type = $_selectedType');
    if (_selectedType == AccountType.organization) {
      _showOrganizationComingSoonPoster();
    } else {
      // Navigate to the create account form for personal accounts
      context.push(AppRoutes.createAccount, extra: _selectedType);
    }
  }

  Future<void> _showOrganizationComingSoonPoster() async {
    await showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Organization onboarding coming soon',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _OrganizationComingSoonPoster();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: Transform.scale(
            scale: 0.94 + (0.06 * curved.value),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05080F),
      body: Stack(
        children: [
          const MeshGradientBackground(),
          SafeArea(
            child: Column(
              children: [
                _Header(onBack: _goBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            _TitleSection(),
                            const SizedBox(height: 48),
                            _AccountTypeCards(
                              selectedType: _selectedType,
                              onSelect:
                                  (type) =>
                                      setState(() => _selectedType = type),
                            ),
                            const SizedBox(height: 48),
                            _BottomSection(onContinue: _continueSetup),
                            const SizedBox(height: 32),
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
          // AI Chat Widget
          const Positioned(right: 20, bottom: 20, child: SupportChatWidget()),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            'assets/images/Dynamic.png',
            height: 80,
            fit: BoxFit.contain,
          ),
          // Back button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onBack,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Return to Welcome',
                    style: context.textStyles.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
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

class _TitleSection extends StatefulWidget {
  @override
  State<_TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends State<_TitleSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _badgeFade;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _badgeSlide;
  late Animation<Offset> _titleSlide;
  late Animation<Offset> _subtitleSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _badgeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    _badgeSlide = Tween<Offset>(
      begin: const Offset(0, -20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOutCubic),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
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
        return Column(
          children: [
            // Step badge - animated
            Transform.translate(
              offset: _badgeSlide.value,
              child: Opacity(
                opacity: _badgeFade.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: PayRouteColors.fintechNoirPrimary.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: PayRouteColors.fintechNoirPrimary.withValues(
                        alpha: 0.20,
                      ),
                    ),
                  ),
                  child: Text(
                    'STEP 01: IDENTIFICATION',
                    style: context.textStyles.labelSmall?.copyWith(
                      color: PayRouteColors.fintechNoirPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title - animated
            Transform.translate(
              offset: _titleSlide.value,
              child: Opacity(
                opacity: _titleFade.value,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Choose your ',
                        style: context.textStyles.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'pathway',
                        style: context.textStyles.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          foreground:
                              Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    PayRouteColors.fintechNoirPrimary,
                                    PayRouteColors.fintechNoirPrimaryLight,
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 50),
                                ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Subtitle - animated
            Transform.translate(
              offset: _subtitleSlide.value,
              child: Opacity(
                opacity: _subtitleFade.value,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    'Select the account type that best aligns with your financial infrastructure requirements in the African market.',
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.40),
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AccountTypeCards extends StatefulWidget {
  final AccountType selectedType;
  final ValueChanged<AccountType> onSelect;

  const _AccountTypeCards({required this.selectedType, required this.onSelect});

  @override
  State<_AccountTypeCards> createState() => _AccountTypeCardsState();
}

class _AccountTypeCardsState extends State<_AccountTypeCards>
    with TickerProviderStateMixin {
  late AnimationController _card1Controller;
  late AnimationController _card2Controller;
  late Animation<double> _card1Fade;
  late Animation<double> _card2Fade;
  late Animation<Offset> _card1Slide;
  late Animation<Offset> _card2Slide;

  @override
  void initState() {
    super.initState();

    _card1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _card2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _card1Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _card1Controller, curve: Curves.easeOutCubic),
    );
    _card2Fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _card2Controller, curve: Curves.easeOutCubic),
    );

    _card1Slide = Tween<Offset>(
      begin: const Offset(-40, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _card1Controller, curve: Curves.easeOutCubic),
    );
    _card2Slide = Tween<Offset>(
      begin: const Offset(40, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _card2Controller, curve: Curves.easeOutCubic),
    );

    // Staggered start
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _card1Controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 550), () {
      if (mounted) _card2Controller.forward();
    });
  }

  @override
  void dispose() {
    _card1Controller.dispose();
    _card2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;

        final card1 = AnimatedBuilder(
          animation: _card1Controller,
          builder:
              (context, child) => Transform.translate(
                offset: _card1Slide.value,
                child: Opacity(opacity: _card1Fade.value, child: child),
              ),
          child: _AccountTypeCard(
            type: AccountType.personal,
            isSelected: widget.selectedType == AccountType.personal,
            onTap: () => widget.onSelect(AccountType.personal),
          ),
        );

        final card2 = AnimatedBuilder(
          animation: _card2Controller,
          builder:
              (context, child) => Transform.translate(
                offset: _card2Slide.value,
                child: Opacity(opacity: _card2Fade.value, child: child),
              ),
          child: _AccountTypeCard(
            type: AccountType.organization,
            isSelected: widget.selectedType == AccountType.organization,
            onTap: () => widget.onSelect(AccountType.organization),
          ),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: card1),
              const SizedBox(width: 24),
              Expanded(child: card2),
            ],
          );
        }

        return Column(children: [card1, const SizedBox(height: 24), card2]);
      },
    );
  }
}

class _AccountTypeCard extends StatefulWidget {
  final AccountType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_AccountTypeCard> createState() => _AccountTypeCardState();
}

class _AccountTypeCardState extends State<_AccountTypeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isPersonal = widget.type == AccountType.personal;

    final title = isPersonal ? 'Personal Account' : 'Organization';
    final description =
        isPersonal
            ? 'An elite dashboard for individuals seeking seamless multi-rail routing. Send and receive funds across borders with localized efficiency and institutional-grade security.'
            : 'Scale your enterprise with our robust API-first architecture. Automated treasury management, bulk payouts, and deep liquidity across the African continent.';
    final features =
        isPersonal
            ? ['Cross-border P2P transfers', 'Smart asset management']
            : ['Full API & Webhook Access', 'Multi-user Treasury Controls'];
    final icon = isPersonal ? Icons.person : Icons.corporate_fare;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform:
              Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0)
                ..scale(_isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  widget.isSelected
                      ? [
                        PayRouteColors.fintechNoirPrimary.withValues(
                          alpha: 0.05,
                        ),
                        Colors.white.withValues(alpha: 0.02),
                      ]
                      : [
                        Colors.white.withValues(
                          alpha: _isHovered ? 0.06 : 0.03,
                        ),
                        Colors.white.withValues(
                          alpha: _isHovered ? 0.02 : 0.01,
                        ),
                      ],
            ),
            border: Border.all(
              color:
                  widget.isSelected
                      ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.6)
                      : _isHovered
                      ? PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow:
                widget.isSelected
                    ? [
                      BoxShadow(
                        color: PayRouteColors.fintechNoirPrimary.withValues(
                          alpha: 0.10,
                        ),
                        blurRadius: 40,
                        spreadRadius: 0,
                      ),
                    ]
                    : _isHovered
                    ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 50,
                        offset: const Offset(0, 25),
                      ),
                      BoxShadow(
                        color: PayRouteColors.fintechNoirPrimary.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 20,
                      ),
                    ]
                    : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _RadioIndicator(isSelected: widget.isSelected),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Icon container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            widget.isSelected
                                ? PayRouteColors.fintechNoirPrimary.withValues(
                                  alpha: 0.10,
                                )
                                : Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color:
                              widget.isSelected
                                  ? PayRouteColors.fintechNoirPrimary
                                      .withValues(alpha: 0.20)
                                  : Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 40,
                          color:
                              widget.isSelected || _isHovered
                                  ? PayRouteColors.fintechNoirPrimary
                                  : Colors.white.withValues(alpha: 0.40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Title
                    Text(
                      title,
                      style: context.textStyles.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    Text(
                      description,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.60),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Divider
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    const SizedBox(height: 24),
                    // Features
                    ...features.map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color:
                                  widget.isSelected || _isHovered
                                      ? PayRouteColors.fintechNoirPrimary
                                      : Colors.white.withValues(alpha: 0.20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                feature,
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.80),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isSelected;

  const _RadioIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected
                  ? PayRouteColors.fintechNoirPrimary
                  : Colors.white.withValues(alpha: 0.20),
          width: 2,
        ),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 14 : 0,
          height: isSelected ? 14 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isSelected
                    ? PayRouteColors.fintechNoirPrimary
                    : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  final VoidCallback onContinue;

  const _BottomSection({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.03),
            Colors.white.withValues(alpha: 0.01),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          if (isWide) {
            return Row(
              children: [
                Expanded(child: _InfoText()),
                const SizedBox(width: 24),
                _ContinueButton(onPressed: onContinue),
              ],
            );
          }

          return Column(
            children: [
              _InfoText(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: _ContinueButton(onPressed: onContinue),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 28,
          color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.60),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: context.textStyles.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.50),
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text:
                      'You can upgrade from Personal to Organization later. Need assistance? ',
                ),
                TextSpan(
                  text: 'Talk to an advisor',
                  style: TextStyle(
                    color: PayRouteColors.fintechNoirPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
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
          transform:
              Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.fintechNoirPrimary,
                PayRouteColors.fintechNoirPrimaryLight,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: PayRouteColors.fintechNoirPrimary.withValues(
                  alpha: _isHovered ? 0.40 : 0.25,
                ),
                blurRadius: _isHovered ? 40 : 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue Setup',
                style: context.textStyles.titleMedium?.copyWith(
                  color: const Color(0xFF05080F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                child: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF05080F),
                  size: 20,
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Column(
        children: [
          // Security badges
          Opacity(
            opacity: 0.30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SECURED BY',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: Colors.white,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.security, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.verified_user, color: Colors.white, size: 20),
                const SizedBox(width: 16),
                const Icon(Icons.lock, color: Colors.white, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Copyright
          Text(
            '© 2024 PAYROUTE AFRICA. ALL RIGHTS RESERVED.',
            style: context.textStyles.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.20),
              letterSpacing: 2,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganizationComingSoonPoster extends StatelessWidget {
  const _OrganizationComingSoonPoster();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF161109).withValues(alpha: 0.96),
                        const Color(0xFF090D17).withValues(alpha: 0.98),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: PayRouteColors.fintechNoirPrimary.withValues(
                        alpha: 0.26,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PayRouteColors.fintechNoirPrimary.withValues(
                          alpha: 0.18,
                        ),
                        blurRadius: 48,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -90,
                        right: -40,
                        child: _PosterGlow(
                          size: 220,
                          color: PayRouteColors.fintechNoirPrimary.withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -60,
                        bottom: -70,
                        child: _PosterGlow(
                          size: 180,
                          color: PayRouteColors.fintechNoirPrimaryLight
                              .withValues(alpha: 0.10),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 34, 40, 36),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PayRouteColors.fintechNoirPrimary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: PayRouteColors.fintechNoirPrimary
                                          .withValues(alpha: 0.22),
                                    ),
                                  ),
                                  child: Text(
                                    'ORGANIZATION',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: PayRouteColors.fintechNoirPrimary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.05,
                                    ),
                                    foregroundColor: Colors.white.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    PayRouteColors.fintechNoirPrimary,
                                    PayRouteColors.fintechNoirPrimaryLight,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: PayRouteColors.fintechNoirPrimary
                                        .withValues(alpha: 0.28),
                                    blurRadius: 28,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.corporate_fare_rounded,
                                color: Color(0xFF0A0D14),
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              'Organization onboarding is coming soon',
                              style: textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'We are polishing the full enterprise setup experience for treasury teams, API-first operations, and multi-user controls. Personal accounts remain available right now.',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withValues(alpha: 0.64),
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Column(
                                children: [
                                  _PosterFeature(
                                    icon: Icons.api_rounded,
                                    title: 'Enterprise API orchestration',
                                  ),
                                  SizedBox(height: 14),
                                  _PosterFeature(
                                    icon: Icons.groups_rounded,
                                    title: 'Advanced team and approval flows',
                                  ),
                                  SizedBox(height: 14),
                                  _PosterFeature(
                                    icon: Icons.account_balance_rounded,
                                    title:
                                        'Treasury-grade liquidity operations',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.14,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      'Back',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.86,
                                        ),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          PayRouteColors.fintechNoirPrimary,
                                          PayRouteColors
                                              .fintechNoirPrimaryLight,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: PayRouteColors
                                              .fintechNoirPrimary
                                              .withValues(alpha: 0.26),
                                          blurRadius: 26,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Organization setup will be available soon.',
                                              ),
                                              backgroundColor: const Color(
                                                0xFF111827,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF05080F,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 18,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Notify Me',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: const Color(0xFF05080F),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PosterGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _PosterGlow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.55,
            spreadRadius: size * 0.14,
          ),
        ],
      ),
    );
  }
}

class _PosterFeature extends StatelessWidget {
  final IconData icon;
  final String title;

  const _PosterFeature({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: PayRouteColors.fintechNoirPrimary.withValues(alpha: 0.16),
            ),
          ),
          child: Icon(icon, color: PayRouteColors.fintechNoirPrimary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
