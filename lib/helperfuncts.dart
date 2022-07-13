import "package:shared_preferences/shared_preferences.dart";

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPrefernceUserEmailKey = "USEREMAILKEY";

  static Future<void> saveuserLoggedInSharedPref(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedPreferenceUserLoggedInKey, login);
  }

  static Future<void> saveuserNameSharedPref(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceUserNameKey, username);
  }

  static Future<void> saveuserEmailSharedPref(String useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPrefernceUserEmailKey, useremail);
  }

  static Future<bool?> getUserLoggedInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserLoggedInEmailSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefernceUserEmailKey);
  }
}
