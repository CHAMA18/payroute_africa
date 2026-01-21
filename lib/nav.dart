import 'package:payroute_desktop/pages/landing_page.dart';
import 'package:payroute_desktop/pages/login_page.dart';
import 'package:payroute_desktop/pages/dashboard_page.dart';
import 'package:payroute_desktop/pages/activity_page.dart';
import 'package:payroute_desktop/pages/exchange_page.dart';
import 'package:payroute_desktop/pages/cards_page.dart';
import 'package:payroute_desktop/pages/settings_page.dart';
import 'package:payroute_desktop/pages/create_account_page.dart';
import 'package:payroute_desktop/pages/select_account_type_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// GoRouter configuration for app navigation
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      // When a route throws during build, it can appear as a blank screen on web.
      // Provide a visible fallback plus logs.
      final error = state.error;
      debugPrint('GoRouter error at location="${state.uri}": $error');
      return MaterialPage<void>(
        key: state.pageKey,
        child: RouterErrorPage(
          location: state.uri.toString(),
          error: error,
        ),
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LandingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.createAccount,
        name: 'createAccount',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CreateAccountPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.selectAccountType,
        name: 'selectAccountType',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SelectAccountTypePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DashboardPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.activity,
        name: 'activity',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ActivityPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.exchange,
        name: 'exchange',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ExchangePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.cards,
        name: 'cards',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CardsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SettingsPage(),
        ),
      ),
    ],
  );
}

class RouterErrorPage extends StatelessWidget {
  final String location;
  final Object? error;

  const RouterErrorPage({super.key, required this.location, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Navigation error', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text('Tried to open: $location', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70, height: 1.4)),
                  const SizedBox(height: 12),
                  if (error != null)
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.redAccent, height: 1.4),
                    ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: () => context.go(AppRoutes.home),
                        icon: const Icon(Icons.home, color: Colors.black),
                        label: const Text('Back to Home', style: TextStyle(color: Colors.black)),
                        style: FilledButton.styleFrom(backgroundColor: Colors.white),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text('Go to Login', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24)),
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
  }
}

/// Route path constants
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String selectAccountType = '/select-account-type';
  static const String dashboard = '/dashboard';
  static const String activity = '/activity';
  static const String exchange = '/exchange';
  static const String cards = '/cards';
  static const String settings = '/settings';
}
