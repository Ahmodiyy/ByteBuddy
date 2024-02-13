import 'package:bytebuddy/features/topup/model/data_plan_model.dart';

class DataPurchaseModel {
  String service;
  String serviceID;
  int planIndex;
  String number;

  DataPlanModel dataPlan;

  DataPurchaseModel({
    required this.service,
    required this.serviceID,
    required this.planIndex,
    required this.number,
    required this.dataPlan,
  });
}
