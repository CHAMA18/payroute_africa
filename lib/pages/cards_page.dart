import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_responsive_scaffold.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  int _cardIndex = 0;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 6000))..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _goNext() => setState(() => _cardIndex = (_cardIndex + 1) % 3);

  void _goPrev() => setState(() => _cardIndex = (_cardIndex - 1) < 0 ? 2 : _cardIndex - 1);

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return FinRouteResponsiveScaffold(
      selectedLabel: 'Cards',
      desktopHeader: const _CardsHeader(),
      mobileTitle: 'Cards',
      mobileSubtitle: 'Manage your wallets and virtual cards',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth < 600 ? 16.0 : 24.0;
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final isLarge = c.maxWidth >= 1024;
                    return isLarge
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  children: [
                                    _YourCardsPanel(
                                      floatController: _floatController,
                                      cardIndex: _cardIndex,
                                      onNext: _goNext,
                                      onPrev: _goPrev,
                                    ),
                                    const SizedBox(height: 20),
                                    const _QuickActionsGrid(),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              const Expanded(flex: 5, child: _RightRail()),
                            ],
                          )
                        : Column(
                            children: [
                              _YourCardsPanel(
                                floatController: _floatController,
                                cardIndex: _cardIndex,
                                onNext: _goNext,
                                onPrev: _goPrev,
                              ),
                              const SizedBox(height: 20),
                              const _QuickActionsGrid(),
                              const SizedBox(height: 24),
                              const _RightRail(),
                            ],
                          );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CardsHeader extends StatelessWidget {
  const _CardsHeader();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final bg = DashboardPalette.bg(b);
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 980;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: bg.withValues(alpha: 0.84),
            border: Border(bottom: BorderSide(color: border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Management',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.2),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your physical and virtual corporate cards',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _AddCardButton(onPressed: () {}),
              const SizedBox(width: 14),
              const _NotificationButton(),
              if (!isTight) ...[
                const SizedBox(width: 14),
                const _UserChip(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AddCardButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _AddCardButton({required this.onPressed});

  @override
  State<_AddCardButton> createState() => _AddCardButtonState();
}

class _AddCardButtonState extends State<_AddCardButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                )
              : LinearGradient(
                  colors: [
                    PayRouteColors.dashboardPrimary.withValues(alpha: 0.15),
                    PayRouteColors.dashboardPrimary.withValues(alpha: 0.08),
                  ],
                ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _hover ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.5) : border),
          boxShadow: [
            BoxShadow(
              color: PayRouteColors.dashboardPrimary.withValues(alpha: _hover ? 0.35 : 0.22),
              blurRadius: _hover ? 24 : 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 16, color: PayRouteColors.dashboardPrimary),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: _hover ? PayRouteColors.dashboardPrimary : textPrimary),
                child: const Text('Add New Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  const _NotificationButton();

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications, color: DashboardPalette.iconMuted(b)),
          style: ButtonStyle(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor: WidgetStatePropertyAll(
              isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey.withValues(alpha: 0.08),
            ),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final v = 0.75 + (_controller.value * 0.25);
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.25 + (0.55 * v)), blurRadius: 10 * v)],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UserChip extends StatelessWidget {
  const _UserChip();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(b);
    final secondary = DashboardPalette.textSecondary(b);
    return Row(
      children: [
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final user = authProvider.userModel;
            final firebaseUser = authProvider.firebaseUser;
            final displayName = user?.displayName ?? firebaseUser?.email?.split('@')[0] ?? 'User';
            final displayRole = user?.displayRole ?? 'User';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(displayName, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w800)),
                Text(displayRole, style: GoogleFonts.inter(color: secondary, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            );
          },
        ),
        const SizedBox(width: 12),
Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final user = authProvider.userModel;
            final firebaseUser = authProvider.firebaseUser;
            final photoUrl = user?.photoUrl ?? firebaseUser?.photoURL;
            final initials = user?.initials ?? 'U';
            return Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                    image: photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
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
                              fontSize: 14,
                            ),
                          ),
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: PayRouteColors.dashboardGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: PayRouteColors.dashboardBg, width: 2),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _YourCardsPanel extends StatelessWidget {
  final AnimationController floatController;
  final int cardIndex;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _YourCardsPanel({required this.floatController, required this.cardIndex, required this.onNext, required this.onPrev});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);
    return _GlassPanel(
      padding: const EdgeInsets.all(24),
      border: BorderSide(color: border.withValues(alpha: 0.4)),
      radius: 28,
      child: Column(
        children: [
          Row(
            children: [
              Text('Your Cards', style: GoogleFonts.inter(color: DashboardPalette.textPrimary(b), fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              _IconCircleButton(icon: Icons.arrow_back, enabled: cardIndex != 0, onTap: cardIndex != 0 ? onPrev : null),
              const SizedBox(width: 10),
              _IconCircleButton(icon: Icons.arrow_forward, enabled: true, onTap: onNext),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AspectRatio(
                aspectRatio: 1.586,
                child: _FloatingCard(
                  controller: floatController,
                  title: 'FinRoute Black',
                  holder: 'TUNDE A.',
                  expires: '12/28',
                  last4: const ['4289', '9016', '7741'][cardIndex],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == cardIndex ? 32 : 10,
                height: 6,
                decoration: BoxDecoration(
                  color: i == cardIndex
                      ? PayRouteColors.dashboardPrimary
                      : (b == Brightness.dark ? Colors.white.withValues(alpha: 0.18) : Colors.black.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: i == cardIndex
                      ? [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.8), blurRadius: 14)]
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatefulWidget {
  final AnimationController controller;
  final String title;
  final String holder;
  final String expires;
  final String last4;

  const _FloatingCard({required this.controller, required this.title, required this.holder, required this.expires, required this.last4});

  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard> {
  Offset _hoverOffset = Offset.zero;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = GoogleFonts.inter;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _hoverOffset = Offset.zero;
      }),
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final local = box.globalToLocal(event.position);
        final dx = (local.dx / box.size.width) - 0.5;
        final dy = (local.dy / box.size.height) - 0.5;
        setState(() => _hoverOffset = Offset(dx, dy));
      },
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final floatY = math.sin(widget.controller.value * math.pi * 2) * 10.0;
          final tiltX = _hover ? -_hoverOffset.dy * 0.10 : 0.0;
          final tiltY = _hover ? _hoverOffset.dx * 0.12 : 0.0;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(0.0, floatY)
              ..rotateX(tiltX)
              ..rotateY(tiltY)
              ..scale(_hover ? 1.02 : 1.0),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 48, offset: const Offset(0, 20)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: RadialGradient(
                          center: const Alignment(0, -1),
                          radius: 1.2,
                          colors: [Colors.white.withValues(alpha: 0.10), Colors.transparent],
                        ),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.contactless, color: Colors.white70, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.title.toUpperCase(),
                              style: t(color: Colors.white.withValues(alpha: 0.60), fontWeight: FontWeight.w600, fontSize: 11, letterSpacing: 2.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('VISA', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 22, fontFamily: 'serif')),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 56,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFF7CC), Color(0xFFF6C344), Color(0xFFD89316)],
                            ),
                            border: Border.all(color: const Color(0xFFFDE68A).withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CARD HOLDER', style: t(color: const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                                const SizedBox(height: 4),
                                Text(widget.holder, style: t(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('EXPIRES', style: t(color: const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.3)),
                              const SizedBox(height: 4),
                              Text(widget.expires, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'monospace', letterSpacing: 0.7)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '•••• ${widget.last4}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                              letterSpacing: 3.0,
                              shadows: [Shadow(color: PayRouteColors.electricBlue.withValues(alpha: 0.25), blurRadius: 12)],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final count = c.maxWidth >= 1100 ? 4 : 2;
        final aspectRatio = c.maxWidth >= 1100 ? 1.22 : 1.05;
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: const [
            _QuickActionCard(
              icon: Icons.ac_unit_rounded,
              label: 'Freeze Card',
              subtitle: 'Pause spend in one tap and resume instantly when needed.',
              badge: 'Security',
              actionLabel: 'Lock now',
              tint: Color(0xFF60A5FA),
            ),
            _QuickActionCard(
              icon: Icons.visibility_rounded,
              label: 'Show Details',
              subtitle: 'Reveal PAN, expiry, and CVV only inside a protected view.',
              badge: 'Protected',
              actionLabel: 'Reveal',
              tint: Color(0xFFC084FC),
            ),
            _QuickActionCard(
              icon: Icons.tune_rounded,
              label: 'Set Limits',
              subtitle: 'Control ATM, online, and point-of-sale thresholds with precision.',
              badge: 'Control',
              actionLabel: 'Adjust',
              tint: Color(0xFFFB923C),
            ),
            _QuickActionCard(
              icon: Icons.lock_rounded,
              label: 'Manage PIN',
              subtitle: 'Reset or rotate your PIN with step-up verification.',
              badge: 'Access',
              actionLabel: 'Update',
              tint: Color(0xFF4ADE80),
            ),
          ],
        );
      },
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String badge;
  final String actionLabel;
  final Color tint;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.badge,
    required this.actionLabel,
    required this.tint,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final border = DashboardPalette.border(b);
    final titleColor = DashboardPalette.textPrimary(b);
    final subtitleColor = DashboardPalette.textSecondary(b);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform:
            Matrix4.identity()..translate(0.0, _hover ? -6.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color:
                _hover
                    ? widget.tint.withValues(alpha: 0.38)
                    : border.withValues(alpha: 0.78),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.tint.withValues(alpha: isDark ? 0.14 : 0.09),
              Colors.white.withValues(alpha: isDark ? 0.04 : 0.72),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.tint.withValues(alpha: _hover ? 0.26 : 0.12),
              blurRadius: _hover ? 36 : 22,
              offset: const Offset(0, 18),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -36,
                right: -26,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.tint.withValues(alpha: _hover ? 0.22 : 0.14),
                          widget.tint.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        scale: _hover ? 1.08 : 1.0,
                        curve: Curves.easeOutCubic,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                widget.tint.withValues(alpha: 0.28),
                                widget.tint.withValues(alpha: 0.12),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.tint.withValues(alpha: 0.24),
                                blurRadius: 22,
                              ),
                            ],
                          ),
                          child: Icon(widget.icon, color: widget.tint, size: 24),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: isDark ? 0.08 : 0.62,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: widget.tint.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Text(
                          widget.badge,
                          style: GoogleFonts.inter(
                            color: widget.tint,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    widget.label,
                    style: GoogleFonts.outfit(
                      color: titleColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: subtitleColor,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        widget.actionLabel,
                        style: GoogleFonts.inter(
                          color: widget.tint,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(
                            alpha: _hover
                                ? (isDark ? 0.16 : 0.9)
                                : (isDark ? 0.08 : 0.7),
                          ),
                          border: Border.all(
                            color: widget.tint.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: 18,
                          color: _hover ? titleColor : subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RightRail extends StatelessWidget {
  const _RightRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _DigitalWalletPanel(),
        SizedBox(height: 20),
        _RecentTransactionsPanel(),
      ],
    );
  }
}

class _DigitalWalletPanel extends StatelessWidget {
  const _DigitalWalletPanel();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);
    return _GlassPanel(
      padding: const EdgeInsets.all(18),
      radius: 28,
      border: BorderSide(color: border.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Digital Wallet', style: GoogleFonts.inter(color: DashboardPalette.textPrimary(b), fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              _LinkButton(label: 'Manage', onTap: () {}),
            ],
          ),
          const SizedBox(height: 14),
          const _WalletRowApplePay(),
          const SizedBox(height: 10),
          const _WalletRowGooglePay(),
        ],
      ),
    );
  }
}

class _WalletRowApplePay extends StatelessWidget {
  const _WalletRowApplePay();

  @override
  Widget build(BuildContext context) {
    return _WalletRow(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.10))),
        child: const Icon(Icons.phone_iphone, color: Colors.white, size: 20),
      ),
      title: 'Apple Pay',
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: PayRouteColors.dashboardGreen, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('Connected', style: GoogleFonts.inter(color: PayRouteColors.dashboardGreen, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
      onTap: () {},
    );
  }
}

