import 'package:flutter/material.dart';

class AsanLoginConfig {
  final bool isDevMode;
  final bool clearCookies;
  final Color progressColor;

  const AsanLoginConfig({
    this.isDevMode = false,
    this.clearCookies = true,
    this.progressColor = Colors.indigo,
  });
}
