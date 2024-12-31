

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, [List<Widget>? actions,String? title]) {
  // final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    title: title == null ? null : Text(title),
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: actions
  );
}
