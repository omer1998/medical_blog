// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:medical_blog_app/core/theme/app_pallete.dart';

class AuthBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnText;
  const AuthBtn({
    Key? key,
    required this.onPressed,
    required this.btnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        gradient: const LinearGradient(
            colors: [AppPallete.gradient1, AppPallete.gradient2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          btnText,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
      ),
    );
  }
}
