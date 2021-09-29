import 'package:asan_login_flutter/src/asan_login_bloc.dart';
import 'package:asan_login_flutter/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AsanLoginView extends StatefulWidget {
  final String packageName;
  final Function(String) whenLogged;

  const AsanLoginView({
    Key? key,
    required this.packageName,
    required this.whenLogged,
  }) : super(key: key);

  @override
  _AsanLoginViewState createState() => _AsanLoginViewState();
}

class _AsanLoginViewState extends State<AsanLoginView> {
  String get _url => '${Constants.asanLoginUrl}${widget.packageName}';

  final _bloc = AsanLoginBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: _url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: _bloc.onWebViewCreated,
      onProgress: _bloc.onProgress,
      navigationDelegate: (NavigationRequest delegate) {
        return _bloc.navigationDelegate(delegate, widget.whenLogged);
      },
      onPageStarted: _bloc.onPageStarted,
      onPageFinished: _bloc.onPageFinished,
      gestureNavigationEnabled: true,
    );
  }
}
