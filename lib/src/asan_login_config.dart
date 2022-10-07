import 'package:asan_login_flutter/src/asan_login_environment.dart';

/// Configurations for [AsanLoginView]
class AsanLoginConfig {
  /// Defines environment for `ASAN Login`.
  final AsanLoginEnvironment environment;

  /// When set as true, user stays as logged in if previously logged.
  final bool clearCookies;

  const AsanLoginConfig({
    this.environment = AsanLoginEnvironment.prod,
    this.clearCookies = true,
  });
}
