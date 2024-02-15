import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:bytebuddy/features/topup/data/subscription_factory.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService(
      ref.read(transactionRepoProvider), ref.read(subscriptionFactoryProvider));
});

class SubscriptionService {
  final TransactionRepo _transactionRepo;
  final SubscriptionFactory _subscriptionFactory;

  SubscriptionService(
    this._transactionRepo,
    this._subscriptionFactory,
  );

  Future<Map<String, dynamic>> buySubscription(
      {required String subscriptionType,
      required String serviceID,
      required int planIndex,
      required String phone,
      required String email,
      required String price}) async {
    try {
      dynamic dynamicBalance = await _transactionRepo.getBalance(email);
      String stringBalance = dynamicBalance.toString();
      print('string balance $stringBalance');
      double balance = double.parse(stringBalance);
      double amount = double.parse(price);
      if (amount > balance) {
        throw Exception('Insufficient funds');
      }
      Subscription subscription =
          _subscriptionFactory.createSubscription(subscriptionType);
      return await subscription.buy(serviceID, planIndex, phone, email);
    } catch (error) {
      print('inside subscription service ${error.toString()}');
      rethrow;
    }
  }
}
