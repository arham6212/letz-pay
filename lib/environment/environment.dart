import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName =>
      kReleaseMode ? "assets/.env.production" : "assets/.env.development";
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'MY_FALLBACK';
}
