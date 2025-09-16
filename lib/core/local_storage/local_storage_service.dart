import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService._(prefs);
  }


  // Keys
  static const String isAdmin = 'isAdmin';

  Future<void> cleanAllData() async {
    _prefs.clear();
  }

  bool getIsAdmin() {
    return _prefs.getBool(isAdmin) ?? false;
  }

  Future<bool> setIsAdmin(bool value) async {
    return _prefs.setBool(isAdmin, value);
  }
}
