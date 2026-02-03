import 'dart:io';
import 'package:flutter/services.dart';

class BatteryOptimization {
  static const _channel = MethodChannel('com.church668.radio/battery');
  
  /// Check if battery optimization is disabled for this app
  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final result = await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Request to disable battery optimization (opens system settings)
  static Future<void> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return;
    
    try {
      await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
    } catch (e) {
      // Ignore errors
    }
  }
}
