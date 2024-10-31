import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://52.76.183.19:8001'; // For web
    } else {
      if (!kReleaseMode) {
        return 'http://52.76.183.19:8001'; // For Android emulator
        // return 'http://localhost:8000'; // For iOS simulator
      } else {
        return 'http://52.76.183.19:8001'; // For production
      }
    }
  }
}
