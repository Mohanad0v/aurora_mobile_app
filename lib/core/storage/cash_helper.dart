import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  final SharedPreferences? sharedPreferences;

  CashHelper(this.sharedPreferences);

  // static init() async {
  //   sharedPreferences= await SharedPreferences.getInstance();
  // }

  dynamic getData({required String key}) {
    return sharedPreferences?.get(key);
  }

  bool? getBool(String key) {
    return sharedPreferences!.getBool(key);
  }

  int? getInt(String key) {
    return sharedPreferences!.getInt(key);
  }

  String? getString(String key) {
    return sharedPreferences!.getString(key);
  }

  List<String>? getStringList(String key) {
    return sharedPreferences?.getStringList(key);
  }

  Future setBool(String key, bool value) async {
    await sharedPreferences!.setBool(key, value);
  }

  Future setInt(String key, int value) async {
    await sharedPreferences!.setInt(key, value);
  }

  Future setString(String key, String value) async {
    await sharedPreferences!.setString(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await sharedPreferences!.setStringList(key, value);
  }

  remove(String key) async {
    await sharedPreferences!.remove(key);
  }

  clear() async {
    await sharedPreferences!.clear();
  }
}
