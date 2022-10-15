// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, must_be_immutable
import 'package:flutter/material.dart';

class NoteField extends StatelessWidget {
  TextEditingController controller;

  String label;

  int? maxLines;

  ValueChanged<String>? onChanged;

  ValueChanged<String>? onSubmitted;

  String? errorText;

  NoteField(
      {Key? key,
      required this.controller,
      required this.label,
      this.maxLines,
      this.onChanged,
      this.onSubmitted,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        maxLines: maxLines ?? 1,
        controller: controller,
        decoration: InputDecoration(
            errorText: errorText,
            border: OutlineInputBorder(),
            labelText: label,
            alignLabelWithHint: true),
      ),
    );
  }
}

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(context) {
  return MediaQuery.of(context).size.height;
}
