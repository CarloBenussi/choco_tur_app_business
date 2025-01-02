import 'package:flutter/material.dart';

class UserTextInput extends StatelessWidget {
  const UserTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onTap,
    this.obscured = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscured;
  final String? Function(String?)? validator;
  final Function(BuildContext context)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
      child: TextFormField(
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        maxLines: 1,
        obscureText: obscured,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
        onTap: () => {if (onTap != null) onTap!(context)},
      ),
    );
  }
}
