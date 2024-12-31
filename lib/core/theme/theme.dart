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
    // textButtonTheme: TextButtonThemeData(
    //         style: TextButton.styleFrom(
    //       textStyle: const TextStyle(
    //           color: Colors.deepOrange,
    //           fontSize: 30,
    //           fontWeight: FontWeight.bold),
    //     )),
         elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: const Color.fromARGB(255, 68, 17, 77), // background color
                textStyle: const TextStyle(
                    fontSize: 16,  color: Colors.white))),
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      appBarTheme: AppBarTheme(backgroundColor: AppPallete.backgroundColor),
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: border(AppPallete.gradient2),
          enabledBorder: border(),
          focusedErrorBorder: border(),
          errorBorder: border()));
}
