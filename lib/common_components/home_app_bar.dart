import 'package:flutter/material.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

AppBar buildHomeAppBar({
  Widget? title,
  List<Widget>? actions,
  Widget? leading,
}) {
  return AppBar(
    backgroundColor: Vx.hexToColor(whiteMainColor),
    leading: leading,
    elevation: 0,
    title: title,
    centerTitle: true,
    actions: actions,
  );
}

AppBar backButtonIos({
  Widget? title,
  List<Widget>? actions,
  Widget? leading,
  Color? backgroundColor,
  required bool automaticallyImplyLeading,
}) {
  return AppBar(
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: automaticallyImplyLeading,
    // leading: leading,
    elevation: 0,
    title: title,
    centerTitle: false,
    actions: actions,
  );
}
