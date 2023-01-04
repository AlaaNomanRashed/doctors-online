import 'package:flutter/widgets.dart';
import '../shared_preferences/shared_preferences.dart';

class AuthProvider  extends ChangeNotifier{
  String name_ = SharedPreferencesController().getter(type: String, key: SpKeys.username);
  String mobile_ = SharedPreferencesController().getter(type: String, key: SpKeys.mobile);
  String avatar_ = SharedPreferencesController().getter(type: String, key: SpKeys.avatar);


  Future<void> setName_(String name)async{
    name_ = name;
    await SharedPreferencesController().setter(type: String, key: SpKeys.username, value: name);
    notifyListeners();
  }

  Future<void> setMobile_(String mobile)async{
    mobile_ = mobile;
    await SharedPreferencesController().setter(type: String, key: SpKeys.mobile, value: mobile);
    notifyListeners();
  }

  Future<void> setAvatar_ (String avatar)async{
    avatar_ = avatar;
    await SharedPreferencesController().setter(type: String, key: SpKeys.avatar, value: avatar);
    notifyListeners();
  }
}