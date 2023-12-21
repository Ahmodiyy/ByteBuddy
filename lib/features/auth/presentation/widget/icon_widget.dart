import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData iconData;
  const IconWidget({super.key, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: 15.0,
      color: Pallete.greenColor,
    );
  }
}
