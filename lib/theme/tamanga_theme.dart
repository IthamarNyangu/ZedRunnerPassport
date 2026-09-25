import 'package:flutter/material.dart';

abstract final class TamangaColours {
  static const green = Color(0xFF188038);
  static const deepGreen = Color(0xFF143D2B);
  static const offWhite = Color(0xFFF8F8F2);
  static const orange = Color(0xFFE57A22);
  static const red = Color(0xFFC4473D);
  static const nearBlack = Color(0xFF17231C);
  static const paleGreen = Color(0xFFE6F1E8);
  static const warmWhite = Color(0xFFFFFEFA);

  static const ink = nearBlack;
  static const forest = deepGreen;
  static const leaf = green;
  static const copper = orange;
  static const sun = orange;
  static const sand = offWhite;
  static const mist = paleGreen;
}

abstract final class TamangaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const section = 32.0;
}

abstract final class TamangaRadii {
  static const control = 14.0;
  static const card = 22.0;
  static const hero = 28.0;
  static const pill = 999.0;
}

abstract final class TamangaComponents {
  static const cardPadding = EdgeInsets.all(TamangaSpacing.xl);
  static const pagePadding = EdgeInsets.symmetric(
    horizontal: TamangaSpacing.xl,
  );
  static const controlHeight = 52.0;
}

ThemeData tamangaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: TamangaColours.green,
    brightness: Brightness.light,
    primary: TamangaColours.green,
    secondary: TamangaColours.orange,
    error: TamangaColours.red,
    surface: TamangaColours.warmWhite,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: TamangaColours.offWhite,
    fontFamily: 'Manrope',
    textTheme:
        const TextTheme(
          displaySmall: TextStyle(
            fontSize: 34,
            height: 1.04,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.1,
          ),
          headlineMedium: TextStyle(
            fontSize: 27,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 16, height: 1.45),
          bodyMedium: TextStyle(fontSize: 14, height: 1.45),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ).apply(
          bodyColor: TamangaColours.nearBlack,
          displayColor: TamangaColours.nearBlack,
        ),
    cardTheme: const CardThemeData(
      elevation: 0,
      color: TamangaColours.warmWhite,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(TamangaRadii.card)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: TamangaColours.warmWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(TamangaRadii.control)),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: TamangaSpacing.lg,
        vertical: TamangaSpacing.lg,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      elevation: 0,
      height: 72,
      backgroundColor: TamangaColours.warmWhite,
      indicatorColor: TamangaColours.paleGreen,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, TamangaComponents.controlHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TamangaRadii.control),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, TamangaComponents.controlHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TamangaRadii.control),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TamangaRadii.pill),
      ),
      side: BorderSide(color: TamangaColours.deepGreen.withValues(alpha: .18)),
      backgroundColor: TamangaColours.warmWhite,
      selectedColor: TamangaColours.paleGreen,
      checkmarkColor: TamangaColours.deepGreen,
      labelStyle: const TextStyle(
        color: TamangaColours.nearBlack,
        fontWeight: FontWeight.w700,
      ),
      secondaryLabelStyle: const TextStyle(
        color: TamangaColours.nearBlack,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
