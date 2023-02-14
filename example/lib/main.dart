import 'dart:developer';

import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ASAN Login Example',
      home: AsanLoginDemoScreen(),
    );
  }
}

class AsanLoginDemoScreen extends StatelessWidget {
  const AsanLoginDemoScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASAN Login Flutter'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: AsanLoginView(
        config: const AsanLoginConfig(
          mobileKeyAndroid: 'com.example.example',
          mobileKeyIos: 'com.example.example',
          environment: AsanLoginEnvironment.preProd,
          clearCookies: true,
        ),
        loadingWidgetBuilder: (double progress) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: LinearProgressIndicator(
              value: progress / 100,
            ),
          );
        },
        onLogin: (String token) {
          log('logged in with token of $token');
        },
      ),
    );
  }
}
