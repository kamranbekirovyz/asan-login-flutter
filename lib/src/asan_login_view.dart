import 'package:asan_login_flutter/asan_login_flutter.dart';
import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef OnLoginSuccess = void Function(String token);

const asanLoginProdUrl = 'https://asanloginmobile.my.gov.az/auth?mobilekey=';
const asanLoginTestUrl = 'https://asanloginmobiletest.my.gov.az/auth?mobilekey=';

/// Webframe implementation for ASAN Login as a Flutter widget.
class AsanLoginView extends StatefulWidget {
  /// The `packageName` under which your project is registered on ASAN Login
  final String packageName;

  /// Called when user successfully logs in, with [token] (String);
  final OnLoginSuccess onLogin;

  /// Configurations for [AsanLoginView]
  final AsanLoginConfig config;

  const AsanLoginView({
    Key? key,
    required this.packageName,
    required this.onLogin,
    this.config = const AsanLoginConfig(),
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

    if (widget.config.clearCookies) {
      await _bloc.cookieManager.deleteAllCookies();
    } else {
      /// Check whether user's already logged in, if yes, return
      /// `token` string.
      _bloc.checkCookieForUri(
        Uri.parse(_url),
        widget.onLogin,
      );
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildWebView(),
        _buildProgress(),
      ],
    );
  }

  Widget _buildWebView() {
    return InAppWebView(
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

  Widget _buildProgress() {
    final progressColor = widget.config.progressColor;

    return StreamBuilder<double>(
      initialData: 100,
      stream: _bloc.progress$,
      builder: (_, snapshot) {
        if (snapshot.data! < 100) {
          return LinearProgressIndicator(
            value: snapshot.data! / 100,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            backgroundColor: progressColor.withOpacity(.25),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
