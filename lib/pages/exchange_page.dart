import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final TextEditingController _sendController = TextEditingController(text: '2,500.00');
  final TextEditingController _receiveController = TextEditingController(text: '2,875,000.00');

  int _routeIndex = 0;
  int _tabIndex = 0;

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Exchange',
      background: const _ExchangeGlowBackground(),
      desktopHeader: _ExchangeHeader(brightness: b),
      mobileTitle: 'Exchange',
      mobileSubtitle: 'Smart multi-rail routing for best rates',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: _ExchangeBody(
                  width: constraints.maxWidth,
                  sendController: _sendController,
                  receiveController: _receiveController,
                  routeIndex: _routeIndex,
                  onRouteIndexChanged: (value) => setState(() => _routeIndex = value),
                  tabIndex: _tabIndex,
                  onTabChanged: (value) => setState(() => _tabIndex = value),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExchangeGlowBackground extends StatelessWidget {
  const _ExchangeGlowBackground();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    // In light mode we want a crisp, clear background (no glows/gradients).
    if (b == Brightness.light) return const SizedBox.shrink();
    final bg = DashboardPalette.bg(b);
    final neutralA = Colors.white.withValues(alpha: 0.06);
    final neutralB = Colors.white.withValues(alpha: 0.035);
    return Stack(
      children: [
        Positioned(
          top: -180,
          left: -120,
          child: _GlowCircle(color: neutralA, size: 620),
        ),
        Positioned(
          bottom: -160,
          right: -120,
          child: _GlowCircle(color: neutralB, size: 560),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 40)],
      ),
    );
  }
}

class _ExchangeHeader extends StatelessWidget {
  final Brightness brightness;

  const _ExchangeHeader({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final bg = DashboardPalette.bg(brightness);
    final surface = DashboardPalette.surface(brightness);
    final border = DashboardPalette.border(brightness);
    final textPrimary = DashboardPalette.textPrimary(brightness);
    final textSecondary = DashboardPalette.textSecondary(brightness);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 980;

        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Currency Exchange', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 22), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('Smart multi-rail routing for best market rates', style: GoogleFonts.inter(color: textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
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
            color: brightness == Brightness.dark ? bg.withValues(alpha: 0.84) : bg,
            border: Border(bottom: BorderSide(color: border)),
            boxShadow: brightness == Brightness.dark
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8))]
                : const [],
          ),
          child: Row(
            children: [
              Expanded(child: title),
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

class _ExchangeBody extends StatelessWidget {
  final double width;
  final TextEditingController sendController;
  final TextEditingController receiveController;
  final int routeIndex;
  final ValueChanged<int> onRouteIndexChanged;
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  const _ExchangeBody({
    required this.width,
    required this.sendController,
    required this.receiveController,
    required this.routeIndex,
    required this.onRouteIndexChanged,
    required this.tabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = width >= 1100;
    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _SwapPanel(sendController: sendController, receiveController: receiveController)),
              const SizedBox(width: 24),
              Expanded(
                flex: 5,
                child: _RoutingPanel(routeIndex: routeIndex, onRouteIndexChanged: onRouteIndexChanged, tabIndex: tabIndex, onTabChanged: onTabChanged),
              ),
            ],
          )
        : Column(
            children: [
              _SwapPanel(sendController: sendController, receiveController: receiveController),
              const SizedBox(height: 24),
              _RoutingPanel(routeIndex: routeIndex, onRouteIndexChanged: onRouteIndexChanged, tabIndex: tabIndex, onTabChanged: onTabChanged),
            ],
          );
  }
}

class _SwapPanel extends StatelessWidget {
  final TextEditingController sendController;
  final TextEditingController receiveController;

