import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:asan_login_flutter/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AsanLoginView extends StatefulWidget {
  final String packageName;
  final Function(String) onLogin;
  final bool isDevMode;
  final bool clearCookies;
  final Color progressColor;

  const AsanLoginView({
    Key? key,
    required this.packageName,
    required this.onLogin,
    this.isDevMode = false,
    this.clearCookies = true,
    this.progressColor = Colors.indigo,
  }) : super(key: key);

  @override
  _AsanLoginViewState createState() => _AsanLoginViewState();
}

class _AsanLoginViewState extends State<AsanLoginView> {
  String get _url {
    final isDevMode = widget.isDevMode;
    final mainUrl = isDevMode ? Constants.asanLoginTestUrl : Constants.asanLoginProdUrl;
    final suffix = widget.packageName;

    return '$mainUrl$suffix';
  }

  final _bloc = AsanLoginBloc();

  @override
  void initState() {
    super.initState();
    // bir dfe login olubsa /dashboarda yox bura atacaq
    _bloc.checkCookieForUri(Uri.parse(_url), widget.onLogin);
    if (widget.clearCookies) {
      _bloc.cookieManager.deleteAllCookies();
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
    return StreamBuilder<double>(
      initialData: 100,
      stream: _bloc.progress$,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data! < 100) {
          return LinearProgressIndicator(
            value: snapshot.data! / 100,
            valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
            backgroundColor: widget.progressColor.withOpacity(.25),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
