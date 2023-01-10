import 'dart:convert';
import 'dart:io';
import 'package:creative_mobile/config.dart';
import 'package:creative_mobile/models/list_spk.dart';
import 'package:creative_mobile/models/spk.dart';
import 'package:html_editor_enhanced/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SpkDBServices {
  int? userId;
  _LoadPF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'user_id': pref.getInt('userId'),
      'apiToken': pref.getString('apiToken')
    };
    return data;
  }

  Future<ListSpk> getSpk() async {
    var SharedPreference = await _LoadPF();
    var user_id = SharedPreference['user_id'];
    var apiToken = SharedPreference['apiToken'];

    // print(Config.apiURL + Config.apiSPK + '/' + id.toString());
    var uri = Uri.http(
        Config.apiURL, Config.apiSPK + '/' + user_id.toString()); //key param
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ' + apiToken,
      },
    );
    print(apiToken);
    var results = json.decode(response.body);
    ListSpk mv = ListSpk.fromJson(results);
    return mv;
  }

  Future<ListSpk> searchSpk(query) async {
    var uri = Uri.http(Config.apiSPK, Config.apiURL, {
      // 'api_key': ,
      'query': query,
    });
    var response = await http.get(uri);
    var results = json.decode(response.body);

    ListSpk mv = ListSpk.fromJson(results);
    return mv;
  }
}
