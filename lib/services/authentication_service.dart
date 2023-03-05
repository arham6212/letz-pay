import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:letzpay/services/shared_pref.dart';
import 'package:letzpay/utils/strings.dart';

class AuthenticationService {
  final _userController = ReplaySubject<String>(maxSize: 1);
  AuthenticationService() {
    _userController.add("");
    // Future.delayed(Duration(microseconds: 0))
    //     .then((value) => _userController.add(""));
  }

  void login() {
    _userController.sink.add('User');
  }

  void logout() {
    // removeVal(loginSharedPrefKey);
    // removeVal(userNameSharedPrefKey);
    // removeVal(moduleTypeSharedPrefKey);

    _userController.sink.add("");
    // _userController.sink.close();
  }

  Stream<String> user() {
    return _userController.asBroadcastStream();
  }

  dispose() {
    _userController.sink.close();
  }
}

class AuthenticationProvider extends InheritedWidget {
  final service = AuthenticationService();
  AuthenticationProvider({Key? key, child}) : super(key: key, child: child);

  static AuthenticationService of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>()
            as AuthenticationProvider)
        .service;
  }

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) {
    return true;
  }
}
