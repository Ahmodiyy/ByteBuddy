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
  FutureOr<List<Map<String, dynamic>>> build() async {
    state = const AsyncLoading();
    return await ref.read(transactionRepoProvider).getTransactions(ref
        .read(authControllerLoginProvider.notifier)
        .getCurrentUser()!
        .email!);
  }

  Future<void> getNextTransactions() async {
    state = await AsyncValue.guard(() async {
      return await ref.read(transactionRepoProvider).getNextTransactions(
          ref
              .read(authControllerLoginProvider.notifier)
              .getCurrentUser()!
              .email!,
          state.value!.length - 1);
    });
  }
}
