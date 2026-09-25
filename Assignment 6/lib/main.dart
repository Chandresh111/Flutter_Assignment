import 'package:flutter/material.dart';

import 'screens/catalog_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const ShoplyApp());
}

class ShoplyApp extends StatelessWidget {
  const ShoplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoply',
      theme: AppTheme.lightTheme(),
      home: const CatalogScreen(),
    );
  }
}