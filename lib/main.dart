import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PulseApiApp());
}

class PulseApiApp extends StatelessWidget {
  const PulseApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseAPI',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const HomeScreen(),
    );
  }
}