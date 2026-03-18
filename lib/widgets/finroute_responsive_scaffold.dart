import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_sidebar.dart';
import 'package:payroute_desktop/widgets/support_chat_widget.dart';

import 'package:provider/provider.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';

/// Responsive scaffold for dashboard-style pages.
///
/// - Desktop/tablet: persistent left sidebar.
/// - Mobile: Bottom navigation bar + compact top bar.
class FinRouteResponsiveScaffold extends StatelessWidget {
  static const double sidebarBreakpoint = 900;

  final String selectedLabel;
  final Widget? background;
  final Widget? desktopHeader;
  final String mobileTitle;
  final String? mobileSubtitle;
  final List<Widget> mobileActions;
  final Widget child;

  const FinRouteResponsiveScaffold({
    super.key,
    required this.selectedLabel,
    required this.mobileTitle,
    this.mobileSubtitle,
    this.mobileActions = const [],
    this.background,
    this.desktopHeader,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidebar = constraints.maxWidth >= sidebarBreakpoint;
        return Scaffold(
          backgroundColor: DashboardPalette.bg(b),
          drawer: showSidebar
              ? null
              : Drawer(
                  backgroundColor: Colors.transparent,
                  child: Material(
                    color: Colors.transparent,
                    child: FinRouteSidebar(selectedLabel: selectedLabel),
                  ),
                ),
          bottomNavigationBar: showSidebar
              ? null
              : _FinRouteMobileBottomNav(selectedLabel: selectedLabel),
          body: Stack(
            children: [
              if (background != null) background!,
              showSidebar
                  ? Row(
                      children: [
                        FinRouteSidebar(selectedLabel: selectedLabel),
                        Expanded(
                          child: SafeArea(
                            child: Column(
                              children: [
                                if (desktopHeader != null) desktopHeader!,
                                Expanded(child: child),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          _FinRouteMobileTopBar(
                            title: mobileTitle,
                            subtitle: mobileSubtitle,
                            actions: mobileActions,
                          ),
                          Expanded(child: child),
                        ],
                      ),
                    ),
              Positioned(
                right: 20,
                bottom: showSidebar ? 20 : 90,
                child: const SupportChatWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FinRouteMobileTopBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  const _FinRouteMobileTopBar({required this.title, this.subtitle, required this.actions});

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final bg = DashboardPalette.bg(b);
    final border = DashboardPalette.border(b);
    final textPrimary = DashboardPalette.textPrimary(b);
    final textSecondary = DashboardPalette.textSecondary(b);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: b == Brightness.dark ? bg.withValues(alpha: 0.86) : bg,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
            icon: Icon(Icons.menu, color: DashboardPalette.iconMuted(b)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800, fontSize: 16), overflow: TextOverflow.ellipsis),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: TextStyle(color: textSecondary, fontSize: 11, height: 1.2), overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Bottom navigation bar for mobile screens
class _FinRouteMobileBottomNav extends StatelessWidget {
  final String selectedLabel;

  const _FinRouteMobileBottomNav({required this.selectedLabel});

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home, route: AppRoutes.dashboard),
    _NavItem(label: 'Send', icon: Icons.alt_route_outlined, selectedIcon: Icons.alt_route, route: AppRoutes.crossBorder),
    _NavItem(label: 'Analytics', icon: Icons.analytics_outlined, selectedIcon: Icons.analytics, route: AppRoutes.roiAnalytics),
    _NavItem(label: 'Activity', icon: Icons.list_alt_outlined, selectedIcon: Icons.list_alt, route: AppRoutes.activity),
    _NavItem(label: 'More', icon: Icons.more_horiz, selectedIcon: Icons.more_horiz, route: ''),
  ];

  int _getSelectedIndex() {
    switch (selectedLabel) {
      case 'Home': return 0;
      case 'Smart Send': return 1;
      case 'ROI Analytics': return 2;
      case 'Activity': return 3;
      case 'Exchange':
      case 'Cards':
      case 'Settings':
        return 4;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final selectedIndex = _getSelectedIndex();

    return Container(
      decoration: BoxDecoration(
        color: DashboardPalette.surfaceMuted(b),
        border: Border(top: BorderSide(color: DashboardPalette.border(b))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = index == selectedIndex;
              
              // Handle "More" button tap
              if (index == 4) {
                return _MobileNavButton(
                  icon: item.icon,
                  selectedIcon: item.selectedIcon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => _showMoreMenu(context),
                );
              }
              
              return _MobileNavButton(
                icon: item.icon,
                selectedIcon: item.selectedIcon,
                label: item.label,
                isSelected: isSelected,
                onTap: () => context.go(item.route),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    final b = Theme.of(context).brightness;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: DashboardPalette.surfaceMuted(b),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: DashboardPalette.border(b)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: DashboardPalette.border(b),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _MoreMenuItem(
                icon: Icons.currency_exchange,
                label: 'Exchange',
                isSelected: selectedLabel == 'Exchange',
                onTap: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.exchange);
                },
              ),
              _MoreMenuItem(
                icon: Icons.credit_card,
                label: 'Cards',
                isSelected: selectedLabel == 'Cards',
                onTap: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.cards);
                },
              ),
              _MoreMenuItem(
                icon: Icons.settings,
                label: 'Settings',
                isSelected: selectedLabel == 'Settings',
                onTap: () {
                  Navigator.pop(ctx);
                  context.go(AppRoutes.settings);
                },
              ),
              _MoreMenuItem(
                icon: Icons.logout,
                label: 'Log Out',
                isSelected: false,
                isDestructive: true,
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<AuthProvider>().signOut();
                  context.go(AppRoutes.login);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}

class _MobileNavButton extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileNavButton({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final color = isSelected ? PayRouteColors.dashboardPrimary : DashboardPalette.textSecondary(b);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? PayRouteColors.dashboardPrimary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDestructive;
  final VoidCallback onTap;

  const _MoreMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    final color = isDestructive
        ? Colors.redAccent
        : isSelected
            ? PayRouteColors.dashboardPrimary
            : DashboardPalette.textPrimary(b);

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: PayRouteColors.dashboardPrimary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}


