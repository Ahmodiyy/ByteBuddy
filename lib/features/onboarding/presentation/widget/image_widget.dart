import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageWidget extends ConsumerWidget {
  final String imageUrl;
  final double width;
  final double height;
  const ImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 500,
    this.height = 500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