class _WalletRowGooglePay extends StatelessWidget {
  const _WalletRowGooglePay();

  @override
  Widget build(BuildContext context) {
    return _WalletRow(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withValues(alpha: 0.10))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
        ),
      ),
      title: 'Google Pay',
      subtitle: Text('Not connected', style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w600)),
      trailing: _SmallOutlineButton(label: 'Connect', onTap: () {}),
      onTap: () {},
    );
  }
}

class _WalletRow extends StatefulWidget {
  final Widget leading;
  final String title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _WalletRow({required this.leading, required this.title, required this.subtitle, required this.trailing, required this.onTap});

  @override
  State<_WalletRow> createState() => _WalletRowState();
}

class _WalletRowState extends State<_WalletRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: b == Brightness.dark
                ? Colors.white.withValues(alpha: _hover ? 0.05 : 0.02)
                : (_hover ? Colors.grey.withValues(alpha: 0.08) : Colors.grey.withValues(alpha: 0.04)),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border.withValues(alpha: 0.55)),
          ),
          child: Row(
            children: [
              widget.leading,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: GoogleFonts.inter(color: DashboardPalette.textPrimary(b), fontSize: 13, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    widget.subtitle,
                  ],
                ),
              ),
              const SizedBox(width: 10),
              widget.trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionsPanel extends StatelessWidget {
  const _RecentTransactionsPanel();

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);

    return _GlassPanel(
      padding: const EdgeInsets.all(18),
      radius: 28,
      border: BorderSide(color: border.withValues(alpha: 0.4)),
      child: SizedBox(
        height: 520,
        child: Column(
          children: [
            Row(
              children: [
                Text('Recent Transactions', style: GoogleFonts.inter(color: DashboardPalette.textPrimary(b), fontSize: 16, fontWeight: FontWeight.w800)),
                const Spacer(),
                _IconSquareButton(icon: Icons.filter_list, onTap: () {}),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: b == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.grey.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: border),
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: DashboardPalette.textSecondary(b),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'No transactions yet',
                      style: GoogleFonts.inter(
                        color: DashboardPalette.textPrimary(b),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your card transactions will appear here',
                      style: GoogleFonts.inter(
                        color: DashboardPalette.textSecondary(b),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: b == Brightness.dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)),
            const SizedBox(height: 10),
            Center(child: _LinkButton(label: 'View all transactions', onTap: () {})),
          ],
        ),
      ),
    );
  }
}

