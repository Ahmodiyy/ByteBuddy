import 'dart:async';

import 'package:bytebuddy/features/auth/presentation/controller/auth_controller.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionControllerProvider = AsyncNotifierProvider.autoDispose<
    TransactionController, List<Map<String, dynamic>>>(() {
  return TransactionController();
});

class TransactionController
    extends AutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  @override
  FutureOr<List<Map<String, dynamic>>> build() {
    state = const AsyncLoading();
    return ref.read(transactionRepoProvider).fetchTransactionHistory(ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()!
        .email!);
  }
}
