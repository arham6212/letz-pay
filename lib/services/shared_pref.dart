import 'package:shared_preferences/shared_preferences.dart';

var prefs;
sharedPrefInit() async {
  prefs = await SharedPreferences.getInstance();
}

saveKeyValString(String key, String data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, data);
}

saveKeyValInt(String key, data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(key, data);
}

saveKeyValBool(String key, bool data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, data);
}

saveKeyValDouble(String key, double data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble(key, data);
}

getStringVal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '';
}

getIntVal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

getDoubleVal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

getBoolVal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

removeVal(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(key);
}

//clear all shared pref variable
removeAllSharedPref() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}
