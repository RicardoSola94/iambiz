import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/config.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    this.label,
    required this.controller,
    this.obscureText = false,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
  });

  final String hint;
  final String? label;
  final TextEditingController controller;
  final bool obscureText;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        fillColor: AppColors.lightprimaryColor,
        filled: true,
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
