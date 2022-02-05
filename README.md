<img src="https://raw.githubusercontent.com/porelarte/asan-login-flutter/master/doc/assets/cover.png" width="100%" alt="logo" />

<h2 align="center">
ASAN Login for Flutter
</h2>

---

## Overview

A basic, production-ready implementation for `ASAN Login`. The main responsibility of the package, as it is sufficient for mobile-side of the projects, is to extract `token` once the user is successfully logged in. The extracted `token`'s payload contains logged user's basic information. For advanced validation of user, please refer to `ASAN Login`'s documentation provided to your institution.

---

## Usage

``dart
Widget build(BuildContext context) {
    return AsanLoginView(
      packageName: 'com.example.app',
      configurations: AsanLoginConfig(
        progressColor: Colors.indigo,
        clearCookies: true,
        isDevMode: false,
      ),
      onLogin: (String token) {
        // TODO: process token
      },
    );
  }
``