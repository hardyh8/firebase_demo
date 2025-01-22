import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

class InputField1 extends StatelessWidget {
  const InputField1({
    super.key,
    required this.inputController,
    required this.label,
    required this.inputType,
  });
  final TextEditingController inputController;
  final String label;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.grey1;
    const secondaryColor = AppColors.primary;
    const accentColor = Color(0xffffffff);
    const errorColor = Color(0xffEF4444);

    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $label';
        }
        return null;
      },
      controller: inputController,
      keyboardType: inputType,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      decoration: InputDecoration(
        label: Text(label),
        labelStyle: const TextStyle(color: primaryColor),
        filled: true,
        fillColor: accentColor,
        hintStyle: TextStyle(color: Colors.grey.withAlpha(192)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: errorColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
