import 'package:flutter/material.dart';

import 'colors.dart';

class GSFormTheme {
  static TextTheme textThemeStyle = const TextTheme(
    displayLarge: TextStyle(color: GSFormColors.textColorHeader, fontWeight: FontWeight.w700, fontSize: 16.0),
    displayMedium: TextStyle(color: GSFormColors.textColor, fontWeight: FontWeight.w700, fontSize: 14.0),
    displaySmall: TextStyle(color: GSFormColors.hintTextColor, fontWeight: FontWeight.w500, fontSize: 12.0),
    headlineMedium: TextStyle(color: GSFormColors.hintTextColor, fontWeight: FontWeight.w400, fontSize: 12.0),
    headlineSmall: TextStyle(color: GSFormColors.red, fontWeight: FontWeight.w400, fontSize: 12.0),
    bodyMedium: TextStyle(color: GSFormColors.hintTextColor, fontWeight: FontWeight.w400, fontSize: 14.0),
  );

  static TextTheme textThemeDarkStyle = const TextTheme(
    displayLarge: TextStyle(color: GSFormColors.textDarkColorHeader, fontWeight: FontWeight.w700, fontSize: 16.0),
    displayMedium: TextStyle(color: GSFormColors.textColorDark, fontWeight: FontWeight.w700, fontSize: 14.0),
    displaySmall: TextStyle(color: GSFormColors.hintTextDarkColor, fontWeight: FontWeight.w500, fontSize: 12.0),
    headlineMedium: TextStyle(color: GSFormColors.hintTextDarkColor, fontWeight: FontWeight.w400, fontSize: 12.0),
    headlineSmall: TextStyle(color: GSFormColors.red, fontWeight: FontWeight.w400, fontSize: 12.0),
    bodyMedium: TextStyle(color: GSFormColors.hintTextDarkColor, fontWeight: FontWeight.w400, fontSize: 14.0),
  );
}
