import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:bytebuddy/features/topup/data/subscription_factory.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionServiceProvider =
    Provider.family<SubscriptionService, String>((ref, subscriptionType) {
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
      double balance = _transactionRepo.getBalance(email) as double;
      double amount = double.parse(price);
      if (amount > balance) {
        throw Exception('Insufficient funds');
      }
      Subscription subscription =
          _subscriptionFactory.createSubscription(subscriptionType);
      return subscription.buy(serviceID, planIndex, phone, email);
    } catch (error) {
      rethrow;
    }
  }
}
