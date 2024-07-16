import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../themes/pallete.dart';
import '../../../../util/functions.dart';

class TransactionDetails extends ConsumerWidget {
  final QueryDocumentSnapshot queryDocumentSnapshot;
  const TransactionDetails(this.queryDocumentSnapshot, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
     String type  = queryDocumentSnapshot['type'].toString();
     String amount  = queryDocumentSnapshot['amount'].toString();
     String status  = queryDocumentSnapshot['status'].toString();
     final formattedPrice =
     UtilityFunctions.formatCurrency(int.tryParse(amount) as num);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.appbar(context, "Transaction details") ,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Pallete.secondaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
              AutoSizeText(type, style: context.bodySmall?.copyWith(color: Pallete.textColor,),),
               const Gap(10),
              AutoSizeText(formattedPrice, style: context.bodyMedium?.copyWith(fontWeight: FontWeight.bold),),
                  const Gap(10),
                  status == 'successful'? AutoSizeText('successful', style: context.bodySmall?.copyWith(color: Pallete.primaryColor),):AutoSizeText('failed', style: context.bodySmall?.copyWith(color: Pallete.errorColor),)
              ],
              ),
            ),
            const Gap(10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Pallete.secondaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
           Align(
             alignment: Alignment.topLeft,
             child:
           AutoSizeText('Transaction details',
             style: context.bodySmall?.copyWith(color: Pallete.textColor),

           ),
           ),
                  const Gap(20),
                  Table(
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
                                queryDocumentSnapshot['id'].toString(),
                                style: context.bodySmall?.copyWith(color: Pallete.textColor),
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
                                queryDocumentSnapshot['phone'].toString(),
                                style: context.bodySmall?.copyWith(color: Pallete.textColor),
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
                                queryDocumentSnapshot['date'].toString(),
                                style: context.bodySmall?.copyWith(color: Pallete.textColor),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],),
        ),),
    );
  }
}
