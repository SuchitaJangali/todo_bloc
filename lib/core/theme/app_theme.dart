import 'package:flutter/material.dart';
import 'package:todo_bloc_new/core/theme/app_color.dart' show AppColor;

class AppTheme {
  static _border([Color color = AppColor.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 0),
        borderRadius: BorderRadius.circular(10),
      );
  static final drakThemeMode = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: AppColor.backgroundColor),
    scaffoldBackgroundColor: AppColor.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      // contentPadding: const EdgeInsets.all(27),
      fillColor: AppColor.greyColor,
      enabledBorder: _border(),
      focusedBorder: _border(AppColor.gradient2),
      errorBorder: _border(AppColor.errorColor),
    ),
  );
}
