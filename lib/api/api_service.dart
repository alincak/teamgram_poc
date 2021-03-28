import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamgram_poc/models/domain_model.dart';
import 'package:teamgram_poc/models/timeline_model.dart';
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
      loginUser(userName, password, twoFAIsActive(response));
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

  bool twoFAIsActive(Response response) {
    if (response == null ||
        response.headers == null ||
        !response.headers.containsKey("tg-otptwofaisactive")) {
      return false;
    }

    var isActive =
        response.headers["tg-otptwofaisactive"].toLowerCase() == 'true';
    return isActive;
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getString('username') != null &&
        prefs.getString('domainname') != null;

    var valTFAVerified = prefs.getString('TFAVerified');
    final bool verifiedTFA = valTFAVerified == null || valTFAVerified == "true";

    return loggedIn && verifiedTFA;
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('password');
    prefs.remove('domainname');
    prefs.remove('TFAVerified');
  }

  Future<Null> loginUser(
      String userName, String password, bool twoFAIsActive) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', userName);
    prefs.setString('password', password);
    if (twoFAIsActive) {
      prefs.setString('TFAVerified', "false");
    }
  }

  void verifiedTFA() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('TFAVerified', 'true');
  }

  Future<Null> saveDomainName(String domainName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('domainname', domainName);
  }

  Future<TimeLineModel> timeLine() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var domainName = prefs.get("domainname");
    String url = "https://api.teamgram.com/$domainName/notes/timeline";

    var userName = prefs.get("username");
    var password = prefs.get("password");
    String basicAuth =
        "Basic " + base64Encode(utf8.encode('$userName:$password'));

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200 || response.statusCode == 400) {
      var decoded = json.decode(response.body);
      if (decoded != null) {
        return TimeLineModel.fromJson(decoded);
      }
      Fluttertoast.showToast(msg: "Failed to load data!");
    }

    return null;
  }

  Future<bool> twoFACodeValidate(String pin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "https://api.teamgram.com/TwoFACodeValidate?code=" + pin;

    var userName = prefs.get("username");
    var password = prefs.get("password");
    String basicAuth =
        "Basic " + base64Encode(utf8.encode('$userName:$password'));

    final response = await http.get(Uri.parse(url),
        headers: <String, String>{'authorization': basicAuth});
    if (response.statusCode == 200 || response.statusCode == 400) {
      var decoded = json.decode(response.body);
      if (decoded != null) {
        var verified = decoded["Verified"] != null &&
            decoded["Verified"].toString().toLowerCase() == 'true';
        if (verified) {
          verifiedTFA();
        }
        return verified;
      }
    }

    return false;
  }
}
