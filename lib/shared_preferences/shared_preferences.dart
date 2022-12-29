import 'package:shared_preferences/shared_preferences.dart';

enum SpKeys {
  loggedIn,
  lang,
  fcmToken,
  uId,
  username,
  email,
  password,
  avatar,
  userType,
}

class SharedPreferencesController {
  static final SharedPreferencesController _sharedPrefControllerObj =
      SharedPreferencesController._sharedPrefPrivateConstructor();

  SharedPreferencesController._sharedPrefPrivateConstructor();

  late SharedPreferences _sharedPrefLibObj;

  factory SharedPreferencesController() {
    return _sharedPrefControllerObj;
  }

  Future<void> initSharedPreferences() async {
    _sharedPrefLibObj = await SharedPreferences.getInstance();
  }

  // خزن اللغة تاعت التطبيق سواء و هو مطفي او شغال احفظ هي الحالة
  /// Language
  Future<void> setLanguage(String language) async {
    await _sharedPrefLibObj.setString(SpKeys.lang.name, language);
  }

  String get getLanguage =>
      _sharedPrefLibObj.getString(SpKeys.lang.name) ?? 'en';

  Future<void> setFcmToken({required String fcmToken}) async {
    await _sharedPrefLibObj.setString(SpKeys.fcmToken.toString(), fcmToken);
  }

  String get getFcmToken =>
      _sharedPrefLibObj.getString(SpKeys.fcmToken.toString()) ?? ' ';

  Future<void> setLoggedIn() async {
    await _sharedPrefLibObj.setBool(SpKeys.loggedIn.toString(), true);
  }

  bool get checkLoggedIn =>
      _sharedPrefLibObj.getBool(SpKeys.loggedIn.toString()) ?? false;

  Future<void> logout() async {
    await _sharedPrefLibObj.setString(SpKeys.fcmToken.toString(), '');
    await _sharedPrefLibObj.setBool(SpKeys.loggedIn.toString(), false);
  }

  /// Auth
  Future<void> setUId({required String id}) async {
    await _sharedPrefLibObj.setString(SpKeys.uId.toString(), id);
  }

  String get getUId => _sharedPrefLibObj.getString(SpKeys.uId.toString()) ?? '';

  Future<void> setUserType({required String type}) async {
    await _sharedPrefLibObj.setString(SpKeys.userType.toString(), type);
  }

  String get getUserType =>
      _sharedPrefLibObj.getString(SpKeys.userType.toString()) ?? '';

  Future<void> setUsername({required String username}) async {
    await _sharedPrefLibObj.setString(SpKeys.username.toString(), username);
  }

  String get getUsername =>
      _sharedPrefLibObj.getString(SpKeys.username.toString()) ?? '';

  Future<void> setEmail({required String email}) async {
    await _sharedPrefLibObj.setString(SpKeys.email.toString(), email);
  }

  String get getEmail =>
      _sharedPrefLibObj.getString(SpKeys.email.toString()) ?? '';

  Future<void> setAvatar({required String avatar}) async {
    await _sharedPrefLibObj.setString(SpKeys.avatar.toString(), avatar);
  }

  String get getAvatar =>
      _sharedPrefLibObj.getString(SpKeys.avatar.toString()) ?? '';
}
