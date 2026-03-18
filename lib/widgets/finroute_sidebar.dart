import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';

import 'package:provider/provider.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

// Global state to persist collapse state across navigations
final ValueNotifier<bool> finRouteSidebarCollapsed = ValueNotifier<bool>(false);

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
    final isDark = brightness == Brightness.dark;

    // Create an elegant, very soft drop shadow for the sidebar container
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.04);

    return ValueListenableBuilder<bool>(
      valueListenable: finRouteSidebarCollapsed,
      builder: (context, isCollapsed, child) {
        final width = isCollapsed ? 88.0 : 280.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: width,
          height: double.infinity,
          decoration: BoxDecoration(
            color: DashboardPalette.surface(brightness),
            border: Border(
              right: BorderSide(
                color: DashboardPalette.border(brightness).withValues(alpha: isDark ? 0.2 : 0.6),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 32,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BrandHeader(brightness: brightness, isCollapsed: isCollapsed),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      FinRouteNavItem(
                        label: 'Home',
                        icon: Icons.home_rounded,
                        selected: selectedLabel == 'Home',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.dashboard),
                      ),
                      FinRouteNavItem(
                        label: 'Wallet',
                        icon: Icons.account_balance_wallet_rounded,
                        selected: selectedLabel == 'Wallet',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.wallet),
                      ),
                      FinRouteNavItem(
                        label: 'Cross-Border',
                        icon: Icons.public_rounded,
                        selected: selectedLabel == 'Cross-Border',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.crossBorder),
                      ),
                      FinRouteNavItem(
                        label: 'Saving Goals',
                        icon: Icons.savings_rounded,
                        selected: selectedLabel == 'Saving Goals',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.savingGoals),
                      ),
                      FinRouteNavItem(
                        label: 'ROI Analytics',
                        icon: Icons.analytics_rounded,
                        selected: selectedLabel == 'ROI Analytics',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.roiAnalytics),
                      ),
                      FinRouteNavItem(
                        label: 'Activity',
                        icon: Icons.receipt_long_rounded,
                        selected: selectedLabel == 'Activity',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.activity),
                      ),
                      FinRouteNavItem(
                        label: 'Exchange',
                        icon: Icons.currency_exchange_rounded,
                        selected: selectedLabel == 'Exchange',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.exchange),
                      ),
                      FinRouteNavItem(
                        label: 'Cards',
                        icon: Icons.credit_card_rounded,
                        selected: selectedLabel == 'Cards',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.cards),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: Divider(
                          height: 1,
                          color: DashboardPalette.border(brightness),
                        ),
                      ),
                      FinRouteNavItem(
                        label: 'Settings',
                        icon: Icons.settings_rounded,
                        selected: selectedLabel == 'Settings',
                        isCollapsed: isCollapsed,
                        onTap: () => context.go(AppRoutes.settings),
                      ),
                    ],
                  ),
                ),
                _ThemeToggleCard(isCollapsed: isCollapsed),
                const SizedBox(height: 8),
                _LogoutButton(isCollapsed: isCollapsed),
                const SizedBox(height: 8),
                _CollapseToggleButton(isCollapsed: isCollapsed),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final Brightness brightness;
  final bool isCollapsed;

  const _BrandHeader({required this.brightness, required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCollapsed ? 8 : 20,
        26,
        isCollapsed ? 8 : 20,
        20,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            // 2x larger logo when expanded (160 height instead of 80).
            height: isCollapsed ? 48 : 160,
            child: Image.asset(
              'assets/images/Dynamic.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleCard extends StatefulWidget {
  final bool isCollapsed;
  const _ThemeToggleCard({required this.isCollapsed});

  @override
  State<_ThemeToggleCard> createState() => _ThemeToggleCardState();
}

class _ThemeToggleCardState extends State<_ThemeToggleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeController,
      builder: (context, _) {
        final brightness = Theme.of(context).brightness;
        final isDark = appThemeController.isDark;

        final hoverColor = DashboardPalette.textSecondary(brightness).withValues(alpha: 0.06);
        final bgColor = _isHovered ? hoverColor : Colors.transparent;

        return Tooltip(
          message: widget.isCollapsed ? (isDark ? 'Light Mode' : 'Dark Mode') : '',
          waitDuration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: appThemeController.toggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isCollapsed ? 0 : 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: widget.isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            key: ValueKey(isDark),
                            color: PayRouteColors.dashboardPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      ClipRect(
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: widget.isCollapsed ? 0 : 1,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: widget.isCollapsed ? 0 : 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isDark ? 'Dark Mode' : 'Light Mode',
                                      style: GoogleFonts.outfit(
                                        color: DashboardPalette.textPrimary(brightness),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isDark ? 'Tap to switch to light' : 'Tap to switch to dark',
                                      style: GoogleFonts.outfit(
                                        color: DashboardPalette.textSecondary(brightness),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        );
      },
    );
  }
}

class _LogoutButton extends StatefulWidget {
  final bool isCollapsed;
  const _LogoutButton({required this.isCollapsed});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final hoverColor = Colors.redAccent.withValues(alpha: 0.08);
    final bgColor = _isHovered ? hoverColor : Colors.transparent;

    return Tooltip(
      message: widget.isCollapsed ? 'Log Out' : '',
      waitDuration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.read<AuthProvider>().signOut();
              context.go(AppRoutes.login);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 0 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: widget.isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.isCollapsed ? 0 : 1,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.isCollapsed ? 0 : 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log Out',
                                  style: GoogleFonts.outfit(
                                    color: DashboardPalette.textPrimary(brightness),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Sign out of your account',
                                  style: GoogleFonts.outfit(
                                    color: DashboardPalette.textSecondary(brightness),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}

class _CollapseToggleButton extends StatefulWidget {
  final bool isCollapsed;
  const _CollapseToggleButton({required this.isCollapsed});

  @override
  State<_CollapseToggleButton> createState() => _CollapseToggleButtonState();
}

class _CollapseToggleButtonState extends State<_CollapseToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final hoverColor = DashboardPalette.textSecondary(brightness).withValues(alpha: 0.06);
    final bgColor = _isHovered ? hoverColor : Colors.transparent;

    return Tooltip(
      message: widget.isCollapsed ? 'Expand' : 'Collapse',
      waitDuration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => finRouteSidebarCollapsed.value = !widget.isCollapsed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 0 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: widget.isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: DashboardPalette.textSecondary(brightness).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.isCollapsed
                          ? Icons.keyboard_double_arrow_right_rounded
                          : Icons.keyboard_double_arrow_left_rounded,
                      color: DashboardPalette.textPrimary(brightness),
                      size: 20,
                    ),
                  ),
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.isCollapsed ? 0 : 1,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.isCollapsed ? 0 : 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 14),
                            Text(
                              'Collapse sidebar',
                              style: GoogleFonts.outfit(
                                color: DashboardPalette.textPrimary(brightness),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
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
    );
  }
}

class FinRouteNavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;
  final bool isCollapsed;

  const FinRouteNavItem({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
    this.isCollapsed = false,
  });

  @override
  State<FinRouteNavItem> createState() => _FinRouteNavItemState();
}

class _FinRouteNavItemState extends State<FinRouteNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final hoveredBgColor = DashboardPalette.textSecondary(brightness).withValues(alpha: 0.06);

    final gradient = widget.selected
        ? const LinearGradient(
            colors: [
              PayRouteColors.dashboardPrimary,
              PayRouteColors.dashboardAccentOrange,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final bgColor = widget.selected ? null : (_isHovered ? hoveredBgColor : Colors.transparent);

    final selectedTextColor = Colors.white;
    final defaultTextColor = DashboardPalette.textSecondary(brightness);
    final hoverTextColor = DashboardPalette.textPrimary(brightness);
    final textColor = widget.selected
        ? selectedTextColor
        : (_isHovered ? hoverTextColor : defaultTextColor);

    final selectedIconColor = Colors.white;
    final defaultIconColor = DashboardPalette.iconMuted(brightness);
    final hoverIconColor = DashboardPalette.textPrimary(brightness);
    final iconColor = widget.selected
        ? selectedIconColor
        : (_isHovered ? hoverIconColor : defaultIconColor);

    return Tooltip(
      message: widget.isCollapsed ? widget.label : '',
      waitDuration: const Duration(milliseconds: 400),
      verticalOffset: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 0 : 18,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.selected
                    ? [
                        BoxShadow(
                          color: PayRouteColors.dashboardPrimary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: widget.isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      key: ValueKey<bool>(widget.selected),
                      color: iconColor,
                      size: widget.isCollapsed ? 26 : 22,
                    ),
                  ),
                  ClipRect(
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.centerLeft,
                      widthFactor: widget.isCollapsed ? 0 : 1,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.isCollapsed ? 0 : 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 16),
                            Text(
                              widget.label,
                              style: GoogleFonts.outfit(
                                color: textColor,
                                fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            if (_isHovered && !widget.selected) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: DashboardPalette.textSecondary(brightness)
                                    .withValues(alpha: 0.5),
                                size: 18,
                              ),
                            ]
                          ],
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
    );
  }
}
