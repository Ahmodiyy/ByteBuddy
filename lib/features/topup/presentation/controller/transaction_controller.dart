
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
    await for (var transactions in ref.read(transactionRepoProvider).getTransactionStream(email)) {

      if (transactions.docs.isNotEmpty) {
        lastDocumentSnapshot = transactions.docs.last;
        print("-------------another data --------------");
      }

      allTransactions = [...allTransactions, ...transactions.docs];
      yield allTransactions;

    }
  }

  Future<AsyncData<List>> fetchNextTransactionHistory() async {

    List data = [];
    final email = ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()
        ?.email;

    if (email == null) {
      throw Exception('User email is null');
    }

    await for (var nextTransactions in ref.read(transactionRepoProvider).getNextTransactionStream(email,lastDocumentSnapshot)) {

      if (nextTransactions.docs.isNotEmpty) {
        lastDocumentSnapshot = nextTransactions.docs.last;

        // Update the state with the new transactions
        state = AsyncValue.data([
          ...state.value ?? [],
          ...nextTransactions.docs,
        ]);
        data = nextTransactions.docs;

      }

    }
    return AsyncData(data);
  }
}
