import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Global theme controller.
///
/// Kept deliberately lightweight (no persistence) so any widget can
/// toggle between light/dark while `MaterialApp.router` rebuilds.
class AppThemeController extends ChangeNotifier {
  ThemeMode _themeMode;

  AppThemeController({ThemeMode initialMode = ThemeMode.dark}) : _themeMode = initialMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggle() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

final AppThemeController appThemeController = AppThemeController();

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 40.0;
}

extension BrightnessContext on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

extension TextStyleContext on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}

/// PayRoute brand colors
class PayRouteColors {
  // Core palette
  static const Color earthBlack = Color(0xFF1C1917);
  static const Color earthClay = Color(0xFF78350F);
  static const Color earthSand = Color(0xFFFDF8F1);
  
  // Vibrant accents
  static const Color vibrantOrange = Color(0xFFF97316);
  static const Color vibrantOrangeDark = Color(0xFFEA580C);
  // Fintech Noir (HTML parity) accents
  static const Color fintechNoirPrimary = Color(0xFFF49D25);
  static const Color fintechNoirPrimaryLight = Color(0xFFFFB755);
  static const Color vibrantTeal = Color(0xFF0D9488);
  static const Color vibrantGold = Color(0xFFEAB308);
  static const Color electricBlue = Color(0xFF00F0FF);
  static const Color cyanGlow = Color(0xFF22D3EE);
  
  // Noir theme colors
  static const Color noirBg = Color(0xFF020408);
  /// Noir dark background, aligned with the provided HTML (#0B1120).
  static const Color noirDark = Color(0xFF0B1120);
  static const Color noirNavy = Color(0xFF0B1121);
  static const Color noirSurface = Color(0xFF131B2E);
  static const Color noirInput = Color(0xFF050914);
  
  // Electric glow colors
  static const Color electricGlow = Color(0xFF22D3EE);

  // Landing hero / entry-screen backdrop (teal noir)
  static const Color heroTeal1 = Color(0xFF0D4D4D);
  static const Color heroTeal2 = Color(0xFF0A3D3D);
  static const Color heroTeal3 = Color(0xFF082D2D);
  
  // UI colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkBg = Color(0xFF151311);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Dashboard specific colors
  static const Color dashboardBg = Color(0xFF0B0E14);
  /// Primary brand color used across dashboard UI.
  ///
  /// Kept orange to match the product’s identity and ensure consistency
  /// across buttons, active nav items, highlights, and charts.
  static const Color dashboardPrimary = vibrantOrange;

  /// Secondary orange used for subtle variation (e.g., gradients).
  static const Color dashboardAccentOrange = vibrantOrangeDark;
  static const Color dashboardSurfaceDark = Color(0xFF151A23);
  static const Color dashboardGreen = Color(0xFF22C55E);

  // Light dashboard palette
  /// Clean light background for dashboard pages.
  ///
  /// Keep this pure/clear to avoid the gray tint that makes light mode
  /// feel "muddy" compared to the intended crisp layout.
  static const Color dashboardBgLight = Colors.white;
  static const Color dashboardSurfaceLight = Color(0xFFFFFFFF);
}

/// Helper palette for the dashboard-style UI (sidebar + pages).
///
/// Most of the dashboard UI originally used hard-coded dark colors.
/// This keeps the same look in dark mode while providing a clean,
/// modern light variant when the user toggles theme.
class DashboardPalette {
  static Color bg(Brightness b) => b == Brightness.dark ? PayRouteColors.dashboardBg : PayRouteColors.dashboardBgLight;

  static Color surface(Brightness b) => b == Brightness.dark ? PayRouteColors.dashboardSurfaceDark : PayRouteColors.dashboardSurfaceLight;

  static Color surfaceMuted(Brightness b) =>
      b == Brightness.dark ? PayRouteColors.dashboardSurfaceDark.withValues(alpha: 0.6) : const Color(0xFFF1F5F9);

  static Color border(Brightness b) => b == Brightness.dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.08);

  static Color textPrimary(Brightness b) => b == Brightness.dark ? Colors.white : PayRouteColors.earthBlack;

  static Color textSecondary(Brightness b) => b == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

  static Color iconMuted(Brightness b) => b == Brightness.dark ? Colors.white70 : Colors.black54;
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,
  colorScheme: ColorScheme.light(
    primary: PayRouteColors.vibrantOrange,
    onPrimary: PayRouteColors.white,
    primaryContainer: PayRouteColors.vibrantOrange.withValues(alpha: 0.2),
    onPrimaryContainer: PayRouteColors.earthClay,
    secondary: PayRouteColors.vibrantTeal,
    onSecondary: PayRouteColors.white,
    tertiary: PayRouteColors.vibrantGold,
    onTertiary: PayRouteColors.earthBlack,
    error: const Color(0xFFBA1A1A),
    onError: PayRouteColors.white,
    surface: PayRouteColors.earthSand,
    onSurface: PayRouteColors.earthBlack,
    surfaceContainerHighest: PayRouteColors.earthClay.withValues(alpha: 0.1),
    onSurfaceVariant: PayRouteColors.earthClay,
    outline: PayRouteColors.earthClay.withValues(alpha: 0.3),
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: PayRouteColors.earthSand,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: PayRouteColors.earthBlack,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: PayRouteColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      side: BorderSide(
        color: PayRouteColors.earthClay.withValues(alpha: 0.05),
        width: 1,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: PayRouteColors.vibrantOrange,
      foregroundColor: PayRouteColors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.light),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,
  colorScheme: ColorScheme.dark(
    primary: PayRouteColors.vibrantOrange,
    onPrimary: PayRouteColors.white,
    primaryContainer: PayRouteColors.vibrantOrange.withValues(alpha: 0.3),
    onPrimaryContainer: PayRouteColors.white,
    secondary: PayRouteColors.vibrantTeal,
    onSecondary: PayRouteColors.white,
    tertiary: PayRouteColors.vibrantGold,
    onTertiary: PayRouteColors.earthBlack,
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    surface: PayRouteColors.earthBlack,
    onSurface: PayRouteColors.earthSand,
    surfaceContainerHighest: PayRouteColors.white.withValues(alpha: 0.1),
    onSurfaceVariant: PayRouteColors.earthSand.withValues(alpha: 0.7),
    outline: PayRouteColors.white.withValues(alpha: 0.2),
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: PayRouteColors.earthBlack,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: PayRouteColors.earthSand,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: PayRouteColors.white.withValues(alpha: 0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      side: BorderSide(
        color: PayRouteColors.white.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: PayRouteColors.vibrantOrange,
      foregroundColor: PayRouteColors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  textTheme: _buildTextTheme(Brightness.dark),
);

TextTheme _buildTextTheme(Brightness brightness) {
  return TextTheme(
    displayLarge: GoogleFonts.outfit(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w700,
    ),
    headlineLarge: GoogleFonts.outfit(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: GoogleFonts.outfit(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.outfit(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.outfit(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.outfit(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.outfit(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    ),
    labelSmall: GoogleFonts.outfit(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
    bodyLarge: GoogleFonts.outfit(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.outfit(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.outfit(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
  );
}
