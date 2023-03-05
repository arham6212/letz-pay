import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:letzpay/utils/strings.dart';

@lazySingleton
class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigateTo(String routeName, {Object? argument}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argument);
  }

  Future pushReplacement(String routeName, {Object? argument}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: argument);
  }

  Future clearAllAndNavigatorTo(String routerName, {Object? argument}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routerName, (_) => false);
  }

  pop([Object? result]) {
    return navigatorKey.currentState!.pop(result);
  }

  bool canPop() {
    return navigatorKey.currentState!.canPop();
  }

  showMyDialog(String title, String? description,
      {EdgeInsets padding =
          const EdgeInsets.symmetric(vertical: 24, horizontal: 24)}) {
    return showDialog(
      // barrierColor: Palette.grey.withOpacity(0.3),
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        title: title.text.make(),
        content: description?.text.make(),
        actions: [
          TextButton(onPressed: () => pop(), child: okText.text.make())
        ],
      ),
    );
  }

  showMyDialogWithNavigation(String title, String description, String route) {
    return showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: title.text.make(),
              content: description.text.make(),
              actions: [
                TextButton(
                    onPressed: () {
                      // setToken("");
                      clearAllAndNavigatorTo(route);
                    },
                    child: okText.text.make())
              ],
            ));
  }

  showMyDialogWithNavigationArg(
      String title, String description, String route, Object arguments,
      {isAdditionalFunction = false, Function? additionalFunction}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: title.text.make(),
        content: description.text.make(),
        actions: [
          TextButton(
              onPressed: () {
                if (isAdditionalFunction) {
                  additionalFunction!();
                  pop();
                  navigateTo(route, argument: arguments);
                } else {
                  pop();
                  navigateTo(route, argument: arguments);
                }
              },
              child: okText.text.make())
        ],
      ),
    );
  }
}
