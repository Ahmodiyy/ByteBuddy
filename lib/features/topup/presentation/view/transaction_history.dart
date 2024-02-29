import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
          appBar: AppBarWidget.appbar(context, "History",
              backgroundColor: Pallete.backgroundColor),
          body: state.when(
            data: (data) {
              return Container(
                alignment: Alignment.center,
                width: constraints.isMobile ? double.infinity : 400.0,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final history = data[index];
                      if (history["type"] == 'Add money') {
                        return HistoryWidget(
                          type: 'Deposit',
                          date: history['date'],
                          status: history['status'],
                          amount: history['amount'],
                        );
                      } else if (history["type"] == 'Data') {
                        return HistoryWidget(
                          type: 'Data',
                          date: history['date'],
                          status: history['status'],
                          amount: history['amount'],
                        );
                      }
                    },
                  ),
                ),
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
          )),
    );
  }
}

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
    return Row(
      children: [
        CircleAvatar(
            backgroundColor: Pallete.backgroundColor,
            child:
                SvgPicture.asset(SvgConstant.deposit, width: 25, height: 25)),
        Expanded(
          child: Column(
            children: [
              AutoSizeText(type, maxLines: 1),
              AutoSizeText(date, maxLines: 1),
            ],
          ),
        ),
        Column(
          children: [
            AutoSizeText(amount.toString(), maxLines: 1),
            AutoSizeText(status, maxLines: 1),
          ],
        ),
      ],
    );
  }
}
