import 'package:auto_size_text/auto_size_text.dart';
import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rive/rive.dart';
import 'package:bytebuddy/constants/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final transactionStatusDataProvider =
    StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

class TransactionStatus extends ConsumerWidget {
  const TransactionStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionStatusData = ref.watch(transactionStatusDataProvider)!;
    String status = transactionStatusData['status'];
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(30),
                SizedBox(
                    height: 100,
                    child: status == 'successful'
                        ? const RiveAnimation.asset(
                            RiveConstant.success,
                          )
                        : const RiveAnimation.asset(RiveConstant.error)),
                const Gap(10),
                AutoSizeText(
                  transactionStatusData['status'].toString().toLowerCase(),
                  textAlign: TextAlign.center,
                  style: context.bodyMedium?.copyWith(
                      color: Pallete.textColor, fontWeight: FontWeight.w300),
                ),
                const Gap(5),
                AutoSizeText(
                  transactionStatusData['description'].toString().toLowerCase(),
                  textAlign: TextAlign.center,
                  style: context.bodySmall
                      ?.copyWith(color: Pallete.secondaryTextColor),
                ),
                const Gap(100),
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
                    backgroundColor:
                        MaterialStatePropertyAll(Pallete.secondaryColor),
                    foregroundColor:
                        MaterialStatePropertyAll(Pallete.primaryColor),
                  ),
                  onPressed: () => context.go(('/dashboard')),
                  child: const AutoSizeText(
                    'Done',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
