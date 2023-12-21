import 'package:flutter/material.dart';

void showErrorMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.red),
      ),
    ),
  );
}

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter email';
  }
  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter password';
  }

  return null;
}

String? validate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Provide input value';
  }
  return null;
}

DropdownMenuItem<String> listMenuItem(String value) {
  return DropdownMenuItem(
    value: value,
    child: Text(value),
  );
}
