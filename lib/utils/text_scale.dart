import 'package:flutter/material.dart';

/// Provides responsive text scaling based on screen size.
/// All font sizes should use these helpers to maintain proportional scaling.
class TextScale {
  /// Reference width for scaling (typical phone width)
  static const double _refWidth = 375.0;
  
  /// Reference height for scaling
  static const double _refHeight = 812.0;
  
  /// Get scale factor based on shortest side of screen.
  /// Returns a value typically between 0.75 and 1.35.
  static double scaleFactor(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.width < size.height ? size.width : size.height;
    return (shortestSide / _refWidth).clamp(0.75, 1.35);
  }
  
  /// Get scale factor based on screen width.
  static double widthScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / _refWidth).clamp(0.75, 1.35);
  }
  
  /// Get scale factor based on screen height.
  static double heightScale(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (height / _refHeight).clamp(0.75, 1.35);
  }
  
  /// Scaled font size - use for all text to keep proportions.
  static double fontSize(BuildContext context, double baseSize) {
    return baseSize * scaleFactor(context);
  }
  
  /// Scaled letter spacing.
  static double letterSpacing(BuildContext context, double baseSpacing) {
    return baseSpacing * scaleFactor(context);
  }
}
