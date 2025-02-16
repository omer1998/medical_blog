import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final Widget? suffixIcon;
  final String label;
  final String text;
  final bool? obscureText;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.suffixIcon,
    this.maxLines = 1,
    this.obscureText = false,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: widget.obscureText!,
            
            onChanged:(value)=> widget.onChanged(value),
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}
