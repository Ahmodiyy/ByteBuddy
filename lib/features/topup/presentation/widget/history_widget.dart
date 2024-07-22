import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/constants/svg_constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../util/functions.dart';

class HistoryWidget extends ConsumerWidget {
  final QueryDocumentSnapshot queryDocumentSnapshot;
  const HistoryWidget(this.queryDocumentSnapshot, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool transactionStatus = queryDocumentSnapshot['status'].toString() == 'successful';
    final formattedPrice = UtilityFunctions.formatCurrency(queryDocumentSnapshot['amount']);
    return InkWell(
      onTap: () => context.go('/dashboard/transaction_history/details', extra: queryDocumentSnapshot),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            CircleAvatar(
                radius: 20,
                foregroundColor: Pallete.backgroundColor,
                backgroundColor: Pallete.backgroundColor,
                child: SvgPicture.asset(
                    queryDocumentSnapshot['type'] == 'Data' ? SvgConstant.data : SvgConstant.deposit,
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
                      queryDocumentSnapshot['type'],
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
                      queryDocumentSnapshot['date'],
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
                      formattedPrice,
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
      ),
    );
  }
}
