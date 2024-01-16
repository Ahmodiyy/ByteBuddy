import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paystackRepoProvider = Provider<PaystackRepo>((ref) {
  return PaystackRepo();
});

class PaystackRepo {
  final dio = Dio();

  Future<double> getTransactionAmount(
      {required String transactionReference}) async {
    try {
      final response = await dio.get(
          'https://api.paystack.co/transaction/verify/$transactionReference');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data as Map<String, dynamic>;
        return jsonData['data']['amount'] as double;
      } else {
        throw Exception('Failed to get transaction amount');
      }
    } catch (e) {
      rethrow;
    }
  }
}
