import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static void setKey(key, value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<String> getKey(key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String out = pref.getString(key);
    return out;
  }
}
