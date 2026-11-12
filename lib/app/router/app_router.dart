import 'package:flutter/material.dart';

/// Composition root for screens: the only place (besides `main.dart`) that
/// reads from the service locator.
abstract final class AppRouter {
  static const String taskList = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const Scaffold(body: Center(child: Text('Tasks'))),
    );
  }
}
