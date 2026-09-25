import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/detail_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const FormFlowApp());
}

class FormFlowApp extends StatelessWidget {
  const FormFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormFlow',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialRoute: '/',

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildRoute(
              const HomeScreen(),
              settings,
              type: _TransitionType.fade,
            );

          case '/form':
            return _buildRoute(
              const RegistrationScreen(),
              settings,
              type: _TransitionType.slideUp,
            );

          case '/details':
            return _buildRoute(
              const DetailScreen(),
              settings,
              type: _TransitionType.scaleFade,
            );

          default:
            return _buildRoute(
              const HomeScreen(),
              settings,
              type: _TransitionType.fade,
            );
        }
      },
    );
  }

  PageRouteBuilder _buildRoute(
    Widget page,
    RouteSettings settings, {
    required _TransitionType type,
  }) {
    return PageRouteBuilder(
      settings: settings,

      transitionDuration: const Duration(
        milliseconds: 500,
      ),

      reverseTransitionDuration: const Duration(
        milliseconds: 350,
      ),

      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return page;
      },

      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        switch (type) {
          case _TransitionType.fade:
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            );

          case _TransitionType.slideUp:
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );

          case _TransitionType.scaleFade:
            final scaleAnimation = Tween<double>(
              begin: 0.94,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            );

            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
        }
      },
    );
  }
}

enum _TransitionType {
  fade,
  slideUp,
  scaleFade,
}