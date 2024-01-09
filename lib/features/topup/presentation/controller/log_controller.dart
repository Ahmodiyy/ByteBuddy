import 'dart:async';

import 'package:bytebuddy/features/auth/data/auth_repo.dart';
import 'package:bytebuddy/features/topup/data/log_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logControllerTransactionReferenceProvider =
    AsyncNotifierProvider.autoDispose<LogController, void>(() {
  return LogController();
});
final logControllerRegisterProvider =
    AsyncNotifierProvider.autoDispose<LogController, void>(() {
  return LogController();
});

class LogController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<User?> build() {
    return null;
  }

  Future<void> logTransactionReference(
      {required String email, required String transactionReference}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(logRepoProvider).logTransactionReference(
            email: email,
            transactionReference: transactionReference,
          );
    });
  }
}
