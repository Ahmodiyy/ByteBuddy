import 'dart:async';
import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider = StreamNotifierProvider.autoDispose<
    TransactionController, List<QueryDocumentSnapshot>>(() {
  return TransactionController();
});

class TransactionController
    extends AutoDisposeStreamNotifier<List<QueryDocumentSnapshot>> {
  DocumentSnapshot? lastDocumentSnapshot;

  @override
  Stream<List<QueryDocumentSnapshot>> build() async* {
    final email = ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()
        ?.email;

    if (email == null) {
      throw Exception('User email is null');
    }

    List<QueryDocumentSnapshot> allTransactions = [];

    // Listen for the initial batch of transactions
    await for (var transactions in ref.read(transactionRepoProvider)
        .fetchTransactionHistoryStream(email)) {

      if (transactions.isNotEmpty) {
        lastDocumentSnapshot = transactions.last;
      }

      allTransactions = [...allTransactions, ...transactions];
      yield allTransactions;

    }
  }

  Future<List<QueryDocumentSnapshot>> fetchNextTransactionHistory() async {
    final email = ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()
        ?.email;

    if (email == null) {
      throw Exception('User email is null');
    }

    // Fetch the next batch of transactions
    final nextTransactions = await ref
        .read(transactionRepoProvider)
        .fetchNextTransactionHistory(email, lastDocumentSnapshot);

    if (nextTransactions.isNotEmpty) {
      lastDocumentSnapshot = nextTransactions.last;

      // Update the state with the new transactions
      state = AsyncValue.data([
        ...state.value ?? [],
        ...nextTransactions,
      ]);
    }

    return nextTransactions;
  }
}
