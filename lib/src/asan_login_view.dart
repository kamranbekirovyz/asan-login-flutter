import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:asan_login_flutter/src/asan_login_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef OnLoginSuccess = void Function(String token);

const asanLoginProdUrl = 'https://asanloginmobile.my.gov.az/auth?mobilekey=';
const asanLoginTestUrl = 'https://asanloginmobiletest.my.gov.az/auth?mobilekey=';

class AsanLoginView extends StatefulWidget {
  final String packageName;
  final OnLoginSuccess onLogin;
  final AsanLoginConfig configurations;

  const AsanLoginView({
    Key? key,
    required this.packageName,
    required this.onLogin,
    this.configurations = const AsanLoginConfig(),
  }) : super(key: key);

  @override
  _AsanLoginViewState createState() => _AsanLoginViewState();
}

class _AsanLoginViewState extends State<AsanLoginView> {
  String get _url {
    final isDevMode = widget.configurations.isDevMode;
    final mainUrl = isDevMode ? asanLoginTestUrl : asanLoginProdUrl;
    final suffix = widget.packageName;

    return '$mainUrl$suffix';
  }

  final _bloc = AsanLoginBloc();

  @override
  void initState() {
    super.initState();
    _configure();
  }

  Future<void> _configure() async {
    _bloc.loggingEnabled = widget.configurations.isDevMode;

    if (widget.configurations.clearCookies) {
      await _bloc.cookieManager.deleteAllCookies();
    } else {
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
    final progressColor = widget.configurations.progressColor;

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
