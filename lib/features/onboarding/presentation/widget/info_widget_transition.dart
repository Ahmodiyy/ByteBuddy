import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoWidgetTransition extends ConsumerWidget {
  final String title;
  final TextStyle? titleStyle;
  final String briefExplanation;
  final TextStyle? briefExplanationStyle;
  final double height;
  final double weight;
  final TextAlign textAlign;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const InfoWidgetTransition({
    Key? key,
    required this.title,
    required this.titleStyle,
    required this.briefExplanation,
    required this.briefExplanationStyle,
    this.height = 500,
    this.weight = double.infinity,
    this.textAlign = TextAlign.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      width: weight,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                title,
                overflow: TextOverflow.ellipsis,
                style: titleStyle,
                maxLines: 1,
              )
                  .animate()
                  .slide(
                      curve: Curves.easeIn,
                      duration: 700.ms,
                      begin: const Offset(0.0, 1),
                      end: const Offset(0.0, 0.0))
                  .fadeIn(),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                overflow: TextOverflow.ellipsis,
                textAlign: textAlign,
                briefExplanation,
                style: briefExplanationStyle,
                maxLines: 10,
              )
                  .animate()
                  .slide(
                      curve: Curves.easeIn,
                      duration: 700.ms,
                      delay: 400.ms,
                      begin: const Offset(0.0, 0.5),
                      end: const Offset(0.0, 0.0))
                  .fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}
