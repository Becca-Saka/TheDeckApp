import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySize {
  static late MediaQueryData mediaQuery;
  static late double height;
  static late double width;
  static late bool isSmall;
  static late bool isMedium;
  static late bool isLarge;
  static late double textScaleFactor;

  static void init(context) {
    mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height;
    width = mediaQuery.size.width;
    isSmall = height < 600 && width < 400;
    isMedium = height >= 600 && height < 900;
    isLarge = width >= 600;
    textScaleFactor = mediaQuery.textScaleFactor;
  }

  static double scaledSize(bool isSmall, bool isMedium, double size) {
    return isSmall ? size : (isMedium ? size * 1.1 : size * 1.5);
  }

  static double yMargin(double height) {
    double screenHeight = mediaQuery.size.height / 100;
    return height * screenHeight;
  }

  static double xMargin(
    double width,
  ) {
    double screenWidth = mediaQuery.size.width / 100;
    return width * screenWidth;
  }

  static double textSize(double textSize) {
    double screenWidth = mediaQuery.size.width / 100;
    double screenHeight = mediaQuery.size.height / 100;
    if (screenWidth > screenHeight) return textSize * screenHeight;
    return textSize * screenWidth;
  }
}
