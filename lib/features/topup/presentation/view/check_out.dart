import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/topup/application/subscription_service.dart';
import 'package:bytebuddy/features/topup/model/data_purchase_model.dart';
import 'package:bytebuddy/features/topup/presentation/controller/subscription_controller.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CheckOut extends ConsumerWidget {
  final DataPurchaseModel dataPurchaseModel;
  const CheckOut(
    this.dataPurchaseModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String service = dataPurchaseModel.service;
    String number = dataPurchaseModel.number;
    String serviceID = dataPurchaseModel.serviceID;
    int planIndex = dataPurchaseModel.planIndex;
    String price = dataPurchaseModel.dataPlan.price;
    String displayName = dataPurchaseModel.dataPlan.displayName;

    ref.listen(
      subscriptionControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            context.go("/dashboard/transaction_status");
          },
          error: (error, stackTrace) {
            var snackBar = SnackBar(
              content: Text('Hello, SnackBar!'),
              duration:
                  Duration(seconds: 2), // Optional, how long it stays on screen
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  // Some code to execute when this action is selected
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          loading: () {},
        );
      },
    );
    final state = ref.watch(subscriptionControllerProvider);
    bool isLoading = state is AsyncLoading;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget.appbar(context, "Data",
            backgroundColor: Pallete.scaffoldColor),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(10),
                Center(
                  child: AutoSizeText(
                    'Actual Payment',
                    style: context.bodySmall?.copyWith(
                        color: Pallete.lightBlack, fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(10),
                Center(
                  child: AutoSizeText('\u20A6$price',
                      style: context.bodyMedium?.copyWith(
                          color: Pallete.blackColor,
                          fontWeight: FontWeight.bold)),
                ),
                const Gap(10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the corner radius as needed
                  ),
                  child: Table(
                    border: null,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: AutoSizeText(
                              'Service name',
                              style: context.bodySmall
                                  ?.copyWith(color: Pallete.lighterBlack),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: AutoSizeText(
                                service,
                                style: context.bodySmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: AutoSizeText(
                              'Phone number',
                              style: context.bodySmall
                                  ?.copyWith(color: Pallete.lighterBlack),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: AutoSizeText(
                                number,
                                style: context.bodySmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: AutoSizeText(
                              'Data plan',
                              style: context.bodySmall
                                  ?.copyWith(color: Pallete.lighterBlack),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: AutoSizeText(
                                displayName,
                                style: context.bodySmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: AutoSizeText(
                              'Amount',
                              style: context.bodySmall
                                  ?.copyWith(color: Pallete.lighterBlack),
                            ),
                          ),
                          TableCell(
                            child: AutoSizeText(
                              '\u20A6$price',
                              style: context.bodySmall,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(50),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(subscriptionServiceProvider("data"))
                        .buySubscription(
                          subscriptionType: 'data',
                          serviceID: serviceID,
                          planIndex: planIndex,
                          phone: number,
                          email: ref
                              .read(authControllerLoginProvider.notifier)
                              .getCurrentUser()!
                              .email!,
                          price: price,
                        );
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const AutoSizeText('Pay'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
