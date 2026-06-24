import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Neo-brutalism color palette based on Stitch Notefly
  static const Color primary = Color(0xFF2DD4BF); // Soft Teal
  static const Color primaryDark = Color(0xFF006B5F);
  static const Color background = Color(0xFFF9F9FF);
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF111C2D);
  static const Color border = Colors.black;
  static const Color error = Color(0xFFBA1A1A);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();
    
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.black,
        secondary: primaryDark,
        surface: surface,
        onSurface: onSurface,
        error: error,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: onSurface,
          letterSpacing: -1,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0), // Sharp edges
          side: const BorderSide(color: border, width: 3),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: border, width: 3),
          ),
        ),
      ),
    );
  }

  // Helper for neo-brutalist shadow
  static List<BoxShadow> get brutalShadow {
    return [
      const BoxShadow(
        color: Colors.black,
        offset: Offset(4, 4),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }
  
  static List<BoxShadow> get brutalShadowActive {
    return [
      const BoxShadow(
        color: Colors.black,
        offset: Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 0,
      ),
    ];
  }
}
