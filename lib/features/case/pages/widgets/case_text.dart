import 'package:flutter/material.dart';

class CaseText extends StatelessWidget {
  final String text;
  const CaseText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              alignment: Alignment.center,
            ),
          );
  }
}

class CaseSegmentText extends StatelessWidget {
  final String title;
  final String text;
  const CaseSegmentText({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      text: title,
      style: Theme.of(context).textTheme.bodyLarge,
      children: [
        TextSpan(
          text: ": ${text}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]
    ));
  }
}