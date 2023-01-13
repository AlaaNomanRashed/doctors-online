class AppointmentModel{

  late String id;
  late String? note;
  late String? name;
  late List<dynamic>  times;
  late String? patientUId;
  late String? pharmacyUId;

  AppointmentModel();

  AppointmentModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    note = map['note'];
    name = map['name'];
    times = map['times'];
    patientUId = map['patientUId'];
    pharmacyUId = map['pharmacyUId'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['note'] = note;
    map['name'] = name;
    map['times'] = times;
    map['patientUId'] = patientUId;
    map['pharmacyUId'] = pharmacyUId;
    return map;
  }
}