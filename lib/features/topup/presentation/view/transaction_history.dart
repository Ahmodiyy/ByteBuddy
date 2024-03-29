import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/transaction_history.dart';
import 'package:bytebuddy/features/topup/presentation/widget/history_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../data/transaction_repo.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionHistoryStreamProvider);
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
            backgroundColor: Pallete.secondaryColor,
            appBar: AppBarWidget.appbar(context, "History",
                backgroundColor: Pallete.secondaryColor),
            body: Column(
              children: [
                state.when(
                  data: (data) {
                    if (data.isEmpty) return Container();
                    return Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 20),
                          decoration: const BoxDecoration(
                            color: Pallete.secondaryColor,
                          ),
                          alignment: Alignment.topCenter,
                          width: constraints.isMobile ? double.infinity : 500.0,
                          child: Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            radius: const Radius.circular(50),
                            thickness: 5,
                            child: RefreshIndicator(
                              onRefresh: () => ref.refresh(
                                  transactionControllerProvider.future),
                              color: Pallete.primaryColor,
                              backgroundColor: Pallete.secondaryColor,
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
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: AutoSizeText(
                        "No history data or internet connection",
                        style: context.bodyMedium
                            ?.copyWith(color: Pallete.textColor),
                      ),
                    );
                  },
                  loading: () {
                    return const Column(
                      children: [
                        Gap(20),
                        Center(
                            child: CircularProgressIndicator(
                          color: Pallete.primaryColor,
                        )),
                      ],
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}
