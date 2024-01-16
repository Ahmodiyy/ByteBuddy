import 'package:bytebuddy/features/topup/data/paystack_repo.dart';
import 'package:bytebuddy/features/topup/data/transaction_repo.dart';

class TransactionService {
  PaystackRepo paystackRepo;
  TransactionRepo transactionRepo;

  TransactionService(
      {required this.paystackRepo, required this.transactionRepo});

  Future<double> getBalance() async {
    return 0.0;
  }
}
