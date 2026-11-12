import 'package:flutter/material.dart';

import '../core/constants/app_messages.dart';
import 'router/app_router.dart';

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppMessages.appTitle,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.taskList,
    );
  }
}
