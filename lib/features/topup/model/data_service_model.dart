import 'package:bytebuddy/features/topup/model/data_plan_model.dart';

class DataServiceModel {
  String service;
  List<DataPlanModel> plans;

  DataServiceModel({
    required this.service,
    required this.plans,
  });

  factory DataServiceModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> plansJson = json['plans'];
    List<DataPlanModel> dataPlans =
        plansJson.map((plan) => DataPlanModel.fromJson(plan)).toList();

    return DataServiceModel(
      service: json['service'],
      plans: dataPlans,
    );
  }
}
