import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
        body: Container(
          padding: const EdgeInsets.all(20),
          child: status == 'successful'
              ? Column(
                  children: [
                    const RiveAnimation.asset(RiveConstant.success),
                    AutoSizeText(transactionStatusData['status']),
                  ],
                )
              : Column(
                  children: [
                    const RiveAnimation.asset(RiveConstant.error),
                    AutoSizeText(transactionStatusData['status']),
                  ],
                ),
        ),
      ),
    );
  }
}
