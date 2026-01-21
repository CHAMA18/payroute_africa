import 'package:flutter/material.dart';
import 'package:payroute_desktop/theme.dart';
import 'package:payroute_desktop/nav.dart';

void main() {
  runApp(const PayRouteApp());
}

class PayRouteApp extends StatelessWidget {
  const PayRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appThemeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'PayRoute',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: appThemeController.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
