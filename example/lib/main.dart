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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASAN Login Example'),
      ),
      body: AsanLoginView(
        packageName: 'com.example.example',
        config: const AsanLoginConfig(
          environment: AsanLoginEnvironment.dev,
          clearCookies: true,
          progressColor: Colors.indigo,
        ),
        onLogin: (String token) {
          log('logged in with token of $token');
        },
      ),
    );
  }
}
