
# asan_login_flutter

`ASAN Login` package for Flutter. The main responsibility of the package, as it is sufficient for mobile-side of the projects, is to extract `token` once the user is successfully logged in. The extracted `token`'s payload contains logged user's basic information. For advanced validation of user, please refer to `ASAN Login`'s documentation provided to your institution.

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
      log('logged in with token of $token');
    },
  );
}
```

See the <a href="#">example</a> directory for a complete sample app.

## 📝 Roadmap

What are considered as future enhancements?

## 🤓 Contributors

<a  href="https://github.com/al-ventures/telpo-flutter-sdk/graphs/contributors"> <img  src="https://github.com/kamranbekirovyz.png" height="100">

## 💡 Inspired from/by

Give credits to people/packages/plugins/whomever/whatever was/were an inspiration for this package/plugin.

## 🙏 Credits

Give credits to people/packages/plugins/whomever/whatever was/were an inspiration for this package/plugin.

## 🐞 Bugs/Requests

If you encounter any problems please open an issue. If you feel the library is missing a feature, please raise a ticket on GitHub and we'll look into it. Pull requests are welcome.

## 📃 License

MIT License

<img src="https://raw.githubusercontent.com/kamranbekirovyz/asan-login-flutter/master/doc/assets/cover.png" width="100%" alt="logo" />

<h2 align="center">
ASAN Login for Flutter
</h2>

### packageName

The `packageName` under which your project is registered on `ASAN Login` system. Make sure to use same String for your app's both `applicationId` on Android side and `CFBundleIdentifier` on iOS side to avoid any side effects.

### progressColor

Color which is used to indicate the load progress at the top of the `AsanLoginView`.

### clearCookies

When `clearCookies` is set to `true` user stays as logged in if previously logged. When set to `false` (which is recommended to use as a configuration for most of the use cases of `ASAN Login`) user gets redirected to the login page of `ASAN Login` everytime.

### environment

Defines environment for `ASAN Login`. For more info on `dev` and `prod` environments, please refer to `ASAN Login`'s documentation provided to your institution.

### onLogin

Called when user successfully logs in, with `token` (`String`); 

---

## Clearing cache

When user's session is terminated on the app (~logout), make sure to call clearAsanLoginCache() global method to make sure user's previous `ASAN Login` cache is cleared from app's cache.