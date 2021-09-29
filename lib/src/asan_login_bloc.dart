import 'dart:async';

import 'package:asan_login_flutter/src/constants.dart';
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
    debugPrint("WebView is loading, progress: $progress%");
  }

  void onPageStarted(String url) {
    updateCurrentUrl(url);
    debugPrint('Page started loading: $url');
  }

  void onPageFinished(String url) {
    debugPrint('Page finished loading: $url');
  }

  void onWebViewCreated(WebViewController _controller) {
    controller.complete(_controller);
  }

  Future<NavigationDecision> navigationDelegate(
    NavigationRequest request,
    Function(String) whenLogged,
  ) async {
    final requestedUrl = request.url;
    if (requestedUrl == Constants.successRedirectUrl) {
      final cookies = (await controller.future).evaluateJavascript('document.cookie');
      print('cookies: $cookies');

      return NavigationDecision.prevent;
    }

    debugPrint('allowing navigation to $request, with url of: ${request.url}');
    return NavigationDecision.navigate;
  }

  void close() {
    _currentUrlController.close();
    _progressController.close();
  }
}
