import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../themes/pallete.dart';

class TransactionDetails extends ConsumerWidget {
  final QueryDocumentSnapshot queryDocumentSnapshot;
  const TransactionDetails(this.queryDocumentSnapshot, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
     String type  = queryDocumentSnapshot['type'];
     String amount  = queryDocumentSnapshot['amount'];
     String status  = queryDocumentSnapshot['status'];
    return Scaffold(
      appBar: AppBarWidget.appbar(context, "Transaction details") ,
      body: Column(children: [
        Container(
          color: Pallete.secondaryColor,
          child: Column(
            children: [
          AutoSizeText(type),
          AutoSizeText(amount),
          AutoSizeText(status),
          ],
          ),
        ),
        const Gap(20),
        Container(
          color: Pallete.secondaryColor,
          child: Table(
            border: null,
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: AutoSizeText(
                      'Transaction id',
                      style: context.bodySmall?.copyWith(
                          color: Pallete.secondaryTextColor),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        queryDocumentSnapshot['id'],
                        style: context.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: AutoSizeText(
                      'Phone number',
                      style: context.bodySmall?.copyWith(
                          color: Pallete.secondaryTextColor),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        queryDocumentSnapshot['id'],
                        style: context.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: AutoSizeText(
                      'Date/Time',
                      style: context.bodySmall?.copyWith(
                          color: Pallete.secondaryTextColor),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20),
                      child: AutoSizeText(
                        queryDocumentSnapshot['date'],
                        style: context.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ],),);
  }
}
