import 'package:flutter/material.dart';
import 'package:pg_finding/ui/screens/index.dart';

import '../utils/index.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(
          builder: (_) => const InitScreen(),
        );
      case pgRoute:
        return MaterialPageRoute(
          builder: (_) => const PGScreen(),
        );
      case searchRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PgSearchScreen(
            onTapSave: args?['onTapSave'],
          ),
        );
      case pgDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PgDetailsScreen(
            pgDetails: args?['pgDetails'],
            onTapSave: args?['onTapSave'],
          ),
        );
      case bookingDetailsRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(
            bookingPg: args?['bookingPg'],
          ),
        );
      case profileRoute:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
