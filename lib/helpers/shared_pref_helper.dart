import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);

    return Future.delayed(Duration.zero).then((_) => value);
  }

  static Future<bool> firstTimeRunApp() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(kFirstTimeRunKey) == null) {
      await prefs.setString(kFirstTimeRunKey, 'not first time run the app');
      return true;
    } else {
      return false;
    }
  }

  static Future<void> removeAllSavedKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
