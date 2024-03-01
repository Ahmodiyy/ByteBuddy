import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class TransactionHistory extends ConsumerWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
          backgroundColor: Pallete.secondaryColor,
          appBar: AppBarWidget.appbar(context, "History",
              backgroundColor: Pallete.secondaryColor),
          body: Column(
            children: [
              Material(
                elevation: 10,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: Pallete.secondaryColor,
                ),
              ),
              const Gap(20),
              state.when(
                data: (data) {
                  return Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Pallete.secondaryColor,
                          ),
                          alignment: Alignment.center,
                          width: constraints.isMobile ? double.infinity : 400.0,
                          child: ListView.separated(
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
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: Pallete.blueGreyColor,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
              radius: 30,
              foregroundColor: Pallete.backgroundColor,
              backgroundColor: Pallete.backgroundColor,
              child: SvgPicture.asset(
                  type == 'Add money' ? SvgConstant.deposit : SvgConstant.datas,
                  width: 25,
                  height: 25)),
          const Gap(20),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    type,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: context.bodyMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    date,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: context.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    amount.toString(),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    style: context.bodyMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    status,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: context.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
