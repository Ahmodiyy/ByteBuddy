import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/constants/svg_constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget {
  static PreferredSizeWidget appbar(BuildContext context, String screenText,
      {Color backgroundColor = Pallete.secondaryColor}) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 100),
      child: Container(
        color: backgroundColor,
        child: Row(
          children: [
            InkWell(
              onTap: () => context.pop(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset(
                  SvgConstant.back,
                  width: 18,
                ),
              ),
            ),
            //const Gap(20),
            AutoSizeText(
              screenText,
              maxLines: 1,
              style: context.bodySmall?.copyWith(color: Pallete.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
