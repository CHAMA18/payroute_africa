import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:payroute_desktop/firebase_options.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/nav.dart';
import 'package:payroute_desktop/providers/auth_provider.dart';
import 'package:payroute_desktop/providers/organization_application_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('LegacyJavaScriptObject')) {
      return;
    }
    if (originalOnError != null) {
      originalOnError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (error.toString().contains('LegacyJavaScriptObject')) {
      return true;
    }
    return false;
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PayRouteApp());
}

class PayRouteApp extends StatefulWidget {
  const PayRouteApp({super.key});

  @override
  State<PayRouteApp> createState() => _PayRouteAppState();
}

class _PayRouteAppState extends State<PayRouteApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _router = AppRouter.createRouter(_authProvider);
    // Set the static router for backward compatibility
    AppRouter.router = _router;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (_) => OrganizationApplicationProvider()),
      ],
      child: AnimatedBuilder(
        animation: appThemeController,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'PayRoute',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: appThemeController.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
