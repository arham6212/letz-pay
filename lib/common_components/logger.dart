import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    AnsiColor? color = PrettyPrinter.levelColors[event.level];
    String? emoji = PrettyPrinter.levelEmojis[event.level];
    return [color!('$emoji [$className]: ${event.message}')];
  }
}

printLog(
  String className,
  String message,
  String logType,
) {
  // final log = Logger(printer: SimpleLogPrinter(className));

  // print(message);
  final log = Logger(
      printer: PrettyPrinter(
          // methodCount: 0,
          // errorMethodCount: 3,
          lineLength: 50,
          colors: true,
          printEmojis: true,
          printTime: false));
  if (kDebugMode) {
    switch (logType) {
      case "v":
        return log.v("[$className]: ${message}");
      case "d":
        return log.d("[$className]: ${message}");
      case "i":
        return log.i("[$className]: ${message}");
      case "w":
        return log.w("[$className]: ${message}");
      case "e":
        return log.e("[$className]: ${message}");
    }
  }
}
