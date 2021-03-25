import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamgram_poc/models/domain_model.dart';
import 'dart:convert';
import '../models/login_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class APIService {
  Future<List<DomainModel>> login(LoginRequestModel requestModel) async {
    String url = "https://api.teamgram.com/domain";

    var userName = requestModel.email;
    var password = requestModel.password;
    String basicAuth =
        "Basic " + base64Encode(utf8.encode('$userName:$password'));

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      loginUser(userName, password);
      var decoded = json.decode(response.body);
      if (decoded != null) {
        Iterable list = decoded["Domains"];
        return List<DomainModel>.from(
            list.map((domain) => DomainModel.fromJson(domain)));
      }
      Fluttertoast.showToast(msg: "Failed to load data!");
    } else {
      if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "401");
      } else if (response.headers.keys.contains("lockedout")) {
        Fluttertoast.showToast(msg: "lockedout");
      } else {
        Fluttertoast.showToast(
            msg: response.statusCode.toString() + "Failed to load data!");
      }
    }

    return null;
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', null);
    prefs.setString('password', null);
    prefs.setString('domainname', null);
  }

  Future<Null> loginUser(String userName, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userName);
    prefs.setString('password', password);
  }

  Future<Null> saveDomainName(String domainName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('domainname', domainName);
  }
}
