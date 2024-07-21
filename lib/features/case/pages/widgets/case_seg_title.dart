// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CaseSegmentTitle extends StatelessWidget {
  final String title;
  const CaseSegmentTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500
    ),);
  }
}
