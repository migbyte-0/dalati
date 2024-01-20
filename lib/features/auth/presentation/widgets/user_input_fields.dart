import 'package:flutter/material.dart';

//ويدجت حقل إدخال المستخدم
class UserInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType keyboardType;

  final Function(String)? onChanged;

  const UserInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          color: Colors.white,
        ),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(prefixIcon, color: Colors.teal),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
      maxLength: maxLength,
      onChanged: onChanged,
    );
  }
}
