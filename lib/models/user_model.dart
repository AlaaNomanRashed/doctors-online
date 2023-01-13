

class UserModel {
  late String uId;
  late String username;
  late String email;
  late String password;
  late String avatar;
  late String dob;
  late String mobile;
  late int? gender;

  /// 1=Male 2=Female
  late String type;
  late String majorId;
  late List<dynamic> medicalReports;
  late String address;
  late String fcmToken;
  late int cityId;

  UserModel();

  UserModel.fromMap(Map<String, dynamic> map) {
    uId = map['uId'];
    username = map['username'];
    email = map['email'];
    password = map['password'];
    avatar = map['avatar'];
    dob = map['dob'];
    mobile = map['mobile'];
    gender = map['gender'];
    type = map['type'];
    majorId = map['majorId'];
    medicalReports = map['medicalReports'];
    address = map['address'];
    fcmToken = map['fcmToken'];
    cityId = map['cityId'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['uId'] = uId;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    map['avatar'] = avatar;
    map['dob'] = dob;
    map['mobile'] = mobile;
    map['gender'] = gender;
    map['type'] = type;
    map['majorId'] = majorId;
    map['medicalReports'] = medicalReports;
    map['address'] = address;
    map['fcmToken'] = fcmToken;
    map['cityId'] = cityId;
    return map;
  }
}
