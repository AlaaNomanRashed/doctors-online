class MajorModel{

  late String id;
  late int? doctorId;
  late String? majorAr;
  late String? majorEn;

  MajorModel();

  MajorModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    doctorId = map['doctorId'];
    majorAr = map['majorAr'];
    majorEn = map['majorEn'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['doctorId'] = doctorId;
    map['majorAr'] = majorAr;
    map['majorEn'] = majorEn;
    return map;
  }
}