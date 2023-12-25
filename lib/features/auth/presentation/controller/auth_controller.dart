import 'dart:async';

import 'package:bytebuddy/features/auth/data/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerLoginProvider =
    AsyncNotifierProvider.autoDispose<AuthController, User?>(() {
  return AuthController();
});
final authControllerRegisterProvider =
    AsyncNotifierProvider.autoDispose<AuthController, User?>(() {
  return AuthController();
});
final authControllerResetPasswordProvider =
    AsyncNotifierProvider.autoDispose<AuthController, User?>(() {
  return AuthController();
});

class AuthController extends AutoDisposeAsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    return null;
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(authRepoProvider)
          .signUp(email: email, password: password);
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(authRepoProvider)
          .signIn(email: email, password: password);
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepoProvider).sendPasswordResetEmail(email);
      return null;
    });
  }

  Future<void> sign0ut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepoProvider).signOut();
      return null;
    });
  }

  User? getCurrentUser() {
    return ref.read(authRepoProvider).getCurrentUser();
  }
}
