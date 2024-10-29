import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000'; // For web
    } else {
      if (!kReleaseMode) {
        return 'http://10.0.2.2:8000'; // For Android emulator
        // return 'http://localhost:8000'; // For iOS simulator
      } else {
        return 'YOUR_PRODUCTION_API_URL'; // For production
      }
    }
  }
}
