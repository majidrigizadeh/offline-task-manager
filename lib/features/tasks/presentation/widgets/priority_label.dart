import 'package:flutter/material.dart';

import '../../../../core/constants/app_messages.dart';
import '../../domain/enums/task_priority.dart';

extension TaskPriorityLabel on TaskPriority {
  String get label => switch (this) {
    TaskPriority.low => AppMessages.priorityLow,
    TaskPriority.medium => AppMessages.priorityMedium,
    TaskPriority.high => AppMessages.priorityHigh,
  };

  Color color(ColorScheme scheme) => switch (this) {
    TaskPriority.low => scheme.outline,
    TaskPriority.medium => scheme.tertiary,
    TaskPriority.high => scheme.error,
  };
}
