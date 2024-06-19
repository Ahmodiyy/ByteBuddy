import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'features/topup/presentation/widget/shimmer_widget.dart';

class FirebaseInitialization extends ConsumerStatefulWidget {
  const FirebaseInitialization({super.key});

  @override
  ConsumerState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends ConsumerState<FirebaseInitialization> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Pallete.secondaryColor,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.isMobile) {
                  return const Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    Gap(20),
                    Expanded(
                      child: Column(
                        children: [
                          ShimmerWidget.rectangular(
                            width: double.infinity,
                            height: 180,
                          ),
                          Gap(20),
                          ShimmerWidget.rectangular(
                            width: double.infinity,
                            height: 180,
                          ),
                          Gap(20),
                        ],
                      ),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    )
                  ]);
                }
                return const Row(
                  children: [
                    Column(
                      children: [
                        ShimmerWidget.rectangular(
                          width: 55,
                          height: 55,
                        ),
                        Gap(40),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                        Gap(20),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                        Gap(20),
                        ShimmerWidget.rectangular(
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    Gap(40),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerWidget.rectangular(
                                width: 50,
                                height: 50,
                              ),
                              ShimmerWidget.rectangular(
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                          Gap(40),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ShimmerWidget.rectangular(
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                              Gap(20),
                              Expanded(
                                flex: 3,
                                child: ShimmerWidget.rectangular(
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                              Gap(20),
                            ],
                          ),
                          Gap(40),
                          // Row(
                          //   children: [
                          //     const Expanded(
                          //         flex: 2, child: ShortTransactionHistory()),
                          //     Expanded(flex: 3, child: Container()),
                          //   ],
                          // ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
