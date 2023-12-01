import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingInfoWidget extends ConsumerWidget {
  final String title;
  final String briefExplanation;

  const OnboardingInfoWidget({
    Key? key,
    required this.title,
    required this.briefExplanation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: AutoSizeText(
              title,
              overflow: TextOverflow.ellipsis,
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ),
        Flexible(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                briefExplanation,
                style: context.bodySmall,
                maxLines: 3,
              )),
        ),
      ],
    );
  }
}
