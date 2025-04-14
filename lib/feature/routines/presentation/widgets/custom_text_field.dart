import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? suffixText;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.suffixText,
    this.maxLines,
    this.maxLength,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        hintText: hintText,
        suffixText: suffixText,
        errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
