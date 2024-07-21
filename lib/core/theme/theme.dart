import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';

class AppTheme {
  static border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 3),
      borderRadius: BorderRadius.circular(10));
  static final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    buttonTheme: ButtonThemeData(
      buttonColor: AppPallete.gradient2
    ),
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      appBarTheme: AppBarTheme(backgroundColor: AppPallete.backgroundColor),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: border(AppPallete.gradient2),
          enabledBorder: border(),
          focusedErrorBorder: border(),
          errorBorder: border()));
}
