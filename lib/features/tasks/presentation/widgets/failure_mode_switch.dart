import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/write_failure_config.dart';
import '../../../../core/constants/app_messages.dart';

/// Developer control for write-failure simulation. Only shown in debug builds
/// or when the app was launched with `--dart-define=FAIL_WRITES=true`.
class FailureModeSwitch extends StatefulWidget {
  const FailureModeSwitch({super.key, required this.config});

  final WriteFailureConfig config;

  static bool get isAvailable =>
      kDebugMode || WriteFailureConfig.enabledAtLaunch;

  @override
  State<FailureModeSwitch> createState() => _FailureModeSwitchState();
}

class _FailureModeSwitchState extends State<FailureModeSwitch> {
  @override
  Widget build(BuildContext context) {
    if (!FailureModeSwitch.isAvailable) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AppMessages.failWrites),
          Switch(
            value: widget.config.enabled,
            onChanged: (value) => setState(() => widget.config.enabled = value),
          ),
        ],
      ),
    );
  }
}
