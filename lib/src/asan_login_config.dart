import 'package:asan_login_flutter/src/asan_login_environment.dart';

class AsanLoginConfig {
  /// The `mobileKey` for Android (a.k.a `packageName`) under which your project is
  /// registered on `ASAN Login`
  final String mobileKeyAndroid;

  /// The `mobileKey` for iOS (a.k.a `packageName`) under which your project is
  /// registered on `ASAN Login`
  final String mobileKeyIos;

  /// Defines environment for `ASAN Login`.
  final AsanLoginEnvironment environment;

  /// When set as true, user stays as logged in if previously logged.
  final bool clearCookies;

  /// Configurations for `AsanLoginView`
  const AsanLoginConfig({
    required this.mobileKeyAndroid,
    required this.mobileKeyIos,
    this.environment = AsanLoginEnvironment.prod,
    this.clearCookies = true,
  });
}
