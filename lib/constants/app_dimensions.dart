import 'package:flutter/material.dart';

class AppDimensions {
  static double width = 0;
  static double height = 0;

  AppDimensions(context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  static double convertToH(double value) {
    return (value / 812) * height;
  }

  static double convertToW(double value) {
    return (value / 375) * width;
  }

  static double? getFullHeight() {
    return height;
  }

  static double? getFullWidth() {
    return width;
  }
}
