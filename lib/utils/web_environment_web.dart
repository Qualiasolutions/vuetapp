import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

@JS('window.flutterWebEnvironment')
external JSObject? get flutterWebEnvironment;

String? getWebEnv(String key) {
  try {
    final webEnv = flutterWebEnvironment;
    if (webEnv != null) {
      final value = webEnv.getProperty(key.toJS);
      if (value != null && value.toString().isNotEmpty &&
          value.toString() != 'null' && value.toString() != 'undefined' &&
          value.toString() != '%$key%') { // Check for placeholder
        if (kDebugMode) {
          debugPrint('✅ Found $key in web environment: ${value.toString().substring(0, (value.toString().length).clamp(0, 20))}...');
        }
        return value.toString();
      }
    } else {
      if (kDebugMode) {
        debugPrint('⚠️ window.flutterWebEnvironment not found');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('⚠️ Error accessing web environment for $key: $e');
    }
  }
  return null;
}
