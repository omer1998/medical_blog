import 'package:flutter/material.dart';

class CaseSection extends StatelessWidget {
  final String title;
  const CaseSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [],
    );
  }
}
