import 'package:bytebuddy/features/topup/data/airtime_subscription_repo.dart';
import 'package:bytebuddy/features/topup/data/data_subscription_repo.dart';
import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionFactoryProvider = Provider<SubscriptionFactory>((ref) {
  return SubscriptionFactory();
});

class SubscriptionFactory {
  Subscription createSubscription(String type) {
    if (type.toLowerCase() == "data") {
      return DataSubscriptionRepo();
    } else if (type.toLowerCase() == "airtime") {
      return AirtimeSubscriptionRepo();
    }
    throw ArgumentError(
        "Invalid vehicle type inside subscription factory method");
  }
}
