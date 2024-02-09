import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:bytebuddy/features/topup/data/subscription_factory.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionServiceProvider =
    Provider.family<SubscriptionService, String>((ref, subscriptionType) {
  return SubscriptionService(
      transactionRepo: ref.read(transactionRepoProvider),
      subscription: SubscriptionFactory.createSubscription(subscriptionType));
});

class SubscriptionService {
  final TransactionRepo transactionRepo;
  final Subscription subscription;

  SubscriptionService(
      {required this.transactionRepo, required this.subscription});

  Future<void> buySubscription() async {}
}
