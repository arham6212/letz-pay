import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:letzpay/common_components/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:letzpay/utils/strings.dart';

class CommonErrorHandler {
  errorHandlerDialog(
      String errorTitle, errorDescription, BuildContext buildContext) {
    return showDialog(
        context: buildContext,
        barrierDismissible: false,
        builder: (buildContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              title: errorTitle.text.make(),
              content: errorDescription?.text.make(),
              actions: [
                TextButton(
                    onPressed: () => "",
                    // locator<NavigationService>().pop(),
                    child: okText.text.make())
              ],
            ));
  }

  static dynamic getDioErrorMessage(DioError e, path) {
    var errorMsg;
    printLog("onErrorHandler", 'ERROR[${e.message}]', "e");
    if (e.message.contains("500")) {
      // printLog(path, e.response!.data["error"], "e");
      errorMsg = e.response!.data["error"];
    } else if (e.message.contains("Network is unreachable")) {
      errorMsg = errorNoInternet;
    } else if (e.message.contains("Software caused connection abort")) {
      errorMsg = errorSomeWrong;
    } else if (e.message.contains("SocketException")) {
      errorMsg = errorSocketException;
    } else {
      // printLog(path, e.message.toString(), "e");
      errorMsg = e.message;
    }
    return errorMsg;
  }
}
