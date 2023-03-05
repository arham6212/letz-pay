import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum NetworkStatus { online, offline }

class NetworkService {
  StreamController<NetworkStatus> controller = StreamController();

  NetworkService() {
    Connectivity().onConnectivityChanged.listen((event) {
      controller.add(_networkStatus(event));
    });
  }

  NetworkStatus _networkStatus(ConnectivityResult connectivityResult) {
    return connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName, {Object? argument}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argument);
  }

  Future pushReplacement(String routeName, {Object? argument}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argument);
  }

  Future clearAllAndNavigatorTo(String routerName, {Object? argument}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routerName, (_) => false, arguments: argument);
  }

  pop([Object? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  bool canPop() {
    return navigatorKey.currentState!.canPop();
  }
}
