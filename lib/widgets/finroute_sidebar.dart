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
                padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/Dynamic_Logo_for_PayRoute_Africa_1.png',
                    width: 420,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    FinRouteNavItem(
                      label: 'Home',
                      icon: Icons.home,
                      selected: selectedLabel == 'Home',
                      onTap: () => context.go(AppRoutes.dashboard),
                    ),
                    FinRouteNavItem(
                      label: 'Smart Send',
                      icon: Icons.alt_route,
                      selected: selectedLabel == 'Smart Send',
                      onTap: () => context.go(AppRoutes.smartSend),
                    ),
                    FinRouteNavItem(
                      label: 'ROI Analytics',
                      icon: Icons.analytics,
                      selected: selectedLabel == 'ROI Analytics',
                      onTap: () => context.go(AppRoutes.roiAnalytics),
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
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LogoutButton(),
              ),
              const SizedBox(height: 20),
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

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final titleColor = DashboardPalette.textPrimary(brightness);
    final subtitleColor = DashboardPalette.textSecondary(brightness);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DashboardPalette.border(brightness)),
        color: Colors.red.withValues(alpha: brightness == Brightness.dark ? 0.10 : 0.08),
      ),
      child: ListTile(
        onTap: () => context.go(AppRoutes.login),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(Icons.logout, color: Colors.redAccent),
        title: Text(
          'Log Out',
          style: GoogleFonts.inter(color: titleColor, fontWeight: FontWeight.w800, fontSize: 12),
        ),
        subtitle: Text(
          'Sign out of your account',
          style: GoogleFonts.inter(color: subtitleColor, fontSize: 10, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.chevron_right, color: DashboardPalette.iconMuted(brightness)),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
