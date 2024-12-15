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
            onChangeBookingStatus: args?['onChangeBookingStatus'],
          ),
        );
      case profileRoute:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );
      case mapRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MapScreen(
            locationData: args?['locationData'],
            onTapSave: args?['onTapSave'],
            pgList: args?['pgList'],
            fromSearchRoute: args?['fromSearchRoute'],
          ),
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
