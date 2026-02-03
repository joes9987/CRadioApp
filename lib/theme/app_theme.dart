import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette - Blue and White
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color navyDark = Color(0xFF0a1929);
  static const Color navyLight = Color(0xFF1a2f4a);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFB0BEC5);

  // Gradient for background
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyDark, navyLight, Color(0xFF0a1628)],
    stops: [0.0, 0.5, 1.0],
  );

  // Blue gradient for accents
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBlue, primaryBlue, darkBlue],
  );

  // Keep goldGradient name for compatibility but use blue
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBlue, primaryBlue, darkBlue],
  );

  // Accent color (use blue instead of gold)
  static const Color goldAccent = primaryBlue;
  static const Color goldLight = lightBlue;

  // Text Styles
  static TextStyle get headingStyle => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textWhite,
        letterSpacing: 1.2,
      );

  static TextStyle get subheadingStyle => GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: lightBlue,
        letterSpacing: 0.8,
      );

  static TextStyle get bodyStyle => GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textWhite,
      );

  static TextStyle get labelStyle => GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textMuted,
        letterSpacing: 1.5,
      );

  static TextStyle get liveIndicatorStyle => GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.redAccent,
        letterSpacing: 2.0,
      );

  // Theme Data
  static ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: navyDark,
        colorScheme: const ColorScheme.dark(
          primary: primaryBlue,
          secondary: lightBlue,
          surface: navyLight,
          surfaceContainerHighest: navyDark,
        ),
        textTheme: TextTheme(
          headlineLarge: headingStyle,
          headlineMedium: subheadingStyle,
          bodyLarge: bodyStyle,
          labelLarge: labelStyle,
        ),
        iconTheme: const IconThemeData(
          color: lightBlue,
          size: 28,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: textWhite,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  // Box Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: navyLight.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryBlue.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get playButtonDecoration => BoxDecoration(
        shape: BoxShape.circle,
        gradient: blueGradient,
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      );
}