class _TxnRow extends StatefulWidget {
  final IconData icon;
  final String title;
  final String meta;
  final String amount;
  final String status;
  final Color statusColor;

  const _TxnRow({required this.icon, required this.title, required this.meta, required this.amount, required this.status, required this.statusColor});

  @override
  State<_TxnRow> createState() => _TxnRowState();
}

class _TxnRowState extends State<_TxnRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: b == Brightness.dark
              ? Colors.white.withValues(alpha: _hover ? 0.03 : 0.00)
              : (_hover ? Colors.grey.withValues(alpha: 0.06) : Colors.transparent),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: b == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.grey.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: _hover ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.30) : border),
                boxShadow: _hover
                    ? [BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.15), blurRadius: 14)]
                    : null,
              ),
              child: Icon(widget.icon, color: textPrimary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(widget.meta, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.amount, style: GoogleFonts.inter(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(widget.status, style: GoogleFonts.inter(color: widget.statusColor, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderSide border;
  final double radius;

  const _GlassPanel({required this.child, required this.padding, required this.border, required this.radius});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.fromBorderSide(border),
        color: isDark ? null : Colors.white,
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.white.withValues(alpha: 0.05),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.18) : Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _IconCircleButton({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final color = enabled ? DashboardPalette.textPrimary(b) : DashboardPalette.textSecondary(b);
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(icon, size: 18, color: color),
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(
          isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.10),
        ),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
      ),
    );
  }
}

class _IconSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconSquareButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: DashboardPalette.iconMuted(b)),
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(
          isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.withValues(alpha: 0.10),
        ),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      ),
    );
  }
}

class _LinkButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkButton({required this.label, required this.onTap});

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final textPrimary = DashboardPalette.textPrimary(b);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: GoogleFonts.inter(color: _hover ? textPrimary : PayRouteColors.dashboardPrimary, fontSize: 12, fontWeight: FontWeight.w800),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _SmallOutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallOutlineButton({required this.label, required this.onTap});

  @override
  State<_SmallOutlineButton> createState() => _SmallOutlineButtonState();
}

class _SmallOutlineButtonState extends State<_SmallOutlineButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final isDark = b == Brightness.dark;
    final textPrimary = DashboardPalette.textPrimary(b);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: TextButton(
        onPressed: widget.onTap,
        style: ButtonStyle(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStatePropertyAll(
            isDark
                ? Colors.white.withValues(alpha: _hover ? 0.10 : 0.06)
                : (_hover ? Colors.grey.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.10)),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          side: WidgetStatePropertyAll(BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.10),
          )),
        ),
        child: Text(widget.label, style: GoogleFonts.inter(color: textPrimary, fontSize: 11, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