  const _SwapPanel({required this.sendController, required this.receiveController});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    return _GlassPanel(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Swap Currency', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 18)),
                  const Spacer(),
                  _IconPillButton(icon: Icons.tune),
                  const SizedBox(width: 10),
                  _IconPillButton(icon: Icons.history),
                ],
              ),
              const SizedBox(height: 18),
              _AmountCard(
                label: 'You Send',
                trailing: 'Balance:  \$14,250.00',
                controller: sendController,
                accentColor: Colors.white,
                currencyLabel: 'USD',
                flag: '🇺🇸',
                readOnly: false,
              ),
              const SizedBox(height: 14),
              const _SwapDivider(),
              const SizedBox(height: 14),
              _AmountCard(
                label: 'Recipient Gets',
                trailingWidget: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: PayRouteColors.dashboardGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: PayRouteColors.dashboardGreen.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: PayRouteColors.dashboardGreen, size: 14),
                      const SizedBox(width: 6),
                      Text('Best Rate Applied', style: GoogleFonts.inter(color: PayRouteColors.dashboardGreen, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                controller: receiveController,
                accentColor: PayRouteColors.electricBlue,
                currencyLabel: 'NGN',
                flag: '🇳🇬',
                readOnly: true,
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 520;
                    final secondary = DashboardPalette.textSecondary(b);
                    final rate = [
                      Text('Rate: ', style: GoogleFonts.inter(color: secondary, fontSize: 12)),
                      Text('1 USD = 1,150.00 NGN', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ];
                    final fee = [
                      Text('Fee: ', style: GoogleFonts.inter(color: secondary, fontSize: 12)),
                      Text('\$2.50', style: GoogleFonts.inter(color: textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text(' (Included)', style: GoogleFonts.inter(color: secondary, fontSize: 12)),
                    ];

                    return isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: rate),
                              const SizedBox(height: 6),
                              Row(children: fee),
                            ],
                          )
                        : Row(
                            children: [
                              ...rate,
                              const Spacer(),
                              ...fee,
                            ],
                          );
                  },
                ),
              ),
              const SizedBox(height: 18),
              _PrimaryGlowButton(
                label: 'Review & Exchange',
                icon: Icons.arrow_forward,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Review flow is not connected yet.', style: GoogleFonts.inter()),
                      backgroundColor: PayRouteColors.dashboardSurfaceDark,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutingPanel extends StatelessWidget {
  final int routeIndex;
  final ValueChanged<int> onRouteIndexChanged;
  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  const _RoutingPanel({required this.routeIndex, required this.onRouteIndexChanged, required this.tabIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    final routes = <_RouteOptionData>[const _RouteOptionData.recommended(), const _RouteOptionData.paystack(), const _RouteOptionData.flutterwave()];
    return _GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Smart Routing', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
              const Spacer(),
              _SegmentedTabs(selected: tabIndex, onChanged: onTabChanged),
            ],
          ),
          const SizedBox(height: 16),
          const _RoutingRail(),
          const SizedBox(height: 16),
          SizedBox(
            height: 420,
            child: ListView.separated(
              itemCount: routes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final route = routes[index];
                return _RouteOption(
                  data: route,
                  selected: routeIndex == index,
                  onTap: () => onRouteIndexChanged(index),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Routes are updated every 30 seconds based on live market liquidity.',
              style: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.75), fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const _GlassPanel({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final borderColor = DashboardPalette.border(b);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: surface.withValues(alpha: b == Brightness.dark ? 0.58 : 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;

  const _IconPillButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final borderColor = DashboardPalette.border(b);
    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      scale: 1,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: surface.withValues(alpha: b == Brightness.dark ? 0.55 : 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, color: DashboardPalette.iconMuted(b), size: 20),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  final String label;
  final String? trailing;
  final Widget? trailingWidget;
  final TextEditingController controller;
  final Color accentColor;
  final String currencyLabel;
  final String flag;
  final bool readOnly;

  const _AmountCard({
    required this.label,
    this.trailing,
    this.trailingWidget,
    required this.controller,
    required this.accentColor,
    required this.currencyLabel,
    required this.flag,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final amountFontSize = screenWidth < 360 ? 26.0 : screenWidth < 420 ? 30.0 : 34.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: b == Brightness.dark ? 0.52 : 1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              if (trailingWidget != null) trailingWidget!,
              if (trailingWidget == null && trailing != null)
                Text(
                  trailing!,
                  style: GoogleFonts.inter(color: textSecondary, fontSize: 11),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  style: GoogleFonts.inter(color: accentColor, fontSize: amountFontSize, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: GoogleFonts.inter(color: textSecondary.withValues(alpha: 0.7), fontSize: amountFontSize, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _CurrencyDropdown(flag: flag, code: currencyLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String flag;
  final String code;

  const _CurrencyDropdown({required this.flag, required this.code});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(flag, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Text(code, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800)),
          const SizedBox(width: 6),
          Icon(Icons.expand_more, color: textSecondary, size: 20),
        ],
      ),
    );
  }
}

class _SwapDivider extends StatelessWidget {
  const _SwapDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Center(
              child: Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withValues(alpha: 0.10), Colors.transparent]),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [PayRouteColors.dashboardPrimary.withValues(alpha: 0), PayRouteColors.dashboardPrimary.withValues(alpha: 0.55), PayRouteColors.dashboardPrimary.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
          ),
          _SwapButton(onTap: () {}),
        ],
      ),
    );
  }
}

class _SwapButton extends StatefulWidget {
  final VoidCallback onTap;

  const _SwapButton({required this.onTap});

  @override
  State<_SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<_SwapButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final bg = DashboardPalette.bg(b);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: _hover ? 1.08 : 1,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.35)),
              boxShadow: [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.25), blurRadius: 18, spreadRadius: 1)],
            ),
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 420),
              turns: _hover ? 0.5 : 0,
              curve: Curves.easeOutCubic,
              child: const Icon(Icons.swap_vert, color: PayRouteColors.dashboardPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryGlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryGlowButton({required this.label, required this.icon, required this.onTap});

  @override
  State<_PrimaryGlowButton> createState() => _PrimaryGlowButtonState();
}

