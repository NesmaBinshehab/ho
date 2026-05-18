import 'package:flutter/material.dart';
import '../../customer_app/screens/order_tracking_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.tracking:
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route Not Found")),
          ),
        );
    }
  }
}