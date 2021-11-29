import 'package:flutter/material.dart';
import '../pages/send_page.dart';
import '../pages/search_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SendPage());
      case '/second':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: const Center(
              child: Text('ERROR'),
            )));
  }
}
