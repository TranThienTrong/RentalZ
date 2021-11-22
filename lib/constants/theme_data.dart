import 'dart:ui';

import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    if (isDarkTheme) {
      return ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        backgroundColor: Colors.grey.shade700,
        indicatorColor: Color(0xff0E1D36),
        hintColor: Colors.grey.shade300,
        highlightColor: Color(0xff372901),
        hoverColor: Color(0xff3A3A3B),
        focusColor: Color(0xff0B2512),
        disabledColor: Colors.grey,
        cardColor: Color(0xFF151515),
        canvasColor: Colors.black,
        brightness: Brightness.dark,
        fontFamily: 'Nunito',
        buttonTheme: Theme.of(context)
            .buttonTheme
            .copyWith(colorScheme: ColorScheme.light()),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
        colorScheme: ColorScheme.fromSwatch(),
      );
    } else {
      return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.lightBlueAccent,
        backgroundColor: Colors.white,
        indicatorColor: Color(0xffCBDCF8),
        hintColor: Colors.grey.shade800,
        highlightColor: Color(0xffFCE192),
        hoverColor: Color(0xff4285F4),
        focusColor: Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        cardColor: Colors.white,
        canvasColor: Colors.grey[50],
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch(),
        fontFamily: 'Nunito',
        buttonTheme:
            Theme.of(context).buttonTheme.copyWith(buttonColor: Colors.white),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
        ),
      );
    }
  }
}
