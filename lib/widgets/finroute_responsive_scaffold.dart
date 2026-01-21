import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/widgets/finroute_sidebar.dart';

/// Responsive scaffold for dashboard-style pages.
///
/// - Desktop/tablet: persistent left sidebar.
/// - Mobile: Drawer navigation + compact top bar.
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
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          child: FinRouteSidebar(selectedLabel: selectedLabel),
                        ),
                      ),
                    ),
                  ),
                ),
          body: Stack(
            children: [
              if (background != null) background!,
              SafeArea(
                child: showSidebar
                    ? Row(
                        children: [
                          FinRouteSidebar(selectedLabel: selectedLabel),
                          Expanded(
                            child: Column(
                              children: [
                                if (desktopHeader != null) desktopHeader!,
                                Expanded(child: child),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
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
