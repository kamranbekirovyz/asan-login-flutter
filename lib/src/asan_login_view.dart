import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef OnLoginSuccess = void Function(String token);

const asanLoginProdUrl = 'https://asanloginmobile.my.gov.az/auth?mobilekey=';
const asanLoginTestUrl = 'https://asanloginmobiletest.my.gov.az/auth?mobilekey=';
const asanLoginColor = Color.fromRGBO(38, 89, 182, 1.0);

typedef AsanLoadingWidgetBuilder = Widget Function(double progress);

/// Webframe implementation for ASAN Login as a Flutter widget.
class AsanLoginView extends StatefulWidget {
  /// The [packageName] under which your project is registered on ASAN Login
  final String packageName;

  /// Called when user successfully logs in, with [token] (String);
  final OnLoginSuccess onLogin;

  /// Configurations for [AsanLoginView]
  final AsanLoginConfig config;

  /// A builder parameter for customizing loading animation, which is mainly
  /// visible until full loading of `ASAN Login` web page.
  ///
  /// The progress ([double]) ranges between 0.0 and 100.0
  final AsanLoadingWidgetBuilder? loadingWidgetBuilder;

  const AsanLoginView({
    Key? key,
    required this.packageName,
    required this.onLogin,
    this.config = const AsanLoginConfig(),
    this.loadingWidgetBuilder,
  }) : super(key: key);

  @override
  _AsanLoginViewState createState() => _AsanLoginViewState();
}

class _AsanLoginViewState extends State<AsanLoginView> {
  String get _url {
    final devMode = widget.config.environment == AsanLoginEnvironment.dev;
    final mainUrl = devMode ? asanLoginTestUrl : asanLoginProdUrl;
    final suffix = widget.packageName;

    return '$mainUrl$suffix';
  }

  bool get _devMode => widget.config.environment == AsanLoginEnvironment.dev;

  final _bloc = AsanLoginBloc();

  @override
  void initState() {
    super.initState();
    _configure();
  }

  Future<void> _configure() async {
    _bloc.loggingEnabled = _devMode;

    /// If the user's already logged in, return [token] string.
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
      initialData: 100.0,
      builder: (_, snapshot) {
        final progress = snapshot.data!;
        final loading = progress < 100;

        return Stack(
          children: [
            AnimatedOpacity(
              duration: kThemeAnimationDuration,
              opacity: loading ? 1.0 : 0.0,
              child: widget.loadingWidgetBuilder != null
                  ? widget.loadingWidgetBuilder!.call(progress)
                  : CircularProgressIndicator.adaptive(
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(asanLoginColor),
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