class _PrimaryGlowButtonState extends State<_PrimaryGlowButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: [PayRouteColors.dashboardPrimary, PayRouteColors.dashboardAccentOrange]),
            boxShadow: [
              BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: _hover ? 0.55 : 0.35), blurRadius: _hover ? 30 : 20, spreadRadius: 1),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  top: _hover ? 0 : 56,
                  left: 0,
                  right: 0,
                  height: 56,
                  child: Container(color: Colors.white.withValues(alpha: 0.15)),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(width: 10),
                      Icon(widget.icon, color: Colors.white),
                    ],
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

class _SegmentedTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _SegmentedTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    Widget buildTab(String label, int index) {
      final isSelected = selected == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? textPrimary.withValues(alpha: b == Brightness.dark ? 0.10 : 0.06) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(label, style: GoogleFonts.inter(color: isSelected ? textPrimary : textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 220 ? constraints.maxWidth : 220.0;
        return SizedBox(
          width: width,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                buildTab('All', 0),
                buildTab('Fastest', 1),
                buildTab('Cheapest', 2),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoutingRail extends StatefulWidget {
  const _RoutingRail();

  @override
  State<_RoutingRail> createState() => _RoutingRailState();
}

class _RoutingRailState extends State<_RoutingRail> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final baseLineColor = DashboardPalette.textPrimary(b).withValues(alpha: b == Brightness.dark ? 0.06 : 0.10);
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: surface.withValues(alpha: b == Brightness.dark ? 0.42 : 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 6,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _FlowLinePainter(t: _animation.value, baseLineColor: baseLineColor),
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _RailDot(label: 'USD', color: PayRouteColors.dashboardPrimary),
                _RailCenterSpinner(),
                _RailDot(label: 'NGN', color: PayRouteColors.dashboardAccentOrange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowLinePainter extends CustomPainter {
  final double t;
  final Color baseLineColor;

  const _FlowLinePainter({required this.t, required this.baseLineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = baseLineColor
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), basePaint);

    final gradient = LinearGradient(
      colors: [Colors.transparent, PayRouteColors.dashboardPrimary, Colors.transparent],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      transform: GradientRotation(0),
    );
    final rect = Rect.fromLTWH(-size.width + (size.width * 2 * t), 0, size.width, size.height);
    final flowPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), flowPaint);
  }

  @override
  bool shouldRepaint(covariant _FlowLinePainter oldDelegate) => oldDelegate.t != t || oldDelegate.baseLineColor != baseLineColor;
}

class _RailDot extends StatelessWidget {
  final String label;
  final Color color;

  const _RailDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textSecondary = DashboardPalette.textSecondary(b);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.9), blurRadius: 12)],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _RailCenterSpinner extends StatefulWidget {
  const _RailCenterSpinner();

  @override
  State<_RailCenterSpinner> createState() => _RailCenterSpinnerState();
}

class _RailCenterSpinnerState extends State<_RailCenterSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: surface,
        shape: BoxShape.circle,
        border: Border.all(color: border),
      ),
      child: RotationTransition(
        turns: _controller,
        child: const Icon(Icons.settings_suggest, color: PayRouteColors.dashboardPrimary, size: 16),
      ),
    );
  }
}

