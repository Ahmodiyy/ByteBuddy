import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/common/appBar_widget.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/topup/model/data_purchase_model.dart';
import 'package:bytebuddy/features/topup/presentation/controller/subscription_controller.dart';
import 'package:bytebuddy/features/topup/presentation/view/transaction_status.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../util/functions.dart';

final dataPurchaseProvider = StateProvider<DataPurchaseModel?>((ref) {
  return null;
});

class CheckOut extends ConsumerWidget {
  const CheckOut({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataPurchaseModel = ref.watch(dataPurchaseProvider)!;
    String service = dataPurchaseModel.service;
    String number = dataPurchaseModel.number;
    String serviceID = dataPurchaseModel.serviceID;
    int planIndex = dataPurchaseModel.planIndex;
    String price = dataPurchaseModel.dataPlan.price;
    String displayName = dataPurchaseModel.dataPlan.displayName;
    final formattedPrice =
        UtilityFunctions.formatCurrency(int.tryParse(price) as num);
    ref.listen(
      subscriptionControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            ref
                .read(transactionStatusDataProvider.notifier)
                .update((state) => data);
            context.go("/dashboard/transaction_status");
          },
          error: (error, stackTrace) {
            var snackBar = SnackBar(
              content: AutoSizeText(
                error.toString(),
                style: context.bodySmall?.copyWith(color: Pallete.errorColor),
              ),
              duration: const Duration(
                  seconds: 3), // Optional, how long it stays on screen
              action: SnackBarAction(
                label: 'Close',
                textColor: Pallete.primaryColor,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
              backgroundColor: Pallete.secondaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          loading: () {},
        );
      },
    );
    final state = ref.watch(subscriptionControllerProvider);
    final isLoading = state is AsyncLoading;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarWidget.appbar(context, "Data",
                backgroundColor: Pallete.backgroundColor),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: constraints.isMobile ? double.infinity : 400.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Gap(10),
                        Center(
                          child: AutoSizeText(
                            'Actual Payment',
                            style: context.bodySmall?.copyWith(
                                color: Pallete.secondaryTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Gap(10),
                        Center(
                          child: AutoSizeText(formattedPrice,
                              style: context.bodyMedium?.copyWith(
                                  color: Pallete.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Gap(10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Pallete.secondaryColor,
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
                                      style: context.bodySmall?.copyWith(
                                          color: Pallete.secondaryTextColor),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                      style: context.bodySmall?.copyWith(
                                          color: Pallete.secondaryTextColor),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                      style: context.bodySmall?.copyWith(
                                          color: Pallete.secondaryTextColor),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
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
                                      style: context.bodySmall?.copyWith(
                                          color: Pallete.secondaryTextColor),
                                    ),
                                  ),
                                  TableCell(
                                    child: AutoSizeText(
                                      formattedPrice,
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
                          onPressed: isLoading
                              ? null
                              : () {
                                  ref
                                      .read(subscriptionControllerProvider
                                          .notifier)
                                      .subscribe(
                                        subscriptionType: 'data',
                                        serviceID: serviceID,
                                        planIndex: planIndex,
                                        phone: number,
                                        email: ref
                                            .read(authControllerLoginProvider
                                                .notifier)
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
            ),
          ),
        );
      },
    );
  }
}
