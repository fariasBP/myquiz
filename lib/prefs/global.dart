import 'package:shared_preferences/shared_preferences.dart';

class GlobalPrefs {
  static final GlobalPrefs _instancia = GlobalPrefs._internal();
  late SharedPreferences _prefs;
  // ignore: non_constant_identifier_names
  static final String MODE = 'mode';

  factory GlobalPrefs() {
    return _instancia;
  }
  GlobalPrefs._internal();

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isDark {
    return _prefs.getBool(GlobalPrefs.MODE) ?? true;
  }

  set isDark(bool mode) {
    _prefs.setBool(GlobalPrefs.MODE, mode);
  }
}
