import 'dart:async';

import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rxdart/rxdart.dart';

class AsanLoginBloc {
  late final InAppWebViewController webviewController;

  CookieManager get cookieManager => CookieManager.instance();

  bool _onLoginCalled = false;

  final _currentUrlController = BehaviorSubject<String>();
  final _progressController = BehaviorSubject<double>.seeded(1.0);

  Stream<String> get currentUrl$ => _currentUrlController.stream;
  Stream<double> get progress$ => _progressController.stream;

  String get currentUrl => _currentUrlController.value;
  double get progress => _progressController.value;

  void updateCurrentUrl(String value) => _currentUrlController.add(value);
  void updateProgress(double value) => _progressController.add(value);

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
      print('[ASAN LOGIN] current url: $uri');

      // if (url.contains(onLoginUrlContains)) {
      // print('[ASAN LOGIN] success!');
      await checkCookieForUri(uri, onLogin);
      // }
    }
  }

  Future<void> checkCookieForUri(
    Uri uri,
    Function(String) onLogin, {
    bool recursive = true,
  }) async {
    final tokenCookie = await cookieManager.getCookie(url: uri, name: 'token');

    if (tokenCookie == null) {
      print('[ASAN LOGIN] For some reason, cookie with \'token\' could not retrieved');

      if (recursive) {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          checkCookieForUri(uri, onLogin, recursive: false);
        });
      }
    } else {
      print('[ASAN LOGIN] Cookie: $tokenCookie');
      if (!_onLoginCalled) {
        onLogin.call(tokenCookie.value);
        _onLoginCalled = true;
      }
    }
  }

  void close() {
    _currentUrlController.close();
    _progressController.close();
  }
}
