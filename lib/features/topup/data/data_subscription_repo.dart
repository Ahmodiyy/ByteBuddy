import 'package:bytebuddy/constants/endpoint_constant.dart';
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
        EndpointConstant.buyDataPlanEndpoint,
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
      if (response.data == null) {
        throw Exception("This service has been disabled for now");
      }
      Map<String, dynamic> jsonData = response.data;
      return jsonData;
    } on DioException catch (e) {
      throw Exception("Please check your internet connection and try again.");
    } catch (error) {
      rethrow;
    }
  }

  Future<DataServiceModel> getDataPlans(String network) async {
    try {
      Response response =
          await _dio.get('${EndpointConstant.getDataPlanEndpoint}$network');
      if (response.data == null) {
        throw Exception("This service has been disabled for now");
      }
      Map<String, dynamic> jsonData = response.data;
      return DataServiceModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw Exception("Please check your internet connection and try again.");
    } catch (error) {
      rethrow;
    }
  }
}
