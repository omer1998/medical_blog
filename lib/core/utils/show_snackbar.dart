import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

showSnackBar(BuildContext context, String message, {Color? backgroundColor, SnackBarBehavior? behavior, Duration? duration}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar( behavior: behavior ,content: Text(message), backgroundColor: backgroundColor, duration: duration ?? const Duration(seconds: 3)));
}
