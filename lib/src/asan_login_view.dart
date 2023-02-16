import 'dart:io';

import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef OnLoginSuccess = void Function(String token);

const _preProdUrl = 'https://asanloginpreprod.my.gov.az/auth?mobilekey=';
const _prodUrl = 'https://asanloginmobile.my.gov.az/auth?mobilekey=';
const _color = Color.fromRGBO(38, 89, 182, 1.0);

typedef AsanLoadingWidgetBuilder = Widget Function(double progress);

class AsanLoginView extends StatefulWidget {
  /// Called when user successfully logs in, with [token] (String);
  final OnLoginSuccess onLogin;

  /// Configurations for [AsanLoginView]
  final AsanLoginConfig config;

  /// A builder parameter for customizing loading animation, which is mainly
  /// visible until full loading of `ASAN Login` web page.
  ///
  /// The progress ranges between 0.0 and 100.0
  final AsanLoadingWidgetBuilder? loadingWidgetBuilder;

  const AsanLoginView({
    Key? key,
    required this.onLogin,
    required this.config,
    this.loadingWidgetBuilder,
  }) : super(key: key);

  @override
  _AsanLoginViewState createState() => _AsanLoginViewState();
}

class _AsanLoginViewState extends State<AsanLoginView> {
  late final AsanLoginBloc _bloc;

  String get _url {
    final preProdMode =
        widget.config.environment == AsanLoginEnvironment.preProd;
    final mainUrl = preProdMode ? _preProdUrl : _prodUrl;
    final suffix = Platform.isAndroid
        ? widget.config.mobileKeyAndroid
        : widget.config.mobileKeyIos;

    return '$mainUrl$suffix';
  }

  bool get _preProdMode =>
      widget.config.environment == AsanLoginEnvironment.preProd;

  @override
  void initState() {
    super.initState();

    _bloc = AsanLoginBloc();
    _configure();
  }

  Future<void> _configure() async {
    _bloc.loggingEnabled = _preProdMode;

    /// If the user's already logged in, return `token`.
    if (!widget.config.clearCookies) {
      _bloc.checkCookieForUri(Uri.parse(_url), widget.onLogin);
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: _bloc.progress$,
      initialData: 0.0,
      builder: (_, snapshot) {
        final progress = snapshot.data!;
        final loading = progress < 100;

        return Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                duration: kThemeAnimationDuration,
                opacity: loading ? 1.0 : 0.0,
                child: widget.loadingWidgetBuilder != null
                    ? widget.loadingWidgetBuilder!.call(progress)
                    : CircularProgressIndicator.adaptive(
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(_color),
                      ),
              ),
            ),
            AnimatedOpacity(
              duration: kThemeAnimationDuration,
              opacity: loading ? 0.0 : 1.0,
              child: _buildWebView(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          clearCache: widget.config.clearCookies,
          mediaPlaybackRequiresUserGesture: false,
          supportZoom: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          builtInZoomControls: false,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      initialUrlRequest: URLRequest(url: Uri.parse(_url)),
      onWebViewCreated: _bloc.onWebViewCreated,
      onProgressChanged: (_, int value) {
        _bloc.updateProgress(value.toDouble());
      },
      onLoadStop: (_, Uri? uri) {
        _bloc.handleUrl(uri, widget.onLogin);
      },
    );
  }
}
