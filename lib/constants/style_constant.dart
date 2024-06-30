import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';

class StyleConstant {
  static const input = InputDecoration(
    fillColor: Pallete.secondaryColor,
    filled: true,
    hintText: 'Enter',
    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Pallete.errorColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Pallete.errorColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Pallete.primaryColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
  );
}
