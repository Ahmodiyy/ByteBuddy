import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionStatus extends ConsumerWidget {
  final Map<String, dynamic> transactionStatusData;
  const TransactionStatus(this.transactionStatusData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String status = transactionStatusData['status'];
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(30),
              SizedBox(
                  height: 100,
                  child: status == 'successful'
                      ? const RiveAnimation.asset(
                          RiveConstant.success,
                        )
                      : const RiveAnimation.asset(RiveConstant.error)),
              const Gap(10),
              AutoSizeText(
                transactionStatusData['status'].toString().toLowerCase(),
                textAlign: TextAlign.center,
                style: context.bodyMedium?.copyWith(
                    color: Pallete.blackColor, fontWeight: FontWeight.w300),
              ),
              const Gap(5),
              AutoSizeText(
                transactionStatusData['description'].toString().toLowerCase(),
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(color: Pallete.lightBlack),
              ),
              const Gap(100),
              AutoSizeText(
                'Bytebuddy',
                textAlign: TextAlign.center,
                style: context.bodySmall?.copyWith(
                    color: Pallete.greenColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
