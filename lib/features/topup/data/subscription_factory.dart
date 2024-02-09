import 'package:bytebuddy/features/topup/data/airtime_subscription_repo.dart';
import 'package:bytebuddy/features/topup/data/data_subscription_repo.dart';
import 'package:bytebuddy/features/topup/data/subscription.dart';

class SubscriptionFactory {
  static Subscription createSubscription(String type) {
    if (type.toLowerCase() == "data") {
      return DataSubscriptionRepo();
    } else if (type.toLowerCase() == "airtime") {
      return AirtimeSubscriptionRepo();
    }
    throw ArgumentError(
        "Invalid vehicle type inside subscription factory method");
  }
}
