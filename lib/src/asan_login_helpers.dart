import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<void> clearAsanLoginCache() async {
  return CookieManager.instance().deleteAllCookies();
}
