import 'dart:async';
import 'package:bytebuddy/features/topup/application/subscription_service.dart';
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

  Future<void> subscribe(
      {required String subscriptionType,
      required String serviceID,
      required int planIndex,
      required String phone,
      required String email,
      required String price}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      SubscriptionService subscriptionService =
          ref.read(subscriptionServiceProvider(subscriptionType));
      await subscriptionService.buySubscription(
        subscriptionType: subscriptionType,
        serviceID: serviceID,
        planIndex: planIndex,
        phone: phone,
        email: email,
        price: price,
      );
    });
  }
}
