import 'package:flutter/material.dart';

import '../../domain/enums/task_priority.dart';

extension TaskPriorityLabel on TaskPriority {
  String get label => switch (this) {
    TaskPriority.low => 'Low',
    TaskPriority.medium => 'Medium',
    TaskPriority.high => 'High',
  };

  Color color(ColorScheme scheme) => switch (this) {
    TaskPriority.low => scheme.outline,
    TaskPriority.medium => scheme.tertiary,
    TaskPriority.high => scheme.error,
  };
}
