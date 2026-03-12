import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:payroute_desktop/widgets/animated_background.dart';
import 'package:payroute_desktop/utils/animations.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

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
          style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
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

class _GlowBackground extends StatefulWidget {
  const _GlowBackground();

  @override
  State<_GlowBackground> createState() => _GlowBackgroundState();
}

class _GlowBackgroundState extends State<_GlowBackground>
    with TickerProviderStateMixin {
  late AnimationController _orbController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    // In light mode we want a crisp, clear background (no glows/gradients).
    if (b == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(b);
    
    return Stack(
      children: [
        // Animated floating orbs
        AnimatedBuilder(
          animation: Listenable.merge([_orbController, _pulseController]),
          builder: (context, _) {
            final size = MediaQuery.of(context).size;
            final orbOffset = _orbController.value * 2 * pi;
            final pulseScale = 0.8 + _pulseController.value * 0.4;
            
            return Stack(
              children: [
                // Primary orange orb (top-left)
                Positioned(
                  top: -100 + sin(orbOffset) * 30,
                  left: -80 + cos(orbOffset * 0.7) * 20,
                  child: Container(
                    width: 400 * pulseScale,
                    height: 400 * pulseScale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          PayRouteColors.vibrantOrange.withValues(alpha: 0.08 + _pulseController.value * 0.04),
                          PayRouteColors.vibrantOrange.withValues(alpha: 0.02),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Secondary cyan orb (top-right)
                Positioned(
                  top: -60 + cos(orbOffset) * 25,
                  right: -100 + sin(orbOffset * 0.8) * 30,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          PayRouteColors.electricGlow.withValues(alpha: 0.05 + _pulseController.value * 0.03),
                          PayRouteColors.electricGlow.withValues(alpha: 0.01),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Tertiary purple orb (bottom)
                Positioned(
                  bottom: -80 + sin(orbOffset * 1.2) * 20,
                  left: size.width * 0.3 + cos(orbOffset) * 40,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF8B5CF6).withValues(alpha: 0.04 + _pulseController.value * 0.02),
                          const Color(0xFF8B5CF6).withValues(alpha: 0.01),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        // Bottom gradient fade
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
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    final user = authProvider.userModel;
                    final firebaseUser = authProvider.firebaseUser;
                    final displayName = user?.displayName ?? firebaseUser?.email?.split('@')[0] ?? 'User';
                    final displayRole = user?.displayRole ?? 'User';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(displayName, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                        Text(displayRole, style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 12),
              ],
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final user = authProvider.userModel;
                  final firebaseUser = authProvider.firebaseUser;
                  final photoUrl = user?.photoUrl ?? firebaseUser?.photoURL;
                  return _UserAvatar(photoUrl: photoUrl, brightness: brightness, bg: bg, border: border);
                },
              ),
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
              Text('₦0', style: GoogleFonts.inter(color: textPrimary, fontSize: isCompact ? 36 : 42, fontWeight: FontWeight.w800)),
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
          ],
        );

        final topUpButton = _TopUpButton(brightness: brightness, isCompact: isCompact);

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
                Row(
                  children: [
                    currencyChip,
                    const SizedBox(width: 12),
                    Expanded(child: topUpButton),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(child: headerLeft),
                    const SizedBox(width: 16),
                    currencyChip,
                    const SizedBox(width: 12),
                    topUpButton,
                  ],
                ),
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

class _WeeklyBarChart extends StatefulWidget {
  final Brightness brightness;

  const _WeeklyBarChart({required this.brightness});

  @override
  State<_WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<_WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    final bars = <_BarData>[
      const _BarData(label: 'Mon', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Tue', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Wed', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Thu', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Fri', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Sat', percent: 0.0, value: '₦0'),
      const _BarData(label: 'Sun', percent: 0.0, value: '₦0'),
    ];

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(bars.length, (index) {
          final bar = bars[index];
          final isHovered = _hoveredIndex == index;
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: '${bar.label}: ${bar.value}',
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: bar.percent),
                        duration: Duration(milliseconds: 600 + index * 100),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 140 * value,
                            transform: Matrix4.identity()
                              ..scale(isHovered ? 1.05 : 1.0),
                            transformAlignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  PayRouteColors.dashboardPrimary,
                                  PayRouteColors.dashboardPrimary.withValues(alpha: 0.7),
                                ],
                              ),
                              boxShadow: isHovered
                                  ? [
                                      BoxShadow(
                                        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.6),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        spreadRadius: 0,
                                      ),
                                    ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.inter(
                        color: isHovered 
                          ? PayRouteColors.dashboardPrimary 
                          : textSecondary,
                        fontSize: 12,
                        fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
                      ),
                      child: Text(bar.label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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

class _LiveHealthSection extends StatefulWidget {
  final Brightness brightness;

  const _LiveHealthSection({required this.brightness});

  @override
  State<_LiveHealthSection> createState() => _LiveHealthSectionState();
}

class _LiveHealthSectionState extends State<_LiveHealthSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<PaymentRailData> _rails = [
    PaymentRailData(
      name: 'ACH Network',
      shortName: 'ACH',
      icon: Icons.account_balance,
      status: RailStatus.operational,
      latency: 23,
      uptime: 99.99,
      throughput: '12.4K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 15)),
      region: 'United States',
      description: 'Automated Clearing House - Bank transfers',
      recentEvents: [
        RailEvent(type: EventType.success, message: 'Batch processing completed', time: DateTime.now().subtract(const Duration(minutes: 5))),
        RailEvent(type: EventType.info, message: 'Scheduled maintenance window', time: DateTime.now().subtract(const Duration(hours: 2))),
      ],
      hourlyLatency: [21, 23, 22, 24, 23, 21, 20, 22, 23, 25, 24, 23],
    ),
    PaymentRailData(
      name: 'Wire Transfer',
      shortName: 'WIRE',
      icon: Icons.swap_horiz,
      status: RailStatus.operational,
      latency: 45,
      uptime: 99.95,
      throughput: '8.2K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 30)),
      region: 'Global',
      description: 'Fedwire & domestic wire transfers',
      recentEvents: [
        RailEvent(type: EventType.success, message: 'All systems nominal', time: DateTime.now().subtract(const Duration(minutes: 10))),
      ],
      hourlyLatency: [44, 46, 45, 43, 47, 45, 44, 46, 45, 48, 46, 45],
    ),
    PaymentRailData(
      name: 'SWIFT Network',
      shortName: 'SWIFT',
      icon: Icons.public,
      status: RailStatus.degraded,
      latency: 156,
      uptime: 98.45,
      throughput: '3.1K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 45)),
      region: 'International',
      description: 'International bank-to-bank transfers',
      recentEvents: [
        RailEvent(type: EventType.warning, message: 'Elevated latency in APAC region', time: DateTime.now().subtract(const Duration(minutes: 15))),
        RailEvent(type: EventType.info, message: 'Investigating connectivity issues', time: DateTime.now().subtract(const Duration(minutes: 20))),
      ],
      hourlyLatency: [120, 125, 130, 145, 156, 160, 158, 155, 150, 148, 155, 156],
    ),
    PaymentRailData(
      name: 'SEPA Instant',
      shortName: 'SEPA',
      icon: Icons.euro,
      status: RailStatus.operational,
      latency: 18,
      uptime: 99.98,
      throughput: '15.7K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 20)),
      region: 'Europe',
      description: 'Single Euro Payments Area - Instant',
      recentEvents: [
        RailEvent(type: EventType.success, message: 'Peak capacity handled successfully', time: DateTime.now().subtract(const Duration(hours: 1))),
      ],
      hourlyLatency: [17, 18, 19, 18, 17, 18, 19, 18, 17, 18, 18, 18],
    ),
    PaymentRailData(
      name: 'RTP Network',
      shortName: 'RTP',
      icon: Icons.flash_on,
      status: RailStatus.operational,
      latency: 8,
      uptime: 99.99,
      throughput: '22.3K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 10)),
      region: 'United States',
      description: 'Real-Time Payments Network',
      recentEvents: [
        RailEvent(type: EventType.success, message: 'Record throughput achieved', time: DateTime.now().subtract(const Duration(hours: 3))),
      ],
      hourlyLatency: [7, 8, 8, 9, 8, 7, 8, 8, 9, 8, 8, 8],
    ),
    PaymentRailData(
      name: 'Card Networks',
      shortName: 'CARDS',
      icon: Icons.credit_card,
      status: RailStatus.operational,
      latency: 32,
      uptime: 99.97,
      throughput: '45.8K/min',
      lastCheck: DateTime.now().subtract(const Duration(seconds: 5)),
      region: 'Global',
      description: 'Visa, Mastercard, Amex processing',
      recentEvents: [
        RailEvent(type: EventType.success, message: 'Authorization rate at 99.2%', time: DateTime.now().subtract(const Duration(minutes: 30))),
      ],
      hourlyLatency: [30, 32, 31, 33, 32, 30, 31, 32, 33, 32, 31, 32],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = DashboardPalette.textPrimary(widget.brightness);
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    final surface = DashboardPalette.surface(widget.brightness);
    final border = DashboardPalette.border(widget.brightness);
    final isDark = widget.brightness == Brightness.dark;
    
    final operationalCount = _rails.where((r) => r.status == RailStatus.operational).length;
    final degradedCount = _rails.where((r) => r.status == RailStatus.degraded).length;
    final downCount = _rails.where((r) => r.status == RailStatus.down).length;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isCompact = w < 600;
        final crossAxisCount = w < 560 ? 1 : w < 900 ? 2 : 3;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status summary
            _buildHeader(textPrimary, textSecondary, operationalCount, degradedCount, downCount, isDark, border),
            const SizedBox(height: 20),
            
            // System Overview Cards
            _SystemOverviewCards(
              brightness: widget.brightness,
              rails: _rails,
              isCompact: isCompact,
            ),
            const SizedBox(height: 20),
            
            // Tab Bar for different views
            _buildTabBar(surface, border, textPrimary, textSecondary, isDark),
            const SizedBox(height: 16),
            
            // Tab Content
            SizedBox(
              height: isCompact ? 520 : 420,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Rails Grid
                  _RailsGridView(brightness: widget.brightness, rails: _rails, crossAxisCount: crossAxisCount),
                  // Performance View
                  _PerformanceView(brightness: widget.brightness, rails: _rails),
                  // Incidents View
                  _IncidentsView(brightness: widget.brightness, rails: _rails),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Color textPrimary, Color textSecondary, int operationalCount, int degradedCount, int downCount, bool isDark, Color border) {
    return Row(
      children: [
        Text('Live Rail Health', style: GoogleFonts.inter(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(width: 10),
        const _PingDot(),
        const SizedBox(width: 16),
        // Status Pills
        _StatusPill(count: operationalCount, label: 'Operational', color: const Color(0xFF22C55E), isDark: isDark),
        const SizedBox(width: 8),
        if (degradedCount > 0) ...[
          _StatusPill(count: degradedCount, label: 'Degraded', color: const Color(0xFFF59E0B), isDark: isDark),
          const SizedBox(width: 8),
        ],
        if (downCount > 0) 
          _StatusPill(count: downCount, label: 'Down', color: const Color(0xFFEF4444), isDark: isDark),
        const Spacer(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monitor_heart_outlined, color: PayRouteColors.dashboardPrimary, size: 16),
                const SizedBox(width: 6),
                Text('View System Status', style: GoogleFonts.inter(color: PayRouteColors.dashboardPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(Color surface, Color border, Color textPrimary, Color textSecondary, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: PayRouteColors.dashboardPrimary,
        unselectedLabelColor: textSecondary,
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'All Rails'),
          Tab(text: 'Performance'),
          Tab(text: 'Incidents'),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final bool isDark;

  const _StatusPill({required this.count, required this.label, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4)],
            ),
          ),
          const SizedBox(width: 6),
          Text('$count $label', style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SystemOverviewCards extends StatelessWidget {
  final Brightness brightness;
  final List<PaymentRailData> rails;
  final bool isCompact;

  const _SystemOverviewCards({required this.brightness, required this.rails, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final isDark = brightness == Brightness.dark;
    
    final avgLatency = rails.map((r) => r.latency).reduce((a, b) => a + b) ~/ rails.length;
    final avgUptime = rails.map((r) => r.uptime).reduce((a, b) => a + b) / rails.length;
    final totalThroughput = '107.5K/min';
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isCompact) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _OverviewCard(
                    icon: Icons.speed,
                    label: 'Avg Latency',
                    value: '${avgLatency}ms',
                    trend: '-2ms',
                    trendUp: false,
                    color: const Color(0xFF22C55E),
                    brightness: brightness,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _OverviewCard(
                    icon: Icons.verified,
                    label: 'System Uptime',
                    value: '${avgUptime.toStringAsFixed(2)}%',
                    trend: '+0.02%',
                    trendUp: true,
                    color: const Color(0xFF3B82F6),
                    brightness: brightness,
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _OverviewCard(
                    icon: Icons.sync,
                    label: 'Throughput',
                    value: totalThroughput,
                    trend: '+12%',
                    trendUp: true,
                    color: PayRouteColors.dashboardPrimary,
                    brightness: brightness,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _OverviewCard(
                    icon: Icons.check_circle_outline,
                    label: 'Success Rate',
                    value: '99.7%',
                    trend: '+0.1%',
                    trendUp: true,
                    color: const Color(0xFF8B5CF6),
                    brightness: brightness,
                  )),
                ],
              ),
            ],
          );
        }
        
        return Row(
          children: [
            Expanded(child: _OverviewCard(
              icon: Icons.speed,
              label: 'Avg Latency',
              value: '${avgLatency}ms',
              trend: '-2ms',
              trendUp: false,
              color: const Color(0xFF22C55E),
              brightness: brightness,
            )),
            const SizedBox(width: 12),
            Expanded(child: _OverviewCard(
              icon: Icons.verified,
              label: 'System Uptime',
              value: '${avgUptime.toStringAsFixed(2)}%',
              trend: '+0.02%',
              trendUp: true,
              color: const Color(0xFF3B82F6),
              brightness: brightness,
            )),
            const SizedBox(width: 12),
            Expanded(child: _OverviewCard(
              icon: Icons.sync,
              label: 'Throughput',
              value: totalThroughput,
              trend: '+12%',
              trendUp: true,
              color: PayRouteColors.dashboardPrimary,
              brightness: brightness,
            )),
            const SizedBox(width: 12),
            Expanded(child: _OverviewCard(
              icon: Icons.check_circle_outline,
              label: 'Success Rate',
              value: '99.7%',
              trend: '+0.1%',
              trendUp: true,
              color: const Color(0xFF8B5CF6),
              brightness: brightness,
            )),
          ],
        );
      },
    );
  }
}

class _OverviewCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final bool trendUp;
  final Color color;
  final Brightness brightness;

  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.trendUp,
    required this.color,
    required this.brightness,
  });

  @override
  State<_OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<_OverviewCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(widget.brightness);
    final border = DashboardPalette.border(widget.brightness);
    final textPrimary = DashboardPalette.textPrimary(widget.brightness);
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    final isDark = widget.brightness == Brightness.dark;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered 
              ? widget.color.withValues(alpha: 0.08)
              : surface.withValues(alpha: isDark ? 0.72 : 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered 
                ? widget.color.withValues(alpha: 0.3)
                : border,
          ),
          boxShadow: _isHovered ? [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 18),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (widget.trendUp ? const Color(0xFF22C55E) : const Color(0xFF3B82F6)).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.trendUp ? Icons.trending_up : Icons.trending_down,
                        color: widget.trendUp ? const Color(0xFF22C55E) : const Color(0xFF3B82F6),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.trend,
                        style: GoogleFonts.inter(
                          color: widget.trendUp ? const Color(0xFF22C55E) : const Color(0xFF3B82F6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(widget.value, style: GoogleFonts.inter(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _RailsGridView extends StatelessWidget {
  final Brightness brightness;
  final List<PaymentRailData> rails;
  final int crossAxisCount;

  const _RailsGridView({required this.brightness, required this.rails, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: crossAxisCount == 1 ? 2.2 : 1.6,
      ),
      itemCount: rails.length,
      itemBuilder: (context, index) => _RailCard(
        rail: rails[index],
        brightness: brightness,
        index: index,
      ),
    );
  }
}

class _RailCard extends StatefulWidget {
  final PaymentRailData rail;
  final Brightness brightness;
  final int index;

  const _RailCard({required this.rail, required this.brightness, required this.index});

  @override
  State<_RailCard> createState() => _RailCardState();
}

class _RailCardState extends State<_RailCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isExpanded = false;

  Color get statusColor {
    switch (widget.rail.status) {
      case RailStatus.operational:
        return const Color(0xFF22C55E);
      case RailStatus.degraded:
        return const Color(0xFFF59E0B);
      case RailStatus.down:
        return const Color(0xFFEF4444);
    }
  }

  String get statusLabel {
    switch (widget.rail.status) {
      case RailStatus.operational:
        return 'OPERATIONAL';
      case RailStatus.degraded:
        return 'DEGRADED';
      case RailStatus.down:
        return 'DOWN';
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(widget.brightness);
    final border = DashboardPalette.border(widget.brightness);
    final textPrimary = DashboardPalette.textPrimary(widget.brightness);
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    final isDark = widget.brightness == Brightness.dark;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + widget.index * 80),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isHovered 
                        ? statusColor.withValues(alpha: 0.06)
                        : surface.withValues(alpha: isDark ? 0.72 : 0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _isHovered 
                          ? statusColor.withValues(alpha: 0.3)
                          : border,
                    ),
                    boxShadow: _isHovered ? [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ] : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(widget.rail.icon, color: statusColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.rail.name, style: GoogleFonts.inter(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                Text(widget.rail.region, style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                              ],
                            ),
                          ),
                          _AnimatedStatusBadge(status: statusLabel, color: statusColor),
                        ],
                      ),
                      const Spacer(),
                      // Metrics Row
                      Row(
                        children: [
                          _MetricChip(label: 'Latency', value: '${widget.rail.latency}ms', icon: Icons.timer_outlined, textSecondary: textSecondary, textPrimary: textPrimary, isDark: isDark),
                          const SizedBox(width: 8),
                          _MetricChip(label: 'Uptime', value: '${widget.rail.uptime}%', icon: Icons.verified_outlined, textSecondary: textSecondary, textPrimary: textPrimary, isDark: isDark),
                          const SizedBox(width: 8),
                          _MetricChip(label: 'TPS', value: widget.rail.throughput, icon: Icons.sync, textSecondary: textSecondary, textPrimary: textPrimary, isDark: isDark),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Mini Latency Graph
                      _MiniLatencyGraph(data: widget.rail.hourlyLatency, color: statusColor, isDark: isDark),
                      const SizedBox(height: 8),
                      // Last Check
                      Row(
                        children: [
                          Icon(Icons.access_time, color: textSecondary, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'Last check: ${_formatTimeAgo(widget.rail.lastCheck)}',
                            style: GoogleFonts.inter(color: textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _AnimatedStatusBadge extends StatefulWidget {
  final String status;
  final Color color;

  const _AnimatedStatusBadge({required this.status, required this.color});

  @override
  State<_AnimatedStatusBadge> createState() => _AnimatedStatusBadgeState();
}

class _AnimatedStatusBadgeState extends State<_AnimatedStatusBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.2 + _controller.value * 0.15),
                blurRadius: 8 + _controller.value * 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.6),
                      blurRadius: 4 + _controller.value * 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                widget.status,
                style: GoogleFonts.inter(color: widget.color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color textSecondary;
  final Color textPrimary;
  final bool isDark;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.textSecondary,
    required this.textPrimary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 9, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value, style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _MiniLatencyGraph extends StatelessWidget {
  final List<int> data;
  final Color color;
  final bool isDark;

  const _MiniLatencyGraph({required this.data, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minVal = data.reduce((a, b) => a < b ? a : b).toDouble();
    final range = maxVal - minVal;
    
    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (index) {
          final normalized = range == 0 ? 1.0 : (data[index] - minVal) / range;
          final height = 8 + (normalized * 16);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: height),
                duration: Duration(milliseconds: 400 + index * 50),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Container(
                    height: value,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.4 + (normalized * 0.4)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PerformanceView extends StatelessWidget {
  final Brightness brightness;
  final List<PaymentRailData> rails;

  const _PerformanceView({required this.brightness, required this.rails});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final isDark = brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Latency Comparison Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface.withValues(alpha: isDark ? 0.72 : 0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart, color: PayRouteColors.dashboardPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text('Latency Comparison', style: GoogleFonts.inter(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Last 1 hour', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...rails.map((rail) => _LatencyBar(
                  rail: rail,
                  maxLatency: 200,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  isDark: isDark,
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Uptime Rankings
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surface.withValues(alpha: isDark ? 0.72 : 0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.leaderboard, color: const Color(0xFF22C55E), size: 20),
                    const SizedBox(width: 8),
                    Text('Uptime Rankings', style: GoogleFonts.inter(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                ...(List.from(rails)..sort((a, b) => b.uptime.compareTo(a.uptime)))
                    .asMap()
                    .entries
                    .map((entry) => _UptimeRow(
                      rank: entry.key + 1,
                      rail: entry.value,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      isDark: isDark,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LatencyBar extends StatelessWidget {
  final PaymentRailData rail;
  final double maxLatency;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;

  const _LatencyBar({
    required this.rail,
    required this.maxLatency,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
  });

  Color get barColor {
    if (rail.latency < 50) return const Color(0xFF22C55E);
    if (rail.latency < 100) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final percent = (rail.latency / maxLatency).clamp(0.0, 1.0);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(rail.shortName, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [barColor.withValues(alpha: 0.7), barColor]),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [BoxShadow(color: barColor.withValues(alpha: 0.4), blurRadius: 8)],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 50,
                child: Text('${rail.latency}ms', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UptimeRow extends StatelessWidget {
  final int rank;
  final PaymentRailData rail;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;

  const _UptimeRow({
    required this.rank,
    required this.rail,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final medalColors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
    final color = rank <= 3 ? medalColors[rank - 1] : textSecondary;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: GoogleFonts.inter(color: color, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(rail.icon, color: textSecondary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(rail.name, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${rail.uptime}%',
              style: GoogleFonts.inter(color: const Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _IncidentsView extends StatelessWidget {
  final Brightness brightness;
  final List<PaymentRailData> rails;

  const _IncidentsView({required this.brightness, required this.rails});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    final isDark = brightness == Brightness.dark;

    // Collect all events from all rails
    final allEvents = <_EventWithRail>[];
    for (final rail in rails) {
      for (final event in rail.recentEvents) {
        allEvents.add(_EventWithRail(rail: rail, event: event));
      }
    }
    allEvents.sort((a, b) => b.event.time.compareTo(a.event.time));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: isDark ? 0.72 : 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: PayRouteColors.dashboardPrimary, size: 20),
              const SizedBox(width: 8),
              Text('Recent Events', style: GoogleFonts.inter(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${allEvents.length} events', style: GoogleFonts.inter(color: textSecondary, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: allEvents.length,
              itemBuilder: (context, index) {
                final item = allEvents[index];
                return _EventRow(
                  railName: item.rail.shortName,
                  event: item.event,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  isDark: isDark,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventWithRail {
  final PaymentRailData rail;
  final RailEvent event;

  _EventWithRail({required this.rail, required this.event});
}

class _EventRow extends StatelessWidget {
  final String railName;
  final RailEvent event;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;
  final int index;

  const _EventRow({
    required this.railName,
    required this.event,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
    required this.index,
  });

  Color get eventColor {
    switch (event.type) {
      case EventType.success:
        return const Color(0xFF22C55E);
      case EventType.warning:
        return const Color(0xFFF59E0B);
      case EventType.error:
        return const Color(0xFFEF4444);
      case EventType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData get eventIcon {
    switch (event.type) {
      case EventType.success:
        return Icons.check_circle;
      case EventType.warning:
        return Icons.warning;
      case EventType.error:
        return Icons.error;
      case EventType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 50),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: eventColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(eventIcon, color: eventColor, size: 16),
                      ),
                      if (index < 10)
                        Container(
                          width: 2,
                          height: 20,
                          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(railName, style: GoogleFonts.inter(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                            const Spacer(),
                            Text(_formatTime(event.time), style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(event.message, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// Data Models
enum RailStatus { operational, degraded, down }
enum EventType { success, warning, error, info }

class PaymentRailData {
  final String name;
  final String shortName;
  final IconData icon;
  final RailStatus status;
  final int latency;
  final double uptime;
  final String throughput;
  final DateTime lastCheck;
  final String region;
  final String description;
  final List<RailEvent> recentEvents;
  final List<int> hourlyLatency;

  PaymentRailData({
    required this.name,
    required this.shortName,
    required this.icon,
    required this.status,
    required this.latency,
    required this.uptime,
    required this.throughput,
    required this.lastCheck,
    required this.region,
    required this.description,
    required this.recentEvents,
    required this.hourlyLatency,
  });
}

class RailEvent {
  final EventType type;
  final String message;
  final DateTime time;

  RailEvent({required this.type, required this.message, required this.time});
}

class _PingDot extends StatefulWidget {
  const _PingDot();

  @override
  State<_PingDot> createState() => _PingDotState();
}

class _PingDotState extends State<_PingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
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
        final pulseScale = 1.0 + _controller.value * 0.5;
        final pulseOpacity = 0.3 + _controller.value * 0.4;
        
        return SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Animated outer ring
              Transform.scale(
                scale: pulseScale,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.15 * (1 - _controller.value)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Static glow
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
              // Core dot with glow
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: pulseOpacity),
                      blurRadius: 8 + _controller.value * 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
            _EmptyActivityState(brightness: brightness),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Brightness brightness;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.brightness,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(widget.brightness);
    final border = DashboardPalette.border(widget.brightness);
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseValue = _isHovered ? _pulseController.value : 0.0;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -4.0 : 0.0),
            decoration: BoxDecoration(
              color: _isHovered 
                ? widget.color.withValues(alpha: 0.08) 
                : surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered 
                  ? widget.color.withValues(alpha: 0.3)
                  : border,
              ),
              boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2 + pulseValue * 0.15),
                      blurRadius: 20 + pulseValue * 10,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isHovered 
                      ? widget.color.withValues(alpha: 0.15) 
                      : Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: _isHovered ? 0.5 : 0.35),
                        blurRadius: _isHovered ? 24 : 16,
                      ),
                    ],
                  ),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: _isHovered ? 1.1 : 1.0,
                    child: Icon(
                      widget.icon,
                      color: _isHovered 
                        ? widget.color 
                        : (widget.brightness == Brightness.dark ? Colors.white : Colors.black),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    color: _isHovered ? widget.color : textSecondary,
                    fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 12,
                  ),
                  child: Text(widget.label),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyHealthState extends StatelessWidget {
  final Brightness brightness;

  const _EmptyHealthState({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.72 : 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_outlined, color: textSecondary.withValues(alpha: 0.5), size: 48),
          const SizedBox(height: 12),
          Text('No connected rails yet', style: GoogleFonts.inter(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text('Connect your payment rails to monitor their status.', style: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _EmptyActivityState extends StatelessWidget {
  final Brightness brightness;

  const _EmptyActivityState({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: brightness == Brightness.dark ? 0.55 : 1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, color: textSecondary.withValues(alpha: 0.5), size: 40),
          const SizedBox(height: 10),
          Text('No recent activity', style: GoogleFonts.inter(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          Text('Your transactions will appear here.', style: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: 12)),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final Brightness brightness;
  final Color bg;
  final Color border;

  const _UserAvatar({
    required this.photoUrl,
    required this.brightness,
    required this.bg,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.userModel;
    final initials = user?.initials ?? 'U';
    
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: border),
            image: photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: photoUrl == null ? PayRouteColors.dashboardPrimary : null,
          ),
          child: photoUrl == null
              ? Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: PayRouteColors.dashboardGreen,
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopUpButton extends StatefulWidget {
  final Brightness brightness;
  final bool isCompact;

  const _TopUpButton({required this.brightness, required this.isCompact});

  @override
  State<_TopUpButton> createState() => _TopUpButtonState();
}

class _TopUpButtonState extends State<_TopUpButton> {
  bool _isHovered = false;

  void _showTopUpModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TopUpBankAccountModal(brightness: widget.brightness),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showTopUpModal(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PayRouteColors.dashboardPrimary,
                PayRouteColors.dashboardAccentOrange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Top Up',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium Bank Account Top-Up Modal
class TopUpBankAccountModal extends StatefulWidget {
  final Brightness brightness;

  const TopUpBankAccountModal({super.key, required this.brightness});

  @override
  State<TopUpBankAccountModal> createState() => _TopUpBankAccountModalState();
}

enum TopUpMethod { ngnBank, usdBank, card }

class _TopUpBankAccountModalState extends State<TopUpBankAccountModal>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  String? _copiedField;
  TopUpMethod _selectedMethod = TopUpMethod.ngnBank;

  // NGN Bank account details
  final Map<String, String> _ngnBankDetails = {
    'accountName': 'PayRoute Technologies Ltd',
    'accountNumber': '0123456789',
    'bankName': 'First Bank of Nigeria',
    'sortCode': '011151003',
    'reference': 'PAYROUTE-USER-2024',
  };

  // USD Bank account details
  final Map<String, String> _usdBankDetails = {
    'accountName': 'PayRoute Technologies Inc',
    'accountNumber': '8756321940',
    'bankName': 'Chase Bank',
    'routingNumber': '021000021',
    'swiftCode': 'CHASUS33',
    'reference': 'PAYROUTE-USD-2024',
  };

  Map<String, String> get _bankDetails => 
      _selectedMethod == TopUpMethod.usdBank ? _usdBankDetails : _ngnBankDetails;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String field, String value) {
    Clipboard.setData(ClipboardData(text: value));
    setState(() => _copiedField = field);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedField = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = DashboardPalette.bg(widget.brightness);
    final surface = DashboardPalette.surface(widget.brightness);
    final border = DashboardPalette.border(widget.brightness);
    final textPrimary = DashboardPalette.textPrimary(widget.brightness);
    final textSecondary = DashboardPalette.textSecondary(widget.brightness);
    final isDark = widget.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    maxWidth: 480,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: -10,
                        offset: const Offset(0, -10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with animated glow
                        _buildHeader(textPrimary, textSecondary, isDark),
                        
                        // Method selector tabs
                        _buildMethodSelector(surface, border, textPrimary, textSecondary, isDark),
                        
                        // Animated divider
                        _buildAnimatedDivider(border),
                        
                        // Content based on selected method
                        if (_selectedMethod == TopUpMethod.card)
                          _buildCardTopUpContent(surface, border, textPrimary, textSecondary, isDark)
                        else ...[
                          // Bank Account Card
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: _buildBankCard(surface, border, textPrimary, textSecondary, isDark),
                          ),
                          
                          // Account Details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  icon: Icons.person_outline,
                                  label: 'Account Name',
                                  value: _bankDetails['accountName']!,
                                  field: 'accountName',
                                  surface: surface,
                                  border: border,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isDark: isDark,
                                  index: 0,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.numbers,
                                  label: 'Account Number',
                                  value: _bankDetails['accountNumber']!,
                                  field: 'accountNumber',
                                  surface: surface,
                                  border: border,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isDark: isDark,
                                  index: 1,
                                  isHighlighted: true,
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.account_balance_outlined,
                                  label: 'Bank Name',
                                  value: _bankDetails['bankName']!,
                                  field: 'bankName',
                                  surface: surface,
                                  border: border,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isDark: isDark,
                                  index: 2,
                                ),
                                if (_selectedMethod == TopUpMethod.usdBank) ...[
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    icon: Icons.route_outlined,
                                    label: 'Routing Number',
                                    value: _usdBankDetails['routingNumber']!,
                                    field: 'routingNumber',
                                    surface: surface,
                                    border: border,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    isDark: isDark,
                                    index: 3,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    icon: Icons.public,
                                    label: 'SWIFT Code',
                                    value: _usdBankDetails['swiftCode']!,
                                    field: 'swiftCode',
                                    surface: surface,
                                    border: border,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    isDark: isDark,
                                    index: 4,
                                  ),
                                ],
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  icon: Icons.tag,
                                  label: 'Reference / Memo',
                                  value: _bankDetails['reference']!,
                                  field: 'reference',
                                  surface: surface,
                                  border: border,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  isDark: isDark,
                                  index: _selectedMethod == TopUpMethod.usdBank ? 5 : 3,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Info tip
                          _buildInfoTip(textSecondary, isDark),
                        ],
                        
                        const SizedBox(height: 20),
                        
                        // Action buttons
                        _buildActionButtons(textPrimary, border, isDark),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Color textPrimary, Color textSecondary, bool isDark) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 20, 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PayRouteColors.dashboardPrimary.withValues(alpha: 0.08 + pulseValue * 0.04),
                PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.03 + pulseValue * 0.02),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PayRouteColors.dashboardPrimary,
                      PayRouteColors.dashboardAccentOrange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.35 + pulseValue * 0.15),
                      blurRadius: 16 + pulseValue * 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Up Your Wallet',
                      style: GoogleFonts.inter(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Transfer funds to the account below',
                      style: GoogleFonts.inter(
                        color: textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                  ),
                ),
                icon: Icon(Icons.close, color: textSecondary, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMethodSelector(Color surface, Color border, Color textPrimary, Color textSecondary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            _buildMethodTab(
              icon: Icons.account_balance,
              label: 'NGN Bank',
              method: TopUpMethod.ngnBank,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              isDark: isDark,
            ),
            const SizedBox(width: 4),
            _buildMethodTab(
              icon: Icons.account_balance,
              label: 'USD Bank',
              method: TopUpMethod.usdBank,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              isDark: isDark,
            ),
            const SizedBox(width: 4),
            _buildMethodTab(
              icon: Icons.credit_card,
              label: 'Card',
              method: TopUpMethod.card,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodTab({
    required IconData icon,
    required String label,
    required TopUpMethod method,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
  }) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedMethod = method;
          _copiedField = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? PayRouteColors.dashboardPrimary : textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: isSelected ? PayRouteColors.dashboardPrimary : textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTopUpContent(Color surface, Color border, Color textPrimary, Color textSecondary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          // Card illustration
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PayRouteColors.dashboardPrimary.withValues(alpha: 0.12),
                  PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        PayRouteColors.dashboardPrimary,
                        PayRouteColors.dashboardAccentOrange,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.credit_card, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Card Top Up',
                  style: GoogleFonts.inter(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Instantly fund your wallet using your debit or credit card',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Amount input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface.withValues(alpha: isDark ? 0.5 : 1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Amount',
                  style: GoogleFonts.inter(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'USD',
                        style: GoogleFonts.inter(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '\$0.00',
                        style: GoogleFonts.jetBrainsMono(
                          color: textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Quick amounts
          Row(
            children: [
              _buildQuickAmountChip('\$50', textPrimary, textSecondary, isDark),
              const SizedBox(width: 8),
              _buildQuickAmountChip('\$100', textPrimary, textSecondary, isDark),
              const SizedBox(width: 8),
              _buildQuickAmountChip('\$250', textPrimary, textSecondary, isDark),
              const SizedBox(width: 8),
              _buildQuickAmountChip('\$500', textPrimary, textSecondary, isDark),
            ],
          ),
          const SizedBox(height: 16),
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: PayRouteColors.dashboardPrimary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'A 2.9% processing fee applies to card top-ups. Bank transfers have no fees.',
                    style: GoogleFonts.inter(
                      color: textSecondary,
                      fontSize: 12,
                      height: 1.5,
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

  Widget _buildQuickAmountChip(String amount, Color textPrimary, Color textSecondary, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            amount,
            style: GoogleFonts.inter(
              color: textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDivider(Color border) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                border,
                PayRouteColors.dashboardPrimary.withValues(alpha: 0.5),
                border,
              ],
              stops: [
                (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                _shimmerController.value,
                (_shimmerController.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBankCard(Color surface, Color border, Color textPrimary, Color textSecondary, bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (value * 0.1),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PayRouteColors.dashboardPrimary.withValues(alpha: 0.12),
                    PayRouteColors.dashboardAccentOrange.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: PayRouteColors.dashboardPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bankDetails['bankName']!,
                              style: GoogleFonts.inter(
                                color: textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _selectedMethod == TopUpMethod.usdBank 
                                  ? 'US Bank Transfer' 
                                  : 'Nigerian Bank Transfer',
                              style: GoogleFonts.inter(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Active',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF22C55E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _bankDetails['accountNumber']!.split('').join(' '),
                          style: GoogleFonts.jetBrainsMono(
                            color: textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required String field,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required bool isDark,
    required int index,
    bool isHighlighted = false,
  }) {
    final isCopied = _copiedField == field;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value2, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value2)),
          child: Opacity(
            opacity: value2,
            child: _DetailRowContent(
              icon: icon,
              label: label,
              value: value,
              isCopied: isCopied,
              isHighlighted: isHighlighted,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              isDark: isDark,
              onCopy: () => _copyToClipboard(field, value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTip(Color textSecondary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: PayRouteColors.dashboardPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Include your reference when transferring to ensure instant credit to your wallet.',
                style: GoogleFonts.inter(
                  color: textSecondary,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Color textPrimary, Color border, bool isDark) {
    if (_selectedMethod == TopUpMethod.card) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: _ProceedToPaymentButton(onTap: () {
            // TODO: Implement card payment flow
            Navigator.pop(context);
          }),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _ShareButton(isDark: isDark, border: border, textPrimary: textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _DoneButton(onTap: () => Navigator.pop(context)),
          ),
        ],
      ),
    );
  }
}

class _ProceedToPaymentButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ProceedToPaymentButton({required this.onTap});

  @override
  State<_ProceedToPaymentButton> createState() => _ProceedToPaymentButtonState();
}

class _ProceedToPaymentButtonState extends State<_ProceedToPaymentButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PayRouteColors.dashboardPrimary,
                PayRouteColors.dashboardAccentOrange,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.credit_card, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                'Proceed to Payment',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRowContent extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isCopied;
  final bool isHighlighted;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDark;
  final VoidCallback onCopy;

  const _DetailRowContent({
    required this.icon,
    required this.label,
    required this.value,
    required this.isCopied,
    required this.isHighlighted,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDark,
    required this.onCopy,
  });

  @override
  State<_DetailRowContent> createState() => _DetailRowContentState();
}

class _DetailRowContentState extends State<_DetailRowContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onCopy,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.isCopied
                ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                : widget.isHighlighted
                    ? PayRouteColors.dashboardPrimary.withValues(alpha: widget.isDark ? 0.08 : 0.05)
                    : (_isHovered
                        ? (widget.isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.02))
                        : widget.surface.withValues(alpha: widget.isDark ? 0.5 : 1)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isCopied
                  ? const Color(0xFF22C55E).withValues(alpha: 0.3)
                  : widget.isHighlighted
                      ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.2)
                      : (_isHovered
                          ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.3)
                          : widget.border),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.textSecondary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.inter(
                        color: widget.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: GoogleFonts.inter(
                        color: widget.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: widget.isCopied
                    ? Container(
                        key: const ValueKey('copied'),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, color: Color(0xFF22C55E), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Copied!',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF22C55E),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        key: const ValueKey('copy'),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.1)
                              : (widget.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.copy_outlined,
                          color: _isHovered ? PayRouteColors.dashboardPrimary : widget.textSecondary,
                          size: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareButton extends StatefulWidget {
  final bool isDark;
  final Color border;
  final Color textPrimary;

  const _ShareButton({required this.isDark, required this.border, required this.textPrimary});

  @override
  State<_ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<_ShareButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _isHovered
              ? (widget.isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: widget.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.share_outlined, color: widget.textPrimary, size: 18),
            const SizedBox(width: 8),
            Text(
              'Share',
              style: GoogleFonts.inter(
                color: widget.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneButton extends StatefulWidget {
  final VoidCallback onTap;

  const _DoneButton({required this.onTap});

  @override
  State<_DoneButton> createState() => _DoneButtonState();
}

class _DoneButtonState extends State<_DoneButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                PayRouteColors.dashboardPrimary,
                PayRouteColors.dashboardAccentOrange,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -2.0 : 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'I\'ve Sent the Money',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}