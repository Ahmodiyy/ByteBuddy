import 'dart:async';
import 'package:bytebuddy/features/topup/application/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionControllerProvider = AsyncNotifierProvider.autoDispose<
    SubscriptionController, Map<String, dynamic>>(() {
  return SubscriptionController();
});

class SubscriptionController
    extends AutoDisposeAsyncNotifier<Map<String, dynamic>> {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {};
  }

  Future<void> subscribe(
      {required String subscriptionType,
      required String serviceID,
      required int planIndex,
      required String phone,
      required String email,
      required String price}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      SubscriptionService subscriptionService =
          ref.read(subscriptionServiceProvider);
      return await subscriptionService.buySubscription(
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
