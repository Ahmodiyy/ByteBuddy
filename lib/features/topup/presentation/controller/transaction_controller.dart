import 'dart:async';

import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider = AsyncNotifierProvider.autoDispose<
    TransactionController, List<QueryDocumentSnapshot>>(() {
  return TransactionController();
});

class TransactionController
    extends AutoDisposeAsyncNotifier<List<QueryDocumentSnapshot>> {
  @override
  FutureOr<List<QueryDocumentSnapshot>> build() async {
    state = const AsyncLoading();
    return await ref.read(transactionRepoProvider).fetchTransactionHistory(ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()!
        .email!);
  }

  Future<void> fetchNextTransactionHistory(
      DocumentSnapshot documentSnapshot) async {
    state = await AsyncValue.guard(() async {
      return await ref
          .read(transactionRepoProvider)
          .fetchNextTransactionHistory(
              ref
                  .read(authControllerLoginProvider.notifier)
                  .getCurrentUser()!
                  .email!,
              documentSnapshot);
    });
  }
}
