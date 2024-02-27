import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);
    return Scaffold(
        appBar: AppBarWidget.appbar(context, "History",
            backgroundColor: Pallete.backgroundColor),
        body: state.when(
          data: (data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final history = data[index];
                if (history["type"] == 'Add money') {
                  return DepositHistoryWidget(
                    date: history['date'],
                    status: history['status'],
                    amount: history['amount'],
                  );
                } else if (history["type"] == 'Data') {
                  return DataHistoryWidget(
                    date: history['date'],
                    status: history['status'],
                    amount: history['amount'],
                  );
                }
              },
            );
          },
          error: (error, stackTrace) {
            return Center(
                child: AutoSizeText(
              error.toString(),
              textAlign: TextAlign.center,
            ));
          },
          loading: () {
            return const Center(
                child: CircularProgressIndicator(
              color: Pallete.primaryColor,
            ));
          },
        ));
  }
}

class DepositHistoryWidget extends ConsumerWidget {
  final String date;
  final String status;
  final double amount;
  const DepositHistoryWidget(
      {super.key,
      required this.date,
      required this.status,
      required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.account_circle),
        Expanded(
            child: Column(
          children: [AutoSizeText('Deposit'), AutoSizeText(date)],
        )),
        Column(
          children: [
            AutoSizeText(amount.toString()),
            AutoSizeText(status),
          ],
        ),
      ],
    );
  }
}

class DataHistoryWidget extends ConsumerWidget {
  final String date;
  final String status;
  final double amount;
  const DataHistoryWidget(
      {super.key,
      required this.date,
      required this.status,
      required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.data_exploration),
        Expanded(
            child: Column(
          children: [AutoSizeText('Deposit'), AutoSizeText(date)],
        )),
        Column(
          children: [
            AutoSizeText(amount.toString()),
            AutoSizeText(status),
          ],
        ),
      ],
    );
  }
}
