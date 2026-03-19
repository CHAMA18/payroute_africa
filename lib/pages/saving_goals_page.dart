import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:provider/provider.dart';

class SavingGoalsPage extends StatelessWidget {
  const SavingGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return FinRouteResponsiveScaffold(
      selectedLabel: 'Saving Goals',
      mobileTitle: 'Saving Goals',
      mobileSubtitle: 'Portfolio automation and contributions',
      desktopHeader: _SavingGoalsHeader(brightness: brightness),
      background: _SavingGoalsBackdrop(brightness: brightness),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PortfolioHero(brightness: brightness),
                const SizedBox(height: 40),
                _GoalsShowcase(brightness: brightness),
                const SizedBox(height: 46),
                _InsightsGrid(brightness: brightness),
                const SizedBox(height: 44),
                _StatusStrip(brightness: brightness),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SavingGoalsHeader extends StatelessWidget {
  final Brightness brightness;

  const _SavingGoalsHeader({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: DashboardPalette.bg(brightness).withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(color: border.withValues(alpha: 0.85)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: DashboardPalette.surfaceMuted(
                      brightness,
                    ).withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.inter(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Search wealth assets...',
                            hintStyle: GoogleFonts.inter(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_rounded, color: textSecondary),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_rounded, color: textSecondary),
          ),
          const SizedBox(width: 18),
          Container(
            width: 1,
            height: 34,
            color: border.withValues(alpha: 0.85),
          ),
          const SizedBox(width: 20),
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.userModel;
              final firebaseUser = auth.firebaseUser;
              final displayName =
                  user?.displayName ??
                  firebaseUser?.email?.split('@').first ??
                  'Alexander Noir';

              return Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFonts.inter(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'PRO MEMBER',
                        style: GoogleFonts.inter(
                          color: PayRouteColors.dashboardAccentOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.9,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFF7C998), Color(0xFFFFB46A)],
                      ),
                      border: Border.all(
                        color: PayRouteColors.dashboardAccentOrange.withValues(
                          alpha: 0.24,
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SavingGoalsBackdrop extends StatelessWidget {
  final Brightness brightness;

  const _SavingGoalsBackdrop({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: DashboardPalette.bg(brightness)),
        if (isDark)
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  left: -180,
                  top: 120,
                  child: _GlowOrb(
                    size: 420,
                    color: PayRouteColors.dashboardPrimary.withValues(
                      alpha: 0.07,
                    ),
                  ),
                ),
                Positioned(
                  right: -120,
                  top: 60,
                  child: _GlowOrb(
                    size: 320,
                    color: PayRouteColors.dashboardAccentOrange.withValues(
                      alpha: 0.08,
                    ),
                  ),
                ),
                Positioned(
                  left: 240,
                  bottom: 80,
                  child: _GlowOrb(
                    size: 280,
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

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
            blurRadius: size * 0.42,
            spreadRadius: size * 0.14,
          ),
        ],
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  final Brightness brightness;

  const _PortfolioHero({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return _NoirPanel(
      brightness: brightness,
      padding: const EdgeInsets.fromLTRB(38, 34, 28, 34),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;

          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 24,
            spacing: 24,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CUMULATIVE SAVINGS PORTFOLIO',
                    style: GoogleFonts.inter(
                      color: PayRouteColors.dashboardAccentOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$1,428,590.',
                              style: GoogleFonts.inter(
                                color: textPrimary,
                                fontSize: compact ? 52 : 62,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2.8,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: '42',
                              style: GoogleFonts.inter(
                                color: textSecondary,
                                fontSize: compact ? 34 : 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _MiniMetricPill(brightness: brightness),
                    ],
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 28,
                runSpacing: 18,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MONTHLY GROWTH',
                        style: GoogleFonts.inter(
                          color: textSecondary.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '+\$14,205.00',
                        style: GoogleFonts.inter(
                          color: PayRouteColors.dashboardAccentOrange,
                          fontSize: compact ? 24 : 26,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              color: PayRouteColors.dashboardAccentOrange
                                  .withValues(alpha: 0.18),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _CreateGoalButton(brightness: brightness),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniMetricPill extends StatelessWidget {
  final Brightness brightness;

  const _MiniMetricPill({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.show_chart_rounded,
            color: PayRouteColors.dashboardAccentOrange,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '12.4%\nROI',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: PayRouteColors.dashboardAccentOrange,
              fontSize: 13,
              height: 1.05,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateGoalButton extends StatelessWidget {
  final Brightness brightness;

  const _CreateGoalButton({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFC159), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(36),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, color: Colors.black, size: 26),
                const SizedBox(width: 14),
                Text(
                  'Create\nNew\nGoal',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalsShowcase extends StatelessWidget {
  final Brightness brightness;

  const _GoalsShowcase({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    const goals = [
      _GoalCardData(
        title: 'Emergency Fund',
        subtitle: 'Automated volatility cushion',
        progress: 0.85,
        amount: '\$42,500',
        goal: '\$50,000',
        icon: Icons.auto_awesome_rounded,
        accent: PayRouteColors.dashboardAccentOrange,
        primary: true,
      ),
      _GoalCardData(
        title: 'Expansion',
        subtitle: 'Q4 Market Acquisition',
        progress: 0.32,
        amount: '\$320,000',
        goal: '\$1M',
        icon: Icons.work_rounded,
        accent: Color(0xFF8E939D),
      ),
      _GoalCardData(
        title: 'Tax Reserve',
        subtitle: 'Fiscal year automated accrual',
        progress: 0.68,
        amount: '\$156,400',
        goal: '\$230,000',
        icon: Icons.receipt_long_rounded,
        accent: Color(0xFF90959F),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PORTFOLIO ALLOCATION',
          style: GoogleFonts.inter(
            color: PayRouteColors.dashboardAccentOrange,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                'Active Saving Goals',
                style: GoogleFonts.inter(
                  color: textPrimary,
                  fontSize: 46,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.8,
                ),
              ),
            ),
            _RoundNavButton(
              brightness: brightness,
              icon: Icons.chevron_left_rounded,
            ),
            const SizedBox(width: 12),
            _RoundNavButton(
              brightness: brightness,
              icon: Icons.chevron_right_rounded,
            ),
          ],
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 1100;
            final stacked = constraints.maxWidth < 760;

            if (stacked) {
              return Column(
                children: [
                  for (int i = 0; i < goals.length; i++) ...[
                    _GoalCard(brightness: brightness, data: goals[i]),
                    if (i != goals.length - 1) const SizedBox(height: 20),
                  ],
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _GoalCard(brightness: brightness, data: goals[0]),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: _GoalCard(
                    brightness: brightness,
                    data: goals[1],
                    compact: narrow,
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: _GoalCard(
                    brightness: brightness,
                    data: goals[2],
                    compact: narrow,
                  ),
                ),
              ],
            );
          },
        ),
        if (textSecondary == Colors.transparent) const SizedBox.shrink(),
      ],
    );
  }
}

class _RoundNavButton extends StatelessWidget {
  final Brightness brightness;
  final IconData icon;

  const _RoundNavButton({required this.brightness, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: DashboardPalette.surface(brightness).withValues(alpha: 0.86),
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isDark
                  ? Colors.black.withValues(alpha: 0.88)
                  : Colors.black.withValues(alpha: 0.22),
        ),
      ),
      child: Icon(icon, color: DashboardPalette.textSecondary(brightness)),
    );
  }
}

class _GoalCardData {
  final String title;
  final String subtitle;
  final double progress;
  final String amount;
  final String goal;
  final IconData icon;
  final Color accent;
  final bool primary;

  const _GoalCardData({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.amount,
    required this.goal,
    required this.icon,
    required this.accent,
    this.primary = false,
  });
}

class _GoalCard extends StatelessWidget {
  final Brightness brightness;
  final _GoalCardData data;
  final bool compact;

  const _GoalCard({
    required this.brightness,
    required this.data,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final accent = data.accent;
    final baseBorder =
        isDark
            ? Colors.black.withValues(alpha: 0.86)
            : Colors.black.withValues(alpha: 0.18);

    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: DashboardPalette.surface(brightness).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color:
              data.primary
                  ? accent.withValues(alpha: 0.95)
                  : baseBorder,
          width: data.primary ? 1.4 : 1,
        ),
        boxShadow: [
          if (data.primary)
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            if (data.primary)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(34),
                      bottomLeft: Radius.circular(34),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: -36,
              top: -36,
              child: _GlowOrb(
                size: 130,
                color: accent.withValues(alpha: data.primary ? 0.1 : 0.03),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(34, 30, 30, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withValues(alpha: 0.12),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Icon(data.icon, color: accent, size: 28),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color:
                                isDark
                                    ? Colors.black.withValues(alpha: 0.82)
                                    : Colors.black.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bolt_rounded, color: accent, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              'INTELLIGENCE',
                              style: GoogleFonts.inter(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Text(
                    data.title,
                    style: GoogleFonts.inter(
                      color: textPrimary,
                      fontSize: compact ? 22 : 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.inter(
                      color: textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'CURRENT PROGRESS',
                    style: GoogleFonts.inter(
                      color: textSecondary.withValues(alpha: 0.72),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: data.progress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.26),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(data.progress * 100).round()}%',
                        style: GoogleFonts.inter(
                          color: data.primary ? accent : textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 10,
                    runSpacing: 6,
                    children: [
                      Text(
                        data.amount,
                        style: GoogleFonts.inter(
                          color: textPrimary,
                          fontSize: compact ? 22 : 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'GOAL: ${data.goal}',
                        style: GoogleFonts.inter(
                          color: textSecondary.withValues(alpha: 0.56),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
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
    );
  }
}

class _InsightsGrid extends StatelessWidget {
  final Brightness brightness;

  const _InsightsGrid({required this.brightness});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 980;

        if (stacked) {
          return Column(
            children: [
              _PerformancePanel(brightness: brightness),
              const SizedBox(height: 24),
              _RecentContributionPanel(brightness: brightness),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: _PerformancePanel(brightness: brightness)),
            const SizedBox(width: 28),
            Expanded(
              flex: 3,
              child: _RecentContributionPanel(brightness: brightness),
            ),
          ],
        );
      },
    );
  }
}

class _PerformancePanel extends StatelessWidget {
  final Brightness brightness;

  const _PerformancePanel({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    const bars = [0.34, 0.40, 0.32, 0.52, 0.60, 0.56, 0.72, 0.78, 0.75, 0.90];

    return _NoirPanel(
      brightness: brightness,
      padding: const EdgeInsets.fromLTRB(38, 34, 38, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goal Performance',
                      style: GoogleFonts.inter(
                        color: textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NET GROWTH ACROSS AUTOMATED CHANNELS',
                      style: GoogleFonts.inter(
                        color: textSecondary.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              _RangeSelector(brightness: brightness),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 440,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                final active = index >= 6;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 320 * bars[index] + 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                                active
                                    ? [
                                      PayRouteColors.dashboardAccentOrange
                                          .withValues(alpha: 0.4),
                                      PayRouteColors.dashboardAccentOrange
                                          .withValues(alpha: 0.18),
                                    ]
                                    : [
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.white.withValues(alpha: 0.04),
                                    ],
                          ),
                          border: Border.all(
                            color:
                                active
                                    ? PayRouteColors.dashboardAccentOrange
                                        .withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.05),
                          ),
                          boxShadow:
                              active
                                  ? [
                                    BoxShadow(
                                      color: PayRouteColors
                                          .dashboardAccentOrange
                                          .withValues(alpha: 0.14),
                                      blurRadius: 26,
                                      offset: const Offset(0, 14),
                                    ),
                                  ]
                                  : null,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _ChartLabel(label: 'WK 01'),
              _ChartLabel(label: 'WK 02'),
              _ChartLabel(label: 'WK 03'),
              _ChartLabel(label: 'WK 04'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  final Brightness brightness;

  const _RangeSelector({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final items = ['1M', '6M', '1Y'];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: DashboardPalette.surfaceMuted(
          brightness,
        ).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: DashboardPalette.border(brightness).withValues(alpha: 0.86),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in items)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color:
                    item == '1M'
                        ? PayRouteColors.dashboardAccentOrange
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                boxShadow:
                    item == '1M'
                        ? [
                          BoxShadow(
                            color: PayRouteColors.dashboardAccentOrange
                                .withValues(alpha: 0.24),
                            blurRadius: 18,
                          ),
                        ]
                        : null,
              ),
              child: Text(
                item,
                style: GoogleFonts.inter(
                  color:
                      item == '1M'
                          ? Colors.black
                          : DashboardPalette.textSecondary(brightness),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartLabel extends StatelessWidget {
  final String label;

  const _ChartLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: DashboardPalette.textSecondary(
          Theme.of(context).brightness,
        ).withValues(alpha: 0.52),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
      ),
    );
  }
}

class _RecentContributionPanel extends StatelessWidget {
  final Brightness brightness;

  const _RecentContributionPanel({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    const items = [
      _ContributionData(
        title: 'Round-up\nTransfer',
        subtitle: 'MERCHANT:\nSTARBUCKS',
        amount: '+\$0.85',
        icon: Icons.all_inclusive_rounded,
      ),
      _ContributionData(
        title: 'Profit\nRule: 10%',
        subtitle: 'FROM\nDIVIDENDS',
        amount: '+\$1,240.00',
        icon: Icons.tune_rounded,
      ),
      _ContributionData(
        title: 'Automated\nRouting',
        subtitle: 'SALARY SWEEP',
        amount: '+\$5,000.00',
        icon: Icons.bolt_rounded,
      ),
      _ContributionData(
        title: 'Round-up\nTransfer',
        subtitle: 'MERCHANT:\nWHOLE FOODS',
        amount: '+\$1.42',
        icon: Icons.all_inclusive_rounded,
      ),
    ];

    return _NoirPanel(
      brightness: brightness,
      padding: const EdgeInsets.fromLTRB(38, 34, 38, 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent\nContributions',
            style: GoogleFonts.inter(
              color: textPrimary,
              fontSize: 24,
              height: 1.08,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 26),
          for (int i = 0; i < items.length; i++) ...[
            _ContributionTile(brightness: brightness, data: items[i]),
            if (i != items.length - 1) const SizedBox(height: 22),
          ],
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: DashboardPalette.border(
                  brightness,
                ).withValues(alpha: 0.9),
                style: BorderStyle.solid,
              ),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              'VIEW FULL HISTORY',
              style: GoogleFonts.inter(
                color: textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionData {
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;

  const _ContributionData({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
  });
}

class _ContributionTile extends StatelessWidget {
  final Brightness brightness;
  final _ContributionData data;

  const _ContributionTile({required this.brightness, required this.data});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DashboardPalette.surfaceMuted(
              brightness,
            ).withValues(alpha: 0.9),
            border: Border.all(
              color: DashboardPalette.border(brightness).withValues(alpha: 0.8),
            ),
          ),
          child: Icon(
            data.icon,
            color: PayRouteColors.dashboardAccentOrange,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: GoogleFonts.inter(
                  color: textPrimary,
                  fontSize: 16,
                  height: 1.18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.subtitle,
                style: GoogleFonts.inter(
                  color: textSecondary.withValues(alpha: 0.64),
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          data.amount,
          style: GoogleFonts.inter(
            color: PayRouteColors.dashboardAccentOrange,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final Brightness brightness;

  const _StatusStrip({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    return _NoirPanel(
      brightness: brightness,
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 22),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 18,
        spacing: 28,
        children: [
          _StatusItem(
            label: 'FISCAL YEAR PROGRESS',
            value: 'Q3 In-Progress',
            brightness: brightness,
            valueColor: textPrimary,
          ),
          _StatusItem(
            label: 'PORTFOLIO TIER',
            value: 'Obsidian Elite',
            brightness: brightness,
            valueColor: PayRouteColors.dashboardAccentOrange,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Assets secured by NoirSec Multi-layer protocol',
                style: GoogleFonts.inter(
                  color: textSecondary.withValues(alpha: 0.72),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.verified_user_rounded,
                color: textSecondary.withValues(alpha: 0.72),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Brightness brightness;
  final Color valueColor;

  const _StatusItem({
    required this.label,
    required this.value,
    required this.brightness,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: DashboardPalette.textSecondary(
              brightness,
            ).withValues(alpha: 0.66),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            color: valueColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NoirPanel extends StatelessWidget {
  final Brightness brightness;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const _NoirPanel({
    required this.brightness,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 40,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final surface = DashboardPalette.surface(brightness);
    final panelBorder =
        isDark
            ? Colors.black.withValues(alpha: 0.86)
            : Colors.black.withValues(alpha: 0.18);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: surface.withValues(alpha: isDark ? 0.84 : 0.94),
            border: Border.all(color: panelBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.08),
                blurRadius: 36,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