class _RouteOptionData {
  final String title;
  final String subtitle;
  final bool recommended;
  final String badgeLabel;
  final Color badgeColor;
  final String monogram;
  final Color monogramBg;
  final String rate;
  final String fee;
  final Color feeColor;
  final String eta;
  final Color etaColor;

  const _RouteOptionData({
    required this.title,
    required this.subtitle,
    required this.recommended,
    required this.badgeLabel,
    required this.badgeColor,
    required this.monogram,
    required this.monogramBg,
    required this.rate,
    required this.fee,
    required this.feeColor,
    required this.eta,
    required this.etaColor,
  });

  const _RouteOptionData.recommended()
      : this(
          title: 'Wise Rail',
          subtitle: 'Direct Bank Transfer',
          recommended: true,
          badgeLabel: 'RECOMMENDED',
          badgeColor: PayRouteColors.dashboardPrimary,
          monogram: 'W',
          monogramBg: Colors.white,
          rate: '1,150.00',
          fee: '\$2.50',
          feeColor: PayRouteColors.dashboardGreen,
          eta: '~5 min',
          etaColor: Colors.white,
        );

  const _RouteOptionData.paystack()
      : this(
          title: 'Paystack',
          subtitle: 'Card Processing',
          recommended: false,
          badgeLabel: '',
          badgeColor: Colors.transparent,
          monogram: 'P',
          monogramBg: Colors.indigo,
          rate: '1,148.50',
          fee: '\$4.00',
          feeColor: const Color(0xFFCBD5E1),
          eta: 'Instant',
          etaColor: PayRouteColors.dashboardGreen,
        );

  const _RouteOptionData.flutterwave()
      : this(
          title: 'Flutterwave',
          subtitle: 'Mobile Money',
          recommended: false,
          badgeLabel: '',
          badgeColor: Colors.transparent,
          monogram: 'F',
          monogramBg: Colors.deepOrange,
          rate: '1,145.00',
          fee: '\$3.50',
          feeColor: const Color(0xFFCBD5E1),
          eta: '~10 min',
          etaColor: Colors.white,
        );
}

class _RouteOption extends StatefulWidget {
  final _RouteOptionData data;
  final bool selected;
  final VoidCallback onTap;

  const _RouteOption({required this.data, required this.selected, required this.onTap});

  @override
  State<_RouteOption> createState() => _RouteOptionState();
}

class _RouteOptionState extends State<_RouteOption> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final baseBorder = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    final data = widget.data;
    final selected = widget.selected;
    final borderColor = selected ? PayRouteColors.dashboardPrimary : baseBorder;
    final bg = selected ? PayRouteColors.dashboardPrimary.withValues(alpha: b == Brightness.dark ? 0.08 : 0.10) : surface.withValues(alpha: b == Brightness.dark ? 0.50 : 1);
    final hoverBg = surface.withValues(alpha: b == Brightness.dark ? 0.55 : 0.98);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hover ? hoverBg : bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor.withValues(alpha: selected ? 0.9 : 1)),
            boxShadow: selected
                ? [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.12), blurRadius: 18, spreadRadius: 1)]
                : null,
          ),
          child: Column(
            children: [
              if (data.recommended)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: data.badgeColor,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(14), bottomLeft: Radius.circular(14)),
                    ),
                    child: Text(data.badgeLabel, style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: baseBorder),
                      color: selected ? PayRouteColors.dashboardPrimary : Colors.transparent,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: data.monogramBg, borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      data.monogram,
                      style: GoogleFonts.inter(
                        color: data.monogramBg == Colors.white ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.title, style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 14)),
                        Text(data.subtitle, style: GoogleFonts.inter(color: textSecondary, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _KpiTile(label: 'Rate', value: data.rate, valueColor: textPrimary)),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiTile(label: 'Fee', value: data.fee, valueColor: data.feeColor)),
                  const SizedBox(width: 10),
                  Expanded(child: _KpiTile(label: 'ETA', value: data.eta, valueColor: data.etaColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _KpiTile({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final surface = DashboardPalette.surface(b);
    final border = DashboardPalette.border(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: b == Brightness.dark ? 0.55 : 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(color: valueColor, fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
