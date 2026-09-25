import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyFlow Dashboard',
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),

      home: DashboardScreen(
        isDark: isDark,
        onThemeToggle: toggleTheme,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDarkMode = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6750A4),
        brightness: brightness,
      ),

      scaffoldBackgroundColor: isDarkMode
          ? const Color(0xFF121016)
          : const Color(0xFFF6F4FA),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: isDarkMode
            ? Colors.white
            : const Color(0xFF24212B),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: isDarkMode
            ? const Color(0xFF1D1A22)
            : Colors.white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode
            ? const Color(0xFF1D1A22)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}