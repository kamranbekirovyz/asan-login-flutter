import 'dart:async';

import 'package:asan_login_flutter/src/constants.dart';
import 'package:asan_login_flutter/src/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AsanLoginBloc {
  final controller = Completer<WebViewController>();

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

  void onWebViewCreated(WebViewController _controller) {
    controller.complete(_controller);
  }

  Future<NavigationDecision> navigationDelegate(
    NavigationRequest request,
    Function(String) onLogin,
  ) async {
    try {
      final requestedUrl = request.url;
      updateCurrentUrl(requestedUrl);

      final cookies = await ((await controller.future).evaluateJavascript('document.cookie'));

      final containsToken = cookies.contains('token=');
      if (containsToken) {
        final token = cookies.allBetween('token=', ';');
        onLogin.call(token);
      }
    } catch (e) {
      print(e.toString());
    }

    return NavigationDecision.navigate;
  }

  void close() {
    _currentUrlController.close();
    _progressController.close();
  }
}
