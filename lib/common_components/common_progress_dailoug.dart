import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letzpay/utils/assets_path.dart';
import 'package:letzpay/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/strings.dart';

class CommonProgressDialog {
  CommonProgressDialog(this.context);

  final BuildContext context;

  void showLoadingIndicator(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false, child: Image.asset(loaderimage)
            // AlertDialog(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //   backgroundColor: Colors.black87,
            //   content: LoadingIndicator(text: text),
            // )
            );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.pop(context);
  }
}

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context) {
    var displayedText = text;

    return Container(
        padding: EdgeInsets.all(16),
        color: Colors.black87,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(),
              _getHeading(context),
              _getText(displayedText)
            ]));
  }

  Padding _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: CircularProgressIndicator(strokeWidth: 3),
            width: 32,
            height: 32),
        padding: EdgeInsets.only(bottom: 16));
  }

  Widget _getHeading(context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: pleaseWait.text.color(white).size(16.0.sp).center.make());
  }

  Widget _getText(String displayedText) {
    return displayedText.text.color(white).size(14.0.sp).center.make();
  }
}
