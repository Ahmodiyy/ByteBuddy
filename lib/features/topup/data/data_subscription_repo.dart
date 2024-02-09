import 'package:bytebuddy/features/topup/data/subscription.dart';
import 'package:bytebuddy/features/topup/model/data_service_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataSubscriptionRepoProvider = Provider<DataSubscriptionRepo>((ref) {
  return DataSubscriptionRepo();
});

class DataSubscriptionRepo implements Subscription {
  final Dio _dio = Dio();

  @override
  Future<Map<String, dynamic>> buy(
      String serviceID, int planIndex, String phone, String email) async {
    try {
      final response = await _dio.post(
        'https://us-central1-bytebuddy-70ed3.cloudfunctions.net/buyDataEndpoint',
        data: {
          "serviceID": serviceID,
          "planIndex": planIndex,
          "phone": phone,
          "email": email
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Add additional headers if required
          },
        ),
      );
      Map<String, dynamic> jsonData = response.data;
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }

  Future<DataServiceModel> getDataPlans(String network) async {
    Map<String, dynamic> jsonData =
        await _getData('https://gsubz.com/api/plans/?service=$network');
    return DataServiceModel.fromJson(jsonData);
  }

  Future<Map<String, dynamic>> _getData(String apiUrl) async {
    try {
      Response response = await _dio.get(apiUrl);
      return response.data;
    } catch (error) {
      rethrow;
    }
  }
}
