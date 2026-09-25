import 'package:flutter/material.dart';

abstract final class TamangaColours {
  static const ink = Color(0xFF11251E);
  static const forest = Color(0xFF1D6B4D);
  static const leaf = Color(0xFF84A957);
  static const copper = Color(0xFFE56A38);
  static const sun = Color(0xFFF3C84B);
  static const sand = Color(0xFFF6F1E7);
  static const mist = Color(0xFFE8EFE9);
}

ThemeData tamangaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: TamangaColours.forest,
    brightness: Brightness.light,
    primary: TamangaColours.forest,
    secondary: TamangaColours.copper,
    surface: const Color(0xFFFFFCF6),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: TamangaColours.sand,
    fontFamily: 'sans-serif',
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 36,
        height: 1.02,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 27,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ).apply(bodyColor: TamangaColours.ink, displayColor: TamangaColours.ink),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: Color(0xFFFFFCF6),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFFFFCF6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide.none,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 0,
      height: 72,
      backgroundColor: Color(0xFFFFFCF6),
      indicatorColor: TamangaColours.mist,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
