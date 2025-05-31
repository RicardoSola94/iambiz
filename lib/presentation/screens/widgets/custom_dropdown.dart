import 'package:flutter/material.dart';
import 'package:iambiz/config/colors.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    this.onChanged,
    this.errorText,
    this.label,
  });

  final String hint;
  final String? label;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
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
      items:
          items.map((unidad) {
            return DropdownMenuItem<String>(value: unidad, child: Text(unidad));
          }).toList(),
    );
  }
}
