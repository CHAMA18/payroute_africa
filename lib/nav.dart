import 'package:payroute_desktop/pages/landing_page.dart';
import 'package:payroute_desktop/pages/login_page.dart';
import 'package:payroute_desktop/pages/dashboard_page.dart';
import 'package:payroute_desktop/pages/activity_page.dart';
import 'package:payroute_desktop/pages/wallet_page.dart';
import 'package:payroute_desktop/pages/exchange_page.dart';
import 'package:payroute_desktop/pages/cards_page.dart';
import 'package:payroute_desktop/pages/settings_page.dart';
import 'package:payroute_desktop/pages/create_account_page.dart';
import 'package:payroute_desktop/pages/select_account_type_page.dart';
import 'package:payroute_desktop/pages/entity_details_page.dart';
import 'package:payroute_desktop/pages/authorized_rep_page.dart';
import 'package:payroute_desktop/pages/ownership_page.dart';
import 'package:payroute_desktop/pages/review_page.dart';
import 'package:payroute_desktop/pages/success_page.dart';
import 'package:payroute_desktop/pages/smart_send_page.dart';
import 'package:payroute_desktop/pages/roi_analytics_page.dart';
import 'package:payroute_desktop/pages/cross_border_page.dart';
import 'package:payroute_desktop/models/account_type.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// GoRouter configuration for app navigation
class AppRouter {
  // Legacy static router for backward compatibility - will be replaced by instance router
  static late GoRouter router;
  
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppRoutes.landing,
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isInitialized = authProvider.isInitialized;
        final rememberMe = authProvider.rememberMe;
        final location = state.uri.path;
        
        // Wait for auth to initialize
        if (!isInitialized) {
          return null;
        }
        
        // Public routes that don't require authentication
        final publicRoutes = [
          AppRoutes.landing,
          AppRoutes.login,
          AppRoutes.selectAccountType,
          AppRoutes.createAccount,
          AppRoutes.entityDetails,
          AppRoutes.authorizedRep,
          AppRoutes.ownership,
          AppRoutes.review,
          AppRoutes.success,
        ];
        
        final isPublicRoute = publicRoutes.contains(location);
        
        // If user is authenticated and on landing or login page with remember me enabled, redirect to dashboard
        if (isAuthenticated && rememberMe && (location == AppRoutes.login || location == AppRoutes.landing)) {
          return AppRoutes.dashboard;
        }
        
        // If user is not authenticated and trying to access protected route, redirect to landing
        if (!isAuthenticated && !isPublicRoute) {
          return AppRoutes.landing;
        }
        
        return null;
      },
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
        path: AppRoutes.landing,
        name: 'landing',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LandingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.selectAccountType,
        name: 'selectAccountType',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SelectAccountTypePage(),
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
        pageBuilder: (context, state) {
          final accountType = state.extra as AccountType? ?? AccountType.personal;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreateAccountPage(accountType: accountType),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.entityDetails,
        name: 'entityDetails',
        pageBuilder: (context, state) {
          final accountType = state.extra as AccountType? ?? AccountType.organization;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EntityDetailsPage(accountType: accountType),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.authorizedRep,
        name: 'authorizedRep',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AuthorizedRepPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.ownership,
        name: 'ownership',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OwnershipPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.review,
        name: 'review',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ReviewPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.success,
        name: 'success',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SuccessPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
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
        path: AppRoutes.wallet,
        name: 'wallet',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: WalletPage(),
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
        path: AppRoutes.crossBorder,
        name: 'crossBorder',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CrossBorderPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.smartSend,
        name: 'smartSend',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SmartSendPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.roiAnalytics,
        name: 'roiAnalytics',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ROIAnalyticsPage(),
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
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.landing),
                    icon: const Icon(Icons.home, color: Colors.black),
                    label: const Text('Back to Home', style: TextStyle(color: Colors.black)),
                    style: FilledButton.styleFrom(backgroundColor: Colors.white),
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
  static const String landing = '/';
  static const String login = '/login';
  static const String selectAccountType = '/select-account-type';
  static const String createAccount = '/create-account';
  static const String entityDetails = '/entity-details';
  static const String authorizedRep = '/authorized-rep';
  static const String ownership = '/ownership';
  static const String review = '/review';
  static const String success = '/success';
  static const String dashboard = '/dashboard';
  static const String wallet = '/wallet';
  static const String activity = '/activity';
  static const String exchange = '/exchange';
  static const String cards = '/cards';
  static const String settings = '/settings';
  static const String smartSend = '/smart-send';
  static const String roiAnalytics = '/roi-analytics';
  static const String crossBorder = '/cross-border';
}
