import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderTextWidget extends StatelessWidget {
  final String headerTextString;
  const HeaderTextWidget({
    super.key,
    required this.headerTextString,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      headerTextString,
      style: context.bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold, color: Pallete.textColor),
    );
  }
}
