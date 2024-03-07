import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/transaction_history.dart';
import 'package:bytebuddy/features/topup/presentation/widget/history_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
            backgroundColor: Pallete.secondaryColor,
            appBar: AppBarWidget.appbar(context, "History",
                backgroundColor: Pallete.secondaryColor),
            body: Column(
              children: [
                Material(
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    height: 10,
                    color: Pallete.secondaryColor,
                  ),
                ),
                state.when(
                  data: (data) {
                    return Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 20),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                            color: Pallete.secondaryColor,
                          ),
                          alignment: Alignment.center,
                          width: constraints.isMobile ? double.infinity : 400.0,
                          child: Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            radius: const Radius.circular(50),
                            thickness: 5,
                            child: ListView.separated(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                int lengthArray = data.length - 1;
                                final history = data[lengthArray - index];
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider(
                                  color: Pallete.blueGreyColor,
                                  height: 3,
                                );
                              },
                            ),
                          ),
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
                ),
              ],
            )),
      ),
    );
  }
}
