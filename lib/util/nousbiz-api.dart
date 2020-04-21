import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

class Config {
  String apiURL;

  Config.fromJson(Map<String, dynamic> json) : apiURL = json['API_URL'];

  static Future<Config> get() async {
    String jsonString = await rootBundle.loadString('assets/data/config.json');
    Map configMap = jsonDecode(jsonString);
    var config = Config.fromJson(configMap);

    return config;
  }
}

class NousbizAPI {
  NousbizAPI();

  Future<dynamic> get(String route) async {
    var _config = await Config.get();
    String _url = _config.apiURL + route;
    return await http.get(_url);
  }

  Future<dynamic> post(String route, dynamic data) async {
    var _config = await Config.get();
    String _url = _config.apiURL + route;
    return await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data,
    );
  }
}
