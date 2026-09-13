import 'package:flutter/material.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // BRAND COLORS
  // ─────────────────────────────────────────────

  static const Color primary = Color(0xFF4F46FF);
  static const Color primaryLight = Color(0xFF6675FF);
  static const Color secondary = Color(0xFFC04DFF);
  static const Color pink = Color(0xFFE94DFF);

  // ─────────────────────────────────────────────
  // BACKGROUNDS
  // ─────────────────────────────────────────────

  static const Color background = Color(0xFFF7F8FF);
  static const Color backgroundBlue = Color(0xFFEFF4FF);

  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFF2F3FF);

  // ─────────────────────────────────────────────
  // TEXT
  // ─────────────────────────────────────────────

  static const Color textPrimary = Color(0xFF10143A);
  static const Color textSecondary = Color(0xFF687099);
  static const Color textMuted = Color(0xFF9299BA);

  // ─────────────────────────────────────────────
  // STATUS
  // ─────────────────────────────────────────────

  static const Color success = Color(0xFF16B878);
  static const Color successSoft = Color(0xFFE3F9F0);

  static const Color error = Color(0xFFE54861);

  // ─────────────────────────────────────────────
  // BORDERS
  // ─────────────────────────────────────────────

  static const Color border = Color(0xFFDDE2F2);

  // ─────────────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────────────

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      secondary,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFFF1F4FF),
      Color(0xFFF9F1FF),
      Color(0xFFF4F7FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────
  // THEME
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),

      fontFamily: 'Arial',

      // ─────────────────────────────────────────
      // APP BAR
      // ─────────────────────────────────────────

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),

      // ─────────────────────────────────────────
      // INPUT FIELDS
      // ─────────────────────────────────────────

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),

        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
        ),

        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        prefixIconColor: primary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: primary,
            width: 1.6,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: error,
            width: 1.5,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // ELEVATED BUTTON
      // ─────────────────────────────────────────

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,

          elevation: 0,

          minimumSize: const Size(
            double.infinity,
            54,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // OUTLINED BUTTON
      // ─────────────────────────────────────────

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,

          minimumSize: const Size(
            double.infinity,
            54,
          ),

          side: const BorderSide(
            color: border,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // CARD
      // ─────────────────────────────────────────

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // ─────────────────────────────────────────
      // TEXT THEME
      // ─────────────────────────────────────────

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.05,
          letterSpacing: -1.5,
        ),

        displayMedium: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.08,
          letterSpacing: -1.2,
        ),

        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          height: 1.1,
        ),

        headlineMedium: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),

        titleLarge: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),

        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),

        bodyLarge: TextStyle(
          fontSize: 16,
          color: textSecondary,
          height: 1.5,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
          height: 1.45,
        ),

        bodySmall: TextStyle(
          fontSize: 12,
          color: textMuted,
          height: 1.4,
        ),
      ),
    );
  }
}