
# asan_login_flutter

`ASAN Login` plugin-package for Flutter. The main responsibility of the package, as it is sufficient for mobile-side of the projects, is to extract `token` once the user is successfully logged in. The extracted `token`'s payload contains logged user's basic information. For advanced validation of user, please refer to `ASAN Login`'s documentation provided to you.

<img src="https://raw.githubusercontent.com/kamranbekirovyz/asan-login-flutter/master/doc/assets/cover.png" alt="asan_login_flutter" />

## 🕹️ Usage

```dart
Widget build(BuildContext context) {
  return AsanLoginView(
      config: const AsanLoginConfig(
      mobileKeyAndroid: 'com.example.example',
      mobileKeyIos: 'com.example.example',
      environment: AsanLoginEnvironment.preProd,
      clearCookies: true,
    ),
    loadingWidgetBuilder: (double progress) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: LinearProgressIndicator(
          value: progress / 100,
        ),
      );
    },
    onLogin: (String token) {
      log('logged in with token: $token');
    },
  );
}
```

#### mobileKeyAndroid, mobileKeyIos

The mobile key under which your project is registered on `ASAN Login`. Make sure to use same `String` for your app's both `applicationId` on Android side and `CFBundleIdentifier` on iOS side to avoid any side effects.

#### loadingWidgetBuilder

A builder parameter for customizing loading animation, which is mainly visible until full loading of `ASAN Login` web page.

#### clearCookies

When `clearCookies` is set to `true` user stays as logged in if previously logged. When set to `false` (which is recommended to use as a configuration for most of the use cases of `ASAN Login`) user gets redirected to the login page of `ASAN Login` everytime.

#### environment

Defines environment for `ASAN Login`. For more info about the enivironments and their behaviors check documentation provided to you by `ASAN Login`

#### onLogin

Called when user successfully logs in, with `token` (`String`); 

### Clearing cache

When user's session is terminated on the app (~logout), make sure to call clearAsanLoginCache() global method to make sure user's previous `ASAN Login` cache is cleared from app's cache.


See the <a href="https://github.com/kamranbekirovyz/asan-login-flutter/blob/master/example/lib/main.dart">example</a> directory for a complete sample app.

## 🤓 Contributors

<a  href="https://github.com/kamranbekirovyz/asan-login-flutter/graphs/contributors"> <img  src="https://github.com/kamranbekirovyz.png" height="100">

## 🙏 Credits

Give credits to people/packages/plugins/whomever/whatever was/were an inspiration for this package/plugin.

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on GitHub and we'll look into it. Pull requests are welcome.

## 📃 License

<a href="https://github.com/kamranbekirovyz/asan-login-flutter/blob/master/LICENSE">MIT License</a>