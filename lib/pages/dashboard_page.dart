import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _quickActionsOpen = true;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Home',
      background: const _GlowBackground(),
      desktopHeader: LayoutBuilder(
        builder: (context, constraints) {
          final canShowAside = constraints.maxWidth >= 1200;
          final showAside = canShowAside && _quickActionsOpen;
          return _DashboardHeader(
            brightness: b,
            quickActionsAvailable: canShowAside,
            quickActionsOpen: showAside,
            onQuickActionsPressed: () {
              if (!canShowAside) {
                _showQuickActionsModal(context, brightness: b);
                return;
              }
              setState(() => _quickActionsOpen = !_quickActionsOpen);
            },
          );
        },
      ),
      mobileTitle: 'Dashboard',
      mobileSubtitle: 'Real-time financial routing status',
      mobileActions: [
        IconButton(
          onPressed: () => _showQuickActionsModal(context, brightness: b),
          style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent)),
          icon: const Icon(Icons.bolt, color: PayRouteColors.dashboardPrimary),
          tooltip: 'Quick actions',
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final canShowAside = constraints.maxWidth >= 1200;
          final showAside = canShowAside && _quickActionsOpen;
          final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BalanceCard(brightness: b),
                      const SizedBox(height: 24),
                      _LiveHealthSection(brightness: b),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerRight,
                child: showAside ? SizedBox(width: 360, child: _AsidePanel(brightness: b)) : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showQuickActionsModal(BuildContext context, {required Brightness brightness}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bg = DashboardPalette.bg(brightness);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 620),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: DashboardPalette.border(brightness)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _AsidePanel(brightness: brightness, showLeftBorder: false),
            ),
          ),
        );
      },
    );
  }
}

class _GlowBackground extends StatelessWidget {
  const _GlowBackground();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    // In light mode we want a crisp, clear background (no glows/gradients).
    if (b == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(b);
    final neutralGlow = b == Brightness.dark ? Colors.white.withValues(alpha: 0.035) : Colors.black.withValues(alpha: 0.04);
    final neutralGlowSoft = b == Brightness.dark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.025);
    return Stack(
      children: [
        Positioned(
          top: -160,
          left: -120,
          child: _GlowCircle(color: neutralGlow, size: 520),
        ),
        Positioned(
          top: -120,
          right: -160,
          child: _GlowCircle(color: neutralGlowSoft, size: 460),
        ),
        Positioned(
          bottom: -40,
          left: -20,
          right: -20,
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [bg, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(color: color, blurRadius: 120, spreadRadius: 40),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final Brightness brightness;
  final bool quickActionsAvailable;
  final bool quickActionsOpen;
  final VoidCallback onQuickActionsPressed;

  const _DashboardHeader({
    required this.brightness,
    required this.quickActionsAvailable,
    required this.quickActionsOpen,
    required this.onQuickActionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bg = DashboardPalette.bg(brightness);
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isTight = w < 1080;

        final titleBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard Overview', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 22), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('Real-time financial routing status', style: GoogleFonts.inter(color: textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        );

        final searchPill = Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: DashboardPalette.surfaceMuted(brightness),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
          ),
          width: 260,
          height: 42,
          child: Row(
            children: [
              Icon(Icons.search, color: DashboardPalette.iconMuted(brightness), size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('Search transactions...', style: GoogleFonts.inter(color: textSecondary, fontSize: 13), overflow: TextOverflow.ellipsis)),
            ],
          ),
        );

        final notif = Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1), shape: BoxShape.circle),
              child: Icon(Icons.notifications, color: DashboardPalette.iconMuted(brightness)),
            ),
            Positioned(top: 6, right: 6, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
          ],
        );

