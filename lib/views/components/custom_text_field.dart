import 'package:flutter/material.dart';

Widget customTextFormField({
  bool obscureText = false,
  FocusNode? focusNode,
  required TextEditingController controller,
  required String labelText,
  dynamic validator,
  Function(String)? onChanged,
}) {
  return TextFormField(
    style: const TextStyle(color: Colors.black, fontFamily: 'Circular'),
    obscureText: obscureText,
    focusNode: focusNode,
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      suffixIcon: obscureText
          ? IconButton(
              onPressed: () {
                obscureText = !obscureText;
              },
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
            )
          : null,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(50.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(50.0),
      ),
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    ),
    validator: validator,
  );
}
