// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:medical_blog_app/core/theme/app_pallete.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Widget? prefixIcon;
  const AuthField(
      {super.key,
      this.validator,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
      this.maxLines= 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        labelText: hintText,
        hintStyle: TextStyle(color: AppPallete.whiteColor.withOpacity(0.5)),
        border: OutlineInputBorder(

        ),
        
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
