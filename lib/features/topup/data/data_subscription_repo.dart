import 'package:bytebuddy/constants/endpoint_constant.dart';
import 'package:bytebuddy/env/Env.dart';
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
        Env.buyDataPlanEndpoint,
        data: {
          "serviceID": serviceID,
          "planIndex": planIndex,
          "phone": phone,
          "email": email
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      final data = response.data;
      if (data == null || data.toString().isEmpty) {
        throw Exception("This service has been disabled for now");
      }
      Map<String, dynamic> jsonData = data;
      return jsonData;
    } on DioException catch (e) {
      throw Exception("Please check your internet connection and try again.");
    } catch (error) {
      rethrow;
    }
  }

  Future<DataServiceModel> getDataPlans(String serviceID) async {
    try {
      final response = await _dio.post(
        Env.getDataPlanEndpoint,
        data: {
          "serviceID": serviceID,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      final data = response.data;
      if (data == null || data.toString().isEmpty) {
        throw Exception("This service has been disabled for now");
      }
      Map<String, dynamic> jsonData = data;
      return DataServiceModel.fromJson(jsonData);
    } on DioException catch (e) {
      throw Exception("Please check your internet connection and try again.");
    } catch (error) {
      rethrow;
    }
  }
}
