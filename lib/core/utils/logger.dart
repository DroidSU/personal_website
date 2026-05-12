import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message) {
    if (kDebugMode) {
      dev.log('DEBUG: $message', name: 'APP');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    dev.log('ERROR: $message', name: 'APP', error: error, stackTrace: stackTrace);
  }
}
