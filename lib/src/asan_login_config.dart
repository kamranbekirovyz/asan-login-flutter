import 'package:asan_login_flutter/src/asan_login_environment.dart';
import 'package:flutter/material.dart';

/// Configurations for [AsanLoginView]
class AsanLoginConfig {
  /// Defines environment for `ASAN Login`.
  final AsanLoginEnvironment environment;

  /// When set to true user stays as logged in if previously logged.
  final bool clearCookies;

  /// Color for progress indicator at the top of the [AsanLoginView].
  final Color progressColor;

  const AsanLoginConfig({
    this.environment = AsanLoginEnvironment.prod,
    this.clearCookies = true,
    this.progressColor = Colors.indigo,
  });
}
