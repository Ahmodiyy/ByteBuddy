import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';

class StyleConstant {
  static const input = InputDecoration(
    fillColor: Pallete.greyColor,
    filled: true,
    hintText: 'Enter',
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Pallete.greyColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Pallete.greenColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
  );
}
