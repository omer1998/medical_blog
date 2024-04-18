// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const AuthField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText, contentPadding: EdgeInsets.all(20)),
    );
  }
}
