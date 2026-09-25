import 'package:flutter/material.dart';

class AppTheme {
  // ─────────────────────────────────────────────
  // Brand Colors
  // ─────────────────────────────────────────────

  static const Color primary = Color(0xFF5B5FEF);
  static const Color primaryDark = Color(0xFF4549C8);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF22C7A9);

  static const Color background = Color(0xFFF6F7FC);
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFF0F1FF);

  static const Color textPrimary = Color(0xFF171A35);
  static const Color textSecondary = Color(0xFF656B89);
  static const Color textMuted = Color(0xFF9AA0BA);

  static const Color border = Color(0xFFE1E4F0);

  static const Color success = Color(0xFF16B67A);
  static const Color successSoft = Color(0xFFE5F8F1);

  static const Color error = Color(0xFFE05268);
  static const Color errorSoft = Color(0xFFFFE9ED);

  static const Color warning = Color(0xFFE6A52F);
  static const Color warningSoft = Color(0xFFFFF4D9);

  // ─────────────────────────────────────────────
  // Gradients
  // ─────────────────────────────────────────────

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primary,
      secondary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0xFFF0F1FF),
      Color(0xFFF8F4FF),
      Color(0xFFF1FCFA),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color(0xFF252951),
      Color(0xFF343875),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),

      fontFamily: 'Arial',

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(
            color: border,
            width: 0.7,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceSoft,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
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
            width: 1.5,
          ),
        ),

        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
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

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Shadows
  // ─────────────────────────────────────────────

  static List<BoxShadow> get softShadow {
    return [
      BoxShadow(
        color: primary.withValues(alpha: 0.07),
        blurRadius: 30,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static List<BoxShadow> get cardShadow {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.045),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }
}