import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xxs = 6;
  static const double xs = 10;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
  static const double xxl = 64;
}

TextStyle get heroTextStyle => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 56,
  fontWeight: FontWeight.w800,
  height: 1.05,
  letterSpacing: -1.0,
);

TextStyle get sectionTitleTextStyle => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 28,
  fontWeight: FontWeight.w700,
  height: 1.25,
);

TextStyle get bodyTextStyle => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.75,
);

final ColorScheme _lightColorScheme =
    ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: Brightness.light,
      secondary: const Color(0xFF22D3EE),
    ).copyWith(
      surface: const Color(0xFFF8FAFC),
      surfaceTint: Colors.white,
      onSurface: const Color(0xFF0F172A),
    );

final ColorScheme _darkColorScheme =
    ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: Brightness.dark,
      secondary: const Color(0xFF38BDF8),
    ).copyWith(
      surface: const Color(0xFF0B1220),
      surfaceTint: const Color(0xFF111827),
      onSurface: const Color(0xFFF8FAFC),
    );

final ThemeData appLightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  scaffoldBackgroundColor: _lightColorScheme.surface,
  textTheme: TextTheme(
    displayLarge: heroTextStyle.copyWith(color: _lightColorScheme.onSurface),
    displayMedium: sectionTitleTextStyle.copyWith(
      color: _lightColorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: _lightColorScheme.onSurface,
    ),
    bodyLarge: bodyTextStyle.copyWith(color: _lightColorScheme.onSurface),
    bodyMedium: bodyTextStyle.copyWith(color: const Color(0xFF475569)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightColorScheme.surface,
    foregroundColor: _lightColorScheme.onSurface,
    elevation: 0,
    surfaceTintColor: _lightColorScheme.surface,
    iconTheme: IconThemeData(color: _lightColorScheme.onSurface),
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    elevation: 4,
    surfaceTintColor: Colors.white,
    margin: EdgeInsets.zero,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _lightColorScheme.primary,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFFE2E8F0), thickness: 1),
);

final ThemeData appDarkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkColorScheme,
  scaffoldBackgroundColor: _darkColorScheme.surface,
  textTheme: TextTheme(
    displayLarge: heroTextStyle.copyWith(color: _darkColorScheme.onSurface),
    displayMedium: sectionTitleTextStyle.copyWith(
      color: _darkColorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: _darkColorScheme.onSurface,
    ),
    bodyLarge: bodyTextStyle.copyWith(color: _darkColorScheme.onSurface),
    bodyMedium: bodyTextStyle.copyWith(color: const Color(0xFFCBD5E1)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _darkColorScheme.surface,
    foregroundColor: _darkColorScheme.onSurface,
    elevation: 0,
    surfaceTintColor: _darkColorScheme.surface,
    iconTheme: IconThemeData(color: _darkColorScheme.onSurface),
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF0B1220),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    elevation: 4,
    surfaceTintColor: Color(0xFF111827),
    margin: EdgeInsets.zero,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _darkColorScheme.secondary,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFF334155), thickness: 1),
);
