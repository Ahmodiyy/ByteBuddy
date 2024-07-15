class DataPlanModel {
  String displayName;
  String value;
  String price;

  DataPlanModel({
    required this.displayName,
    required this.value,
    required this.price,
  });

  factory DataPlanModel.fromJson(Map<String, dynamic> json) {

    return DataPlanModel(
      displayName: json['displayName'],
      value: json['value'],
      price: json['price']
    );
  }
}
