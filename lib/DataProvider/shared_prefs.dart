import 'package:shared_preferences/shared_preferences.dart';

const isFirstLoadKey = "firstLoad";

class PreferenciesAppManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> isFirstLoad() async {
    var prefs = await _prefs;
    if (prefs.containsKey(isFirstLoadKey)) {
      return prefs.getBool(isFirstLoadKey)!;
    } else {
      prefs.setBool(isFirstLoadKey, true);
      return true;
    }
  }

  void hideFirstLoadScreen() async {
    var prefs = await _prefs;
    prefs.setBool(isFirstLoadKey, false);
  }
}
