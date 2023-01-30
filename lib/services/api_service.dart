// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/models/login_request_model.dart';
import 'package:creative_mobile/models/login_response_model.dart';
import 'package:creative_mobile/services/shared_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    // var url = Uri.http(Config.apiURL, Config.loginAPI);
    var url = Uri.http("192.168.4.115:8000", Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

//mengambil dari API laravel
    var data = jsonDecode(response.body) as Map<String, dynamic>;
    var user = data['user'] as Map<String, dynamic>;
    int userId = user['id'];
    var username = user['user_name'];

    var auth = data['auth'] as Map<String, dynamic>;
    var token = auth['token'] as String;

    addUserIdToSF(userId, username);
    print(await getUIDFromSF());
    addAPITokenToSF(token);
    // print('user_id_fromSF : ' + UserID.toString());
    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(
        loginResponseJson(response.body),
      );
      return true;
    } else {
      return false;
    }
  }
}

addUserIdToSF(userId, username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('userId', userId);
  prefs.setString('user_name', username);
}

getUIDFromSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}

addAPITokenToSF(apiToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('apiToken', apiToken);
}
