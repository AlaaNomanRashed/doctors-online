class CityModel{
  late int id;
late int? parentId;
late String? nameAr;
late String? nameEn;

  CityModel();


  CityModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    parentId = map['parentId'];
    nameAr = map['nameAr'];
    nameEn = map['nameEn'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id']=id;
    map['parentId']=parentId;
    map['nameAr']=nameAr;
    map['nameEn']=nameEn;
    return map;
  }
}