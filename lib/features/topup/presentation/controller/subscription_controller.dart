import 'dart:async';

import 'package:bytebuddy/features/topup/application/subscription_service.dart';
import 'package:bytebuddy/features/topup/data/data_subscription_repo.dart';
import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:bytebuddy/features/topup/model/data_service_model.dart';
import 'package:bytebuddy/features/topup/presentation/view/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionControllerProvider =
    AsyncNotifierProvider.autoDispose<SubscriptionController, void>(() {
  return SubscriptionController();
});

class SubscriptionController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signSubscription(
      {required String subscriptionType,
      required String serviceID,
      required int planIndex,
      required String phone,
      required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      Subscription subscription =
          ref.read(subscriptionServiceProvider(subscriptionType)).subscription;
      await subscription.buy(serviceID, planIndex, phone, email);
    });
  }
}
