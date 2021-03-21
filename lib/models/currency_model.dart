class CurrencyModel {
  final int id;
  final String name;

  CurrencyModel({this.id, this.name});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json["Id"] != null ? json["Id"] : 0,
      name: json["Name"] != null ? json["Name"] : "",
    );
  }
}
