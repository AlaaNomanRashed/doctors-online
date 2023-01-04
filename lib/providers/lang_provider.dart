import 'package:flutter/cupertino.dart';
import '../shared_preferences/shared_preferences.dart';

class LangProviders extends ChangeNotifier {
  String lang_ = SharedPreferencesController().getter(type: String, key: SpKeys.lang).toString();

  Future<void> changeLanguage() async {
    lang_ == 'ar' ? lang_ = 'en' : lang_ = 'ar';

    await SharedPreferencesController().setter(type: String, key: SpKeys.lang, value: lang_);
    notifyListeners();
  }
}
