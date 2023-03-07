// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unused_import, avoid_print

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
    // print(Config.apiURL + Config.apiSPK + '/' + user_id.toString());
    // var uri = Uri.http(
    //     Config.apiURL, Config.apiSPK + '/' + user_id.toString()); //key param
    var uri = Uri.http('192.168.4.204:8000',
        Config.apiSPK + '/' + user_id.toString()); //untuk memanggil data spk

    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + apiToken,
      },
    );
    // print(response.body);
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
