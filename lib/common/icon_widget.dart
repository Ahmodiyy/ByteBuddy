import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;
  const IconWidget({
    super.key,
    required this.iconData,
    this.color = Pallete.primaryColor,
    this.size = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: size,
      color: color,
    );
  }
}
