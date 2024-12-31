import 'package:flutter/material.dart';

class CaseEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool require;
  final int? minLine;
  final bool? requestFocus;
  const CaseEditor(
      {super.key, required this.controller, required this.hintText, this.require = true,this.requestFocus, this.minLine=null});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hintText,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20),
              ),
            ),
          ),
          TextFormField(
            focusNode: FocusNode(),
            controller: controller,
            decoration: InputDecoration(hintText: hintText),
            maxLines: null,
            minLines: minLine,
            validator: (value) {
              if (require){
                if (value!.isEmpty) {
                return "${hintText} field is required";
              } else {
                return null;
              }
              }else {
                return null;
              }
              
            },
          ),
        ],
      ),
    );
  }
}
