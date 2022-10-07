import 'dart:async';

import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Business Logic for [AsanLoginView]
class AsanLoginBloc {
  AsanLoginBloc() {
    _progress.add(100.0);
  }

  late final InAppWebViewController webviewController;

  CookieManager get cookieManager => CookieManager.instance();

  bool _onLoginCalled = false;
  bool loggingEnabled = false;

  final _currentUrl = StreamController<String>.broadcast();
  final _progress = StreamController<double>();

  Stream<String> get currentUrl$ => _currentUrl.stream;
  Stream<double> get progress$ => _progress.stream;

  void updateCurrentUrl(String value) => _currentUrl.add(value);
  void updateProgress(double value) => _progress.add(value);

  void onProgress(int progress) {
    updateProgress(progress.toDouble());
  }

  void onWebViewCreated(InAppWebViewController controller) async {
    webviewController = controller;
  }

  Future<void> handleUrl(Uri? uri, Function(String) onLogin) async {
    if (uri != null) {
      final url = uri.toString();
      updateCurrentUrl(url);

      _print('[ASAN LOGIN] current url: $uri');

      Future.delayed(const Duration(milliseconds: 500), () {
        checkCookieForUri(uri, onLogin);
      });
    }
  }

  Future<void> checkCookieForUri(
    Uri uri,
    OnLoginSuccess onLogin,
  ) async {
    _print('[ASAN LOGIN] Checking cookie for uri: $uri');

    final tokenCookie = await cookieManager.getCookie(
      url: uri,
      name: 'token',
    );

    if (tokenCookie == null) {
      _print('[ASAN LOGIN] No stored token found for uri: $uri');
    } else {
      _print('[ASAN LOGIN] Cookie: $tokenCookie');

      if (!_onLoginCalled) {
        onLogin.call(tokenCookie.value);
        _onLoginCalled = true;
      }
    }
  }

  void _print(String s) {
    if (loggingEnabled) {
      print(s);
    }
  }

  void close() {
    _currentUrl.close();
    _progress.close();
  }
}
