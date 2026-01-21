import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';

/// Reusable left sidebar used across dashboard-style pages.
///
/// Uses `go_router` navigation. The current page should provide [selectedLabel]
/// to highlight the active item.
class FinRouteSidebar extends StatelessWidget {
  final String selectedLabel;

  const FinRouteSidebar({super.key, required this.selectedLabel});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final shadowColor = brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.55) : Colors.black.withValues(alpha: 0.08);
    return SizedBox(
      width: 280,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 12),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: DashboardPalette.surfaceMuted(brightness),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: DashboardPalette.border(brightness)),
            boxShadow: [
              BoxShadow(color: shadowColor, blurRadius: 26, offset: const Offset(0, 14)),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(colors: [PayRouteColors.dashboardPrimary, PayRouteColors.dashboardAccentOrange]),
                        boxShadow: [
                          BoxShadow(color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.4), blurRadius: 25, spreadRadius: 4),
                        ],
                      ),
                      child: const Icon(Icons.hub, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'FinRoute.io',
                      style: GoogleFonts.inter(
                        color: DashboardPalette.textPrimary(brightness),
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 12),
                  children: [
                    FinRouteNavItem(
                      label: 'Home',
                      icon: Icons.home,
                      selected: selectedLabel == 'Home',
                      onTap: () => context.go(AppRoutes.dashboard),
                    ),
                    FinRouteNavItem(
                      label: 'Activity',
                      icon: Icons.list_alt,
                      selected: selectedLabel == 'Activity',
                      onTap: () => context.go(AppRoutes.activity),
                    ),
                    FinRouteNavItem(
                      label: 'Exchange',
                      icon: Icons.currency_exchange,
                      selected: selectedLabel == 'Exchange',
                      onTap: () => context.go(AppRoutes.exchange),
                    ),
                    FinRouteNavItem(
                      label: 'Cards',
                      icon: Icons.credit_card,
                      selected: selectedLabel == 'Cards',
                      onTap: () => context.go(AppRoutes.cards),
                    ),
                    FinRouteNavItem(
                      label: 'Settings',
                      icon: Icons.settings,
                      selected: selectedLabel == 'Settings',
                      onTap: () => context.go(AppRoutes.settings),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const _ThemeToggleCard(),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [DashboardPalette.surface(brightness), DashboardPalette.bg(brightness).withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: DashboardPalette.border(brightness)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.headset_mic, color: DashboardPalette.iconMuted(brightness), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Need help?', style: GoogleFonts.inter(color: DashboardPalette.textPrimary(brightness), fontSize: 12, fontWeight: FontWeight.w700)),
                          Text('Contact support', style: GoogleFonts.inter(color: DashboardPalette.textSecondary(brightness), fontSize: 10)),
                        ],
                      ),
                    ],
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

class _ThemeToggleCard extends StatelessWidget {
  const _ThemeToggleCard();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeController,
      builder: (context, _) {
        final brightness = Theme.of(context).brightness;
        final isDark = appThemeController.isDark;
        final titleColor = DashboardPalette.textPrimary(brightness);
        final subtitleColor = DashboardPalette.textSecondary(brightness);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: DashboardPalette.border(brightness)),
            color: PayRouteColors.dashboardPrimary.withValues(alpha: isDark ? 0.10 : 0.08),
          ),
          child: ListTile(
            onTap: appThemeController.toggle,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                key: ValueKey(isDark),
                color: PayRouteColors.dashboardPrimary,
              ),
            ),
            title: Text(
              isDark ? 'Dark Mode' : 'Light Mode',
              style: GoogleFonts.inter(color: titleColor, fontWeight: FontWeight.w800, fontSize: 12),
            ),
            subtitle: Text(
              isDark ? 'Tap to switch to light' : 'Tap to switch to dark',
              style: GoogleFonts.inter(color: subtitleColor, fontSize: 10, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right, color: DashboardPalette.iconMuted(brightness)),
          ),
        );
      },
    );
  }
}

class FinRouteNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const FinRouteNavItem({super.key, required this.label, required this.icon, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = selected ? DashboardPalette.textPrimary(brightness) : DashboardPalette.textSecondary(brightness);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.3) : DashboardPalette.border(brightness)),
        ),
        child: ListTile(
          onTap: onTap,
          dense: true,
          leading: Icon(icon, color: selected ? PayRouteColors.dashboardPrimary : color),
          title: Text(label, style: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600)),
          trailing: selected
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: PayRouteColors.dashboardPrimary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: PayRouteColors.dashboardPrimary, blurRadius: 10, spreadRadius: 2),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
