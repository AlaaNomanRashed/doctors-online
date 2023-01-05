class MajorModel{

  late String id;
  late int? parentId;
  late String? majorAr;
  late String? majorEn;

  MajorModel();

  MajorModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    parentId = map['parentId'];
    majorAr = map['majorAr'];
    majorEn = map['majorEn'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['parentId'] = parentId;
    map['majorAr'] = majorAr;
    map['majorEn'] = majorEn;
    return map;
  }
}