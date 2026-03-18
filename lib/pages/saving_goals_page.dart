import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class SavingGoalsPage extends StatefulWidget {
  const SavingGoalsPage({super.key});

  @override
  State<SavingGoalsPage> createState() => _SavingGoalsPageState();
}

class _SavingGoalsPageState extends State<SavingGoalsPage> {
  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Saving Goals',
      mobileTitle: 'Saving Goals',
      desktopHeader: _buildDesktopHeader(context, b),
      background: Container(color: DashboardPalette.bg(b)),
      child: DefaultTextStyle(
        style: GoogleFonts.outfit(color: DashboardPalette.textPrimary(b)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPortfolioSection(context, b),
                  const SizedBox(height: 32),
                  _buildActiveGoalsSection(context, b),
                  const SizedBox(height: 32),
                  _buildBottomGrid(context, b),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context, Brightness b) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: DashboardPalette.bg(b),
        border: Border(bottom: BorderSide(color: DashboardPalette.border(b))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: DashboardPalette.surfaceMuted(b),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: DashboardPalette.border(b)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: DashboardPalette.iconMuted(b), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.outfit(color: DashboardPalette.textPrimary(b), fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search wealth assets...',
                              hintStyle: GoogleFonts.outfit(color: DashboardPalette.textSecondary(b), fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.only(bottom: 2),
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
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none, color: DashboardPalette.iconMuted(b), size: 24),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings_outlined, color: DashboardPalette.iconMuted(b), size: 24),
              ),
              const SizedBox(width: 24),
              Container(width: 1, height: 24, color: DashboardPalette.border(b)),
              const SizedBox(width: 24),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final user = authProvider.userModel;
                  final firebaseUser = authProvider.firebaseUser;
                  final displayName = user?.displayName ?? firebaseUser?.email?.split('@')[0] ?? 'User';
                  final displayRole = user?.displayRole ?? 'PRO MEMBER';
                  
                  return Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            displayName,
                            style: GoogleFonts.outfit(color: DashboardPalette.textPrimary(b), fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            displayRole.toUpperCase(),
                            style: GoogleFonts.outfit(color: PayRouteColors.vibrantOrange, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.3)),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCRYATv-tHT6ebOeiuCweeIOsYU4q7RG1QKbjHDJ0vIut67A2lDnKrmyAo977Dz4A9-cdFLlwE6HkI9lMm-QchNdbfEcZ_McEWKG4-c4bkdphQPEZ6IR7ccFPng9byAd0eWEY6pFlhuDwlSZJHjv-jGo7yNQ4PLg16llZtTZfeGhA6xB1p1eHE_9VUafTe1eXA1u_TOCnFYzeeRY_Ye8VQ0vd-FdhQMPmU_2LH2hiOsVZevSagEyxQV5L0XHucFLLkCARDAp5QrRxX3'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel(BuildContext context, Brightness b, {required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DashboardPalette.surface(b),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DashboardPalette.border(b)),
        boxShadow: b == Brightness.light 
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] 
            : null,
      ),
      child: child,
    );
  }

  Widget _buildPortfolioSection(BuildContext context, Brightness b) {
    return _buildGlassPanel(
      context, b,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: isWide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CUMULATIVE SAVINGS PORTFOLIO',
                          style: GoogleFonts.outfit(
                            color: DashboardPalette.textSecondary(b),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '\$1,428,590.',
                                  style: GoogleFonts.outfit(
                                    color: DashboardPalette.textPrimary(b),
                                    fontSize: isWide ? 48 : 36,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                    height: 1.0,
                                  ),
                                ),
                                Text(
                                  '42',
                                  style: GoogleFonts.outfit(
                                    color: DashboardPalette.textSecondary(b),
                                    fontSize: isWide ? 30 : 22,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.trending_up, color: PayRouteColors.vibrantOrange, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '12.4% ROI',
                                    style: GoogleFonts.outfit(
                                      color: PayRouteColors.vibrantOrange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (!isWide) const SizedBox(height: 24),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: isWide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MONTHLY GROWTH',
                              style: GoogleFonts.outfit(
                                color: DashboardPalette.textSecondary(b),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            Text(
                              '+\$14,205.00',
                              style: GoogleFonts.outfit(
                                color: PayRouteColors.vibrantOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'Create New Goal',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PayRouteColors.vibrantOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGoalsSection(BuildContext context, Brightness b) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Saving Goals',
              style: GoogleFonts.outfit(
                color: DashboardPalette.textPrimary(b),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                _buildGlassPanel(
                  context, b,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.chevron_left, color: DashboardPalette.textSecondary(b), size: 20),
                ),
                const SizedBox(width: 8),
                _buildGlassPanel(
                  context, b,
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.chevron_right, color: DashboardPalette.textSecondary(b), size: 20),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth > 1000) {
              crossAxisCount = 3;
            } else if (constraints.maxWidth > 650) {
              crossAxisCount = 2;
            }
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.3,
              children: [
                _buildGoalCard(
                  context, b,
                  title: 'Emergency Fund',
                  subtitle: 'Automated volatility cushion',
                  progress: 0.85,
                  amount: '\$42,500',
                  target: '\$50,000',
                  icon: Icons.emergency,
                  isPrimary: true,
                ),
                _buildGoalCard(
                  context, b,
                  title: 'Expansion',
                  subtitle: 'Q4 Market Acquisition',
                  progress: 0.32,
                  amount: '\$320,000',
                  target: '\$1,000,000',
                  icon: Icons.business_center,
                  isPrimary: false,
                ),
                _buildGoalCard(
                  context, b,
                  title: 'Tax Reserve',
                  subtitle: 'Fiscal year automated accrual',
                  progress: 0.68,
                  amount: '\$156,400',
                  target: '\$230,000',
                  icon: Icons.receipt_long,
                  isPrimary: false,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGoalCard(
    BuildContext context, 
    Brightness b, {
    required String title,
    required String subtitle,
    required double progress,
    required String amount,
    required String target,
    required IconData icon,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: DashboardPalette.surface(b),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isPrimary ? PayRouteColors.vibrantOrange : PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
            width: 4,
          ),
          top: BorderSide(color: DashboardPalette.border(b)),
          right: BorderSide(color: DashboardPalette.border(b)),
          bottom: BorderSide(color: DashboardPalette.border(b)),
        ),
        boxShadow: b == Brightness.light 
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))] 
            : null,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: PayRouteColors.vibrantOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: PayRouteColors.vibrantOrange, size: 28),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
                      border: Border.all(color: PayRouteColors.vibrantOrange.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: PayRouteColors.vibrantOrange, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'INTELLIGENCE',
                          style: GoogleFonts.outfit(
                            color: PayRouteColors.vibrantOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textPrimary(b),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textSecondary(b),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Progress',
                    style: GoogleFonts.outfit(color: DashboardPalette.textSecondary(b), fontSize: 14),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.outfit(
                      color: PayRouteColors.vibrantOrange,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: DashboardPalette.surfaceMuted(b),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPrimary
                            ? PayRouteColors.vibrantOrange
                            : PayRouteColors.vibrantOrange.withValues(alpha: progress > 0.5 ? 0.8 : 0.6),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: isPrimary
                            ? [
                                BoxShadow(
                                  color: PayRouteColors.vibrantOrange.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textPrimary(b),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Goal: $target',
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textSecondary(b),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGrid(BuildContext context, Brightness b) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: isWide ? 2 : 0,
              child: _buildGoalPerformance(context, b),
            ),
            if (isWide) const SizedBox(width: 32) else const SizedBox(height: 32),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _buildRecentContributions(context, b),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalPerformance(BuildContext context, Brightness b) {
    return _buildGlassPanel(
      context, b,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal Performance',
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textPrimary(b),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Net growth across all automated channels',
                    style: GoogleFonts.outfit(
                      color: DashboardPalette.textSecondary(b),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: DashboardPalette.surfaceMuted(b),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildTimeFilter(b, '1M', true),
                    _buildTimeFilter(b, '6M', false),
                    _buildTimeFilter(b, '1Y', false),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 256,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.40, false),
                _buildBar(0.45, false),
                _buildBar(0.38, false),
                _buildBar(0.55, false),
                _buildBar(0.62, false),
                _buildBar(0.58, false),
                _buildBar(0.75, true, 0.6),
                _buildBar(0.82, true, 0.7),
                _buildBar(0.78, true, 0.6),
                _buildBar(0.95, true, 1.0),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['WK 01', 'WK 02', 'WK 03', 'WK 04'])
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.outfit(
                        color: DashboardPalette.textSecondary(b),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(Brightness b, String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? (b == Brightness.dark ? DashboardPalette.surface(b) : Colors.white) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: isSelected ? DashboardPalette.textPrimary(b) : DashboardPalette.textSecondary(b),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBar(double factor, bool isHighlighted, [double opacityScale = 0.4]) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: FractionallySizedBox(
          heightFactor: factor,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  PayRouteColors.vibrantOrange.withValues(alpha: 0.05),
                  PayRouteColors.vibrantOrange.withValues(alpha: isHighlighted ? 0.10 : 0.20),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              border: Border(
                top: BorderSide(
                  color: PayRouteColors.vibrantOrange.withValues(alpha: opacityScale),
                  width: 2,
                ),
              ),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: PayRouteColors.vibrantOrange.withValues(alpha: opacityScale * 0.25),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, -10),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentContributions(BuildContext context, Brightness b) {
    return _buildGlassPanel(
      context, b,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Contributions',
            style: GoogleFonts.outfit(
              color: DashboardPalette.textPrimary(b),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildContributionItem(
            b,
            icon: Icons.all_inclusive,
            title: 'Round-up Transfer',
            subtitle: 'From Merchant: Starbucks',
            amount: '+\$0.85',
          ),
          const SizedBox(height: 20),
          _buildContributionItem(
            b,
            icon: Icons.rule,
            title: 'Profit Rule: 10%',
            subtitle: 'Direct from Dividends',
            amount: '+\$1,240.00',
          ),
          const SizedBox(height: 20),
          _buildContributionItem(
            b,
            icon: Icons.bolt,
            title: 'Automated Routing',
            subtitle: 'Primary Salary Sweep',
            amount: '+\$5,000.00',
          ),
          const SizedBox(height: 20),
          _buildContributionItem(
            b,
            icon: Icons.all_inclusive,
            title: 'Round-up Transfer',
            subtitle: 'From Merchant: Whole Foods',
            amount: '+\$1.42',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: DashboardPalette.textSecondary(b),
                side: const BorderSide(color: Colors.transparent, style: BorderStyle.none),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ).copyWith(
                side: WidgetStateProperty.resolveWith(
                  (states) => BorderSide(color: DashboardPalette.border(b)),
                ),
              ),
              child: Text(
                'VIEW FULL HISTORY',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionItem(
    Brightness b, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: DashboardPalette.surfaceMuted(b),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_outline, color: PayRouteColors.vibrantOrange, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textPrimary(b),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  color: DashboardPalette.textSecondary(b),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.outfit(
            color: PayRouteColors.vibrantOrange,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
