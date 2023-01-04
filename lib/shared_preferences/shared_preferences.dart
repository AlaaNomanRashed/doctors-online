import 'package:shared_preferences/shared_preferences.dart';

enum SpKeys {
  loggedIn,
  lang,
  fcmToken,
  uId,
  userType,
  username,
  email,
  mobile,
  avatar,
  cityId,
  address,
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

  /// setter
  Future<void> setter(
      {required Type type, required SpKeys key, required dynamic value}) async {
    if (type == String) {
      await _sharedPrefLibObj.setString(key.name, value);
    } else if (type == int) {
      await _sharedPrefLibObj.setInt(key.name, value);
    } else if (type == bool) {
      await _sharedPrefLibObj.setBool(key.name, value);
    }
  }

  /// getter
  dynamic getter({required Type type, required SpKeys key}) {
    if (type == String) {
      return _sharedPrefLibObj.getString(key.name) ?? '';
    } else if (type == int) {
      return _sharedPrefLibObj.getInt(key.name) ?? 0;
    } else if (type == bool) {
      return _sharedPrefLibObj.getBool(key.name) ?? false;
    }
  }

//
//   // خزن اللغة تاعت التطبيق سواء و هو مطفي او ش  غال احفظ هي الحالة
//   /// Language
//   Future<void> setLanguage(String language) async {
//     await _sharedPrefLibObj.setString(SpKeys.lang.name, language);
//   }
//
//   String get getLanguage =>
//       _sharedPrefLibObj.getString(SpKeys.lang.name) ?? 'en';
// /// FcmToken
//   Future<void> setFcmToken({required String fcmToken}) async {
//     await _sharedPrefLibObj.setString(SpKeys.fcmToken.toString(), fcmToken);
//   }
//
//   String get getFcmToken =>
//       _sharedPrefLibObj.getString(SpKeys.fcmToken.toString()) ?? ' ';
// /// LoggedIn
//   Future<void> setLoggedIn() async {
//     await _sharedPrefLibObj.setBool(SpKeys.loggedIn.toString(), true);
//   }
//   bool get checkLoggedIn =>
//       _sharedPrefLibObj.getBool(SpKeys.loggedIn.toString()) ?? false;
//
//   /// UId
//   Future<void> setUId({required String id}) async {
//     await _sharedPrefLibObj.setString(SpKeys.uId.toString(), id);
//   }
//   String get getUId => _sharedPrefLibObj.getString(SpKeys.uId.toString()) ?? '';
// /// UserType
//   Future<void> setUserType({required String type}) async {
//     await _sharedPrefLibObj.setString(SpKeys.userType.toString(), type);
//   }
//
//   String get getUserType =>
//       _sharedPrefLibObj.getString(SpKeys.userType.toString()) ?? '';
// /// Username
//   Future<void> setUsername({required String username}) async {
//     await _sharedPrefLibObj.setString(SpKeys.username.toString(), username);
//   }
//
//   String get getUsername =>
//       _sharedPrefLibObj.getString(SpKeys.username.toString()) ?? '';
// /// Email
//   Future<void> setEmail({required String email}) async {
//     await _sharedPrefLibObj.setString(SpKeys.email.toString(), email);
//   }
//
//   String get getEmail =>
//       _sharedPrefLibObj.getString(SpKeys.email.toString()) ?? '';
// /// Avatar
//   Future<void> setAvatar({required String avatar}) async {
//     await _sharedPrefLibObj.setString(SpKeys.avatar.toString(), avatar);
//   }
//   String get getAvatar =>
//       _sharedPrefLibObj.getString(SpKeys.avatar.toString()) ?? '';
//
//
//   /// Mobile
//   Future<void> setMobile({required String mobile}) async {
//     await _sharedPrefLibObj.setString(SpKeys.mobile.toString(), mobile);
//   }
//   String get getMobile =>
//       _sharedPrefLibObj.getString(SpKeys.mobile.toString()) ?? '';
//
//   /// City
//   Future<void> setCityId({required int id})async{
//     await _sharedPrefLibObj.setInt(SpKeys.cityId.name, id);
//   }
//   int get getCityId => _sharedPrefLibObj.getInt(SpKeys.cityId.name) ?? -1;
//
//   /// Address
//   Future<void> setAddress({required String address})async{
//     await _sharedPrefLibObj.setString(SpKeys.address.name, address);
//   }
//   String get getAddress => _sharedPrefLibObj.getString(SpKeys.address.name) ?? '';
//

  /// logout
  Future<void> logout() async {
    await _sharedPrefLibObj.setString(SpKeys.fcmToken.name, '');
    await _sharedPrefLibObj.setBool(SpKeys.loggedIn.name, false);
  }
}
