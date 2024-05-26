import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/widget/history_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../widget/shimmer_widget.dart';

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  final pageSize = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
            backgroundColor: Pallete.secondaryColor,
            appBar: AppBarWidget.appbar(context, "History",
                backgroundColor: Pallete.secondaryColor),
            body: Align(
              alignment: Alignment.topCenter,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                radius: const Radius.circular(50),
                thickness: 5,
                child: Container(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Pallete.secondaryColor,
                  ),
                  alignment: Alignment.topCenter,
                  width: constraints.isMobile ? double.infinity : 500.0,
                  child: ListView.builder(
                    primary: true,
                    itemBuilder: (BuildContext context, int index) {
                      final page = index ~/ pageSize + 1;
                      final indexInPage = index % pageSize;
                      final state = ref.watch(transactionControllerProvider);

                      return state.when(data: (data) {
                        int indexLength = data.length - 1;
                        if (index > indexLength) {
                          return null;
                        }
                        final history = data[index];

                        if (history["type"] == 'Deposit') {
                          return HistoryWidget(
                            type: 'Deposit',
                            date: history['date'],
                            status: history['status'],
                            amount: history['amount'],
                          );
                        } else {
                          return HistoryWidget(
                            type: 'Data',
                            date: history['date'],
                            status: history['status'],
                            amount: history['amount'],
                          );
                        }
                      }, error: (error, stackTrace) {
                        return Column(
                          children: [
                            const Gap(15),
                            Center(
                              child: AutoSizeText(
                                "No history data or internet connection",
                                //error.toString(),
                                textAlign: TextAlign.center,
                                style: context.bodyMedium
                                    ?.copyWith(color: Pallete.textColor),
                              ),
                            ),
                            const Gap(30),
                            ElevatedButton(
                              style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    side:
                                        BorderSide(color: Pallete.primaryColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                backgroundColor: MaterialStatePropertyAll(
                                    Pallete.secondaryColor),
                                foregroundColor: MaterialStatePropertyAll(
                                    Pallete.primaryColor),
                              ),
                              onPressed: () =>
                                  ref.invalidate(transactionControllerProvider),
                              child: const AutoSizeText(
                                'Retry',
                              ),
                            ),
                          ],
                        );
                      }, loading: () {
                        return const Column(
                          children: [
                            Gap(20),
                            ShimmerWidget.rectangular(
                              width: double.infinity,
                              height: 50,
                            ),
                          ],
                        );
                      });
                    },
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
