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
        return MaterialPageRoute(
          builder: (_) => const PgSearchScreen(),
        );
      case pgDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => const PgDetailsScreen(),
        );
      case bookingDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => const BookingDetailsScreen(),
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
