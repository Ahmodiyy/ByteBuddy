import 'package:bytebuddy/features/topup/data/subscription.dart';

class AirtimeSubscriptionRepo implements Subscription {
  @override
  Future<Map<String, dynamic>> buy(
      String serviceID, int planIndex, String phone, String email) {
    // TODO: implement buy
    throw UnimplementedError();
  }
}
