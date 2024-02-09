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
    double? price = double.tryParse(json['price']);
    double priceWithVAT = price! + 0.05 * price;

    return DataPlanModel(
      displayName: json['displayName'],
      value: json['value'],
      price: priceWithVAT.round().toString(),
    );
  }
}
