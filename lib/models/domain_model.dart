import 'package:teamgram_poc/models/currency_model.dart';

class DomainModel {
  final int id;
  final String name;
  final String displayName;
  final CurrencyModel currency;

  DomainModel({this.id, this.name, this.displayName, this.currency});

  factory DomainModel.fromJson(Map<String, dynamic> jsonToken) {
    return DomainModel(
      id: jsonToken["Id"] != null ? int.parse(jsonToken["Id"]) : 0,
      name: jsonToken["Name"] != null ? jsonToken["Name"] : "",
      displayName:
          jsonToken["DisplayName"] != null ? jsonToken["DisplayName"] : "",
      currency: jsonToken["Currency"] != null
          ? CurrencyModel.fromJson(
              jsonToken["Currency"],
            )
          : null,
    );
  }
}
