import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingImageWidget extends ConsumerWidget {
  final String imageUrl;
  const OnboardingImageWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image.asset(imageUrl);
  }
}
