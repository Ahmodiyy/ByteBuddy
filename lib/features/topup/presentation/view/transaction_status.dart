import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionStatus extends ConsumerWidget {
  final Map<String, dynamic> transactionStatusData;
  const TransactionStatus(this.transactionStatusData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: AutoSizeText(transactionStatusData['status']),
        ),
      ),
    );
  }
}
