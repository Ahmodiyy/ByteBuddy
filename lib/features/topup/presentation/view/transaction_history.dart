import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/topup/presentation/controller/transaction_controller.dart';
import 'package:bytebuddy/features/topup/presentation/widget/history_widget.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../widget/shimmer_widget.dart';

final lastDocumentProvider = StateProvider<DocumentSnapshot?>((ref) {
  return null;
});

class TransactionHistory extends ConsumerStatefulWidget {
  const TransactionHistory({super.key});

  @override
  ConsumerState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<TransactionHistory> {
  late ScrollController _scrollController;
  DocumentSnapshot? documentSnapshot;
  bool hasMoreTransactions = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() async {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          hasMoreTransactions) {
        List nextTransactions = await ref
            .read(transactionControllerProvider.notifier)
            .fetchNextTransactionHistory();
        hasMoreTransactions = nextTransactions.length >= 10;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
            backgroundColor: Pallete.secondaryColor,
            appBar: AppBarWidget.appbar(context, "History",
                backgroundColor: Pallete.secondaryColor),
            body: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Pallete.secondaryColor,
                ),
                alignment: Alignment.topCenter,
                width: constraints.isMobile ? double.infinity : 500.0,
                child: state.when(data: (data) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if(data.isEmpty){
                        return Center(
                          child: AutoSizeText(
                            "No data",
                            style: context.bodySmall?.copyWith(
                                color: Pallete.primaryColor),
                          ),
                        );
                      }
                      if (index < data.length) {
                        final historyDocument = data[index];
                          return HistoryWidget(
                           historyDocument
                          );
                      } else {
                        return hasMoreTransactions && data.length == 10
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(
                                    color: Pallete.primaryColor,
                                  ),
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: AutoSizeText(
                                    "No more data",
                                    style: context.bodySmall?.copyWith(
                                        color: Pallete.primaryColor),
                                  ),
                                ),
                              );
                      }
                    },
                  );
                }, error: (error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Gap(15),
                        Center(
                          child: AutoSizeText(
                            // "No history data or internet connection",
                            error.toString(),
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
                                side: BorderSide(color: Pallete.primaryColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                                Pallete.secondaryColor),
                            foregroundColor:
                                MaterialStatePropertyAll(Pallete.primaryColor),
                          ),
                          onPressed: () =>
                              ref.invalidate(transactionControllerProvider),
                          child: const AutoSizeText(
                            'Retry',
                          ),
                        ),
                      ],
                    ),
                  );
                }, loading: () {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Gap(20),
                        Expanded(
                          child: ListView(
                            children: [
                              for (int index = 1; index < 10; index++)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: ShimmerWidget.rectangular(
                                    width: double.infinity,
                                    height: 50,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            )),
      ),
    );
  }
}
