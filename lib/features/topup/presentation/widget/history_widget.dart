import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/constants/svg_constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class HistoryWidget extends ConsumerWidget {
  final String type;
  final String date;
  final String status;
  final dynamic amount;
  const HistoryWidget(
      {super.key,
      required this.type,
      required this.date,
      required this.status,
      required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool transactionStatus = status.toString() == 'successful';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(right: 30),
      child: Row(
        children: [
          CircleAvatar(
              radius: 20,
              foregroundColor: Pallete.backgroundColor,
              backgroundColor: Pallete.backgroundColor,
              child: SvgPicture.asset(
                  type == 'Data' ? SvgConstant.data : SvgConstant.deposit,
                  width: 25,
                  height: 25)),
          const Gap(10),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: context.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
                const Gap(5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: context.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const Gap(15),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    '\u20A6${amount.toString()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: context.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
                const Gap(5),
                Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    transactionStatus ? "successful" : 'failed',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: context.bodySmall?.copyWith(
                        color: transactionStatus
                            ? Pallete.primaryColor
                            : Pallete.errorColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
