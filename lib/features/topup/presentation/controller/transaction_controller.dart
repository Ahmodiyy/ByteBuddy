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
  DocumentSnapshot? lastDocumentSnapshot;

  @override
  FutureOr<List<QueryDocumentSnapshot>> build() async {
    state = const AsyncLoading();
    try {
      final email = ref
          .read(authControllerLoginProvider.notifier)
          .getCurrentUser()
          ?.email;

      if (email == null) {
        throw Exception('User email is null');
      }

      final transactions = await ref
          .read(transactionRepoProvider)
          .fetchTransactionHistory(email);

      if (transactions.isNotEmpty) {
        lastDocumentSnapshot = transactions.last;
      }

      return transactions;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return [];
    }
  }

  Future<List> fetchNextTransactionHistory() async {
    List nextTransactions = [];
    state = await AsyncValue.guard(() async {
      final email = ref
          .read(authControllerLoginProvider.notifier)
          .getCurrentUser()
          ?.email;

      if (email == null) {
        throw Exception('User email is null');
      }

      nextTransactions = await ref
          .read(transactionRepoProvider)
          .fetchNextTransactionHistory(email, lastDocumentSnapshot);

      if (nextTransactions.isNotEmpty) {
        lastDocumentSnapshot = nextTransactions.last;
      }

      return [
        ...state.value ?? [],
        ...nextTransactions,
      ];
    });

    return nextTransactions;
  }
}
