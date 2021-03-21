import 'package:http/http.dart' as http;
import 'package:teamgram_poc/models/domain_model.dart';
import 'dart:convert';
import '../models/login_model.dart';

class APIService {
  Future<List<DomainModel>> login(LoginRequestModel requestModel) async {
    String url = "https://localhost.teamgram.com/api/domain";

    var userName = requestModel.email;
    var password = requestModel.password;
    String basicAuth =
        "Basic " + base64Encode(utf8.encode('$userName:$password'));

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{'authorization': basicAuth},
        body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
      var decoded = json.decode(response.body);
      if (decoded != null) {
        Iterable list = decoded["Domains"];
        return List<DomainModel>.from(
            list.map((domain) => DomainModel.fromJson(domain)));
      }
      throw Exception('Failed to load data!');
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