        final avatar = Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: border),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDIaCwDhxVyzTNPQbH6aaAvTB4kSusDv5bbYxEyGKb-1TPNRJk91FgmYmUXT0i8vx_rEyeiQxswISwl2k6YhPpF6d7qSqQ0mrrCPu_XpvzN_trba7SfY6EpmkKfdalH8K0Mm6lt6rVQdGweDb1PDRrudp21TTAMVmdeBLRsYyk0GZI8DhfWA-L90GYjvQbC3HfDiejXV3gCK4z_SmqjrS3TWliIRISkjuUcRqa_TlHL6rFb-MaL5LgFCZVt6Rl_zueXYSIRlwEvITx8',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: PayRouteColors.dashboardGreen, shape: BoxShape.circle, border: Border.all(color: bg, width: 2)),
              ),
            ),
          ],
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: bg.withValues(alpha: 0.84),
            border: Border(bottom: BorderSide(color: border)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.35 : 0.06), blurRadius: 16, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: 16),
              if (!isTight) ...[
                searchPill,
                const SizedBox(width: 16),
              ],
              _QuickActionsHeaderButton(
                brightness: brightness,
                available: quickActionsAvailable,
                isOpen: quickActionsOpen,
                onPressed: onQuickActionsPressed,
              ),
              const SizedBox(width: 12),
              notif,
              const SizedBox(width: 12),
              if (!isTight) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tunde A.', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                    Text('Admin', style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 12),
              ],
              avatar,
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionsHeaderButton extends StatelessWidget {
  final Brightness brightness;
  final bool available;
  final bool isOpen;
  final VoidCallback onPressed;

  const _QuickActionsHeaderButton({required this.brightness, required this.available, required this.isOpen, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final border = DashboardPalette.border(brightness);
    final surface = DashboardPalette.surfaceMuted(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);

    final activeColor = PayRouteColors.dashboardPrimary;
    final bg = isOpen ? activeColor.withValues(alpha: 0.14) : surface;
    final fg = isOpen ? activeColor : textSecondary;

    return Semantics(
      button: true,
      label: available ? 'Toggle quick actions panel' : 'Open quick actions',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isOpen ? activeColor.withValues(alpha: 0.24) : border),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: Icon(
                    isOpen ? Icons.close : Icons.bolt,
                    key: ValueKey(isOpen),
                    size: 18,
                    color: fg,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Quick Actions', style: GoogleFonts.inter(color: fg, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final Brightness brightness;

  const _BalanceCard({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        final currencyChip = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('NGN', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Icon(Icons.expand_more, color: textSecondary),
            ],
          ),
        );

        final amountRow = FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₦4,250,000', style: GoogleFonts.inter(color: textPrimary, fontSize: isCompact ? 36 : 42, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Text('.00', style: GoogleFonts.inter(color: textSecondary, fontSize: isCompact ? 20 : 24)),
            ],
          ),
        );

        final headerLeft = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Balance', style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 12)),
                const SizedBox(width: 8),
                const Icon(Icons.visibility, color: Color(0xFF64748B), size: 18),
              ],
            ),
            const SizedBox(height: 8),
            amountRow,
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Color(0xFF22C55E), size: 16),
                      const SizedBox(width: 6),
                      Text('+12.5%', style: GoogleFonts.inter(color: const Color(0xFF22C55E), fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                ),
                Text('vs last week', style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
              ],
            ),
          ],
        );

        return Container(
          decoration: BoxDecoration(
            color: surface.withValues(alpha: brightness == Brightness.dark ? 0.72 : 0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: border),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: brightness == Brightness.dark ? 0.35 : 0.08), blurRadius: 30, offset: const Offset(0, 20))],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCompact) ...[
                headerLeft,
                const SizedBox(height: 14),
                Align(alignment: Alignment.centerLeft, child: currencyChip),
              ] else ...[
                Row(children: [Expanded(child: headerLeft), const SizedBox(width: 16), currencyChip]),
              ],
              const SizedBox(height: 24),
              _WeeklyBarChart(brightness: brightness),
            ],
          ),
        );
      },
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final Brightness brightness;

  const _WeeklyBarChart({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final bars = <_BarData>[
      const _BarData(label: 'Mon', percent: 0.30, value: '₦1.2M'),
      const _BarData(label: 'Tue', percent: 0.45, value: '₦1.8M'),
      const _BarData(label: 'Wed', percent: 0.35, value: '₦1.4M'),
      const _BarData(label: 'Thu', percent: 0.60, value: '₦2.4M'),
      const _BarData(label: 'Fri', percent: 0.50, value: '₦2.0M'),
      const _BarData(label: 'Sat', percent: 0.80, value: '₦3.2M'),
      const _BarData(label: 'Sun', percent: 0.90, value: '₦3.6M'),
    ];

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars
            .map(
              (bar) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Tooltip(
                        message: '${bar.label}: ${bar.value}',
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 140 * bar.percent,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: bar.percent > 0.7
                                ? PayRouteColors.dashboardPrimary
                                : PayRouteColors.dashboardPrimary.withValues(alpha: 0.3 + bar.percent * 0.6),
                            boxShadow: bar.percent > 0.7
                                ? [
                                    BoxShadow(
                                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5),
                                      blurRadius: 18,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(bar.label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BarData {
  final String label;
  final double percent;
  final String value;

  const _BarData({required this.label, required this.percent, required this.value});
}

class _LiveHealthSection extends StatelessWidget {
  final Brightness brightness;

  const _LiveHealthSection({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(brightness);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final crossAxisCount = w < 560
            ? 1
            : w < 900
                ? 2
                : 3;
        final aspect = w < 560 ? 2.4 : 1.9;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Live Rail Health', style: GoogleFonts.inter(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                const _PingDot(),
                const Spacer(),
                Text('View System Status', style: GoogleFonts.inter(color: PayRouteColors.dashboardPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspect,
              children: const [
                _HealthCard(
                  title: 'M-Pesa',
                  subtitle: 'Direct API Integration',
                  statusLabel: '99.9% Uptime',
                  statusColor: Color(0xFF22C55E),
                  barPercent: 0.99,
                  icon: Icons.wifi,
                ),
                _HealthCard(
                  title: 'Flutterwave',
                  subtitle: 'Card Processing',
                  statusLabel: 'Operational',
                  statusColor: PayRouteColors.dashboardPrimary,
                  barPercent: 1,
                  icon: Icons.waves,
                ),
                _HealthCard(
                  title: 'Banks',
                  subtitle: 'ACH / NIP Rails',
                  statusLabel: 'High Traffic',
                  statusColor: PayRouteColors.dashboardAccentOrange,
                  barPercent: 0.7,
                  icon: Icons.account_balance,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PingDot extends StatelessWidget {
  const _PingDot();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String statusLabel;
  final Color statusColor;
  final double barPercent;
  final IconData icon;

  const _HealthCard({
    required this.title,
    required this.subtitle,
    required this.statusLabel,
    required this.statusColor,
    required this.barPercent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    return Container(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: b == Brightness.dark ? 0.72 : 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(icon, color: textPrimary.withValues(alpha: 0.10), size: 80),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.6), blurRadius: 12)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(statusLabel.toUpperCase(), style: GoogleFonts.inter(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                ],
              ),
              const SizedBox(height: 10),
              Text(title, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
              const Spacer(),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: textPrimary.withValues(alpha: b == Brightness.dark ? 0.08 : 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: barPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.6), blurRadius: 10)],
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
}

class _AsidePanel extends StatelessWidget {
  final Brightness brightness;
  final bool showLeftBorder;

  const _AsidePanel({required this.brightness, this.showLeftBorder = true});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.62 : 0.95),
        border: showLeftBorder ? Border(left: BorderSide(color: border)) : null,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Actions', style: GoogleFonts.inter(color: textSecondary, letterSpacing: 1.2, fontSize: 11, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _QuickActionButton(label: 'Send', icon: Icons.send, color: PayRouteColors.dashboardPrimary, brightness: brightness)),
                SizedBox(width: 10),
                Expanded(child: _QuickActionButton(label: 'Request', icon: Icons.call_received, color: Color(0xFF22C55E), brightness: brightness)),
                SizedBox(width: 10),
                Expanded(child: _QuickActionButton(label: 'Exchange', icon: Icons.currency_exchange, color: PayRouteColors.dashboardAccentOrange, brightness: brightness)),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Text('Recent Activity', style: GoogleFonts.inter(color: textSecondary, letterSpacing: 1.2, fontSize: 11, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('See All', style: GoogleFonts.inter(color: PayRouteColors.dashboardPrimary, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            _ActivityItem(title: 'Netflix', timestamp: 'Today, 9:41 AM', amount: '-\$12.00', color: Colors.red, brightness: brightness),
            _ActivityItem(title: 'Jumia Refund', timestamp: 'Yesterday, 4:20 PM', amount: '+\$150.00', color: Color(0xFF22C55E), brightness: brightness),
            _ActivityItem(title: 'Airtime', timestamp: 'Yesterday, 2:15 PM', amount: '-\$5.00', color: PayRouteColors.dashboardPrimary, brightness: brightness),
            _ActivityItem(title: 'Electricity', timestamp: 'Oct 24, 8:00 AM', amount: '-\$45.00', color: Colors.orange, brightness: brightness),
            _ActivityItem(title: 'Uber Ride', timestamp: 'Oct 23, 11:30 PM', amount: '-\$15.50', color: Colors.purple, brightness: brightness),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [PayRouteColors.dashboardPrimary.withValues(alpha: 0.15), PayRouteColors.dashboardPrimary.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upgrade to Noir+', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text('Get lower fees on transfers.', style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: PayRouteColors.dashboardPrimary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Text('Upgrade Now', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
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

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  final Brightness brightness;

  const _QuickActionButton({required this.label, required this.icon, required this.color, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 16)],
            ),
            child: Icon(icon, color: brightness == Brightness.dark ? Colors.white : Colors.black, size: 22),
          ),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.inter(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String timestamp;
  final String amount;
  final Color color;

  final Brightness brightness;

  const _ActivityItem({required this.title, required this.timestamp, required this.amount, required this.color, required this.brightness});

  @override
  Widget build(BuildContext context) {
    final isCredit = amount.startsWith('+');
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bolt, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 14)),
                Text(timestamp, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              color: isCredit ? const Color(0xFF22C55E) : textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}