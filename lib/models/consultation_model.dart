import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ConsultationStatus {
  // قيد الانتظار
  waiting,

  // حذف الطلب من قبل المريض
  deleted,

  //  تم الرفض من ثبل الطبيب
  rejected,

  // قيد المراجعة
  inProgress,

  // تم تحويل الطلب للتوجه الى اقرب صيديلة
  transferred,

  // تم صرف الرشيتة من الصيدلية
  completed,
}

Color consultationStatusColor(String statusText){
  Color color = Colors.black;
  String text = '';
  ConsultationStatus status=ConsultationStatus.values.firstWhere((element) => element.name==statusText);
  switch (status) {
    case ConsultationStatus.waiting:
      color = Colors.blue;
      break;
    case ConsultationStatus.deleted:
      color = Colors.red;
      break;
    case ConsultationStatus.rejected:
      color = Colors.deepOrangeAccent;
      break;
    case ConsultationStatus.inProgress:
      color = Colors.yellowAccent;
      break;
    case ConsultationStatus.transferred:
      color = Colors.purple;
      break;
    case ConsultationStatus.completed:
      color = Colors.green;
      break;
  }
  return color;
}
/// context ==> Localization
String consultationStatusText(BuildContext context, String statusText){
  String text = '';
  ConsultationStatus status=ConsultationStatus.values.firstWhere((element) => element.name==statusText);
  switch (status) {
    case ConsultationStatus.waiting:
      text = 'Waiting';
      break;
    case ConsultationStatus.deleted:
      text = 'Deleted';
      break;
    case ConsultationStatus.rejected:
      text = 'Rejected';
      break;
    case ConsultationStatus.inProgress:
      text = 'InProgress';
      break;
    case ConsultationStatus.transferred:
      text = 'Transferred';
      break;
    case ConsultationStatus.completed:
      text = 'Completed';
      break;
  }
  return text;
}


class ConsultationModel {
  late String id;
  late String? patientUId;
  late String? majorId;
  late String? doctorUId;
  late String? note;
  late List<dynamic>? medicalReports;
  late Timestamp timestamp;
  late String? requestStatus;

  ConsultationModel();

  ConsultationModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    patientUId = map['patientUId'];
    majorId = map['majorId'];
    doctorUId = map['doctorUId'];
    note = map['note'];
    doctorUId = map['doctorUId'];
    doctorUId = map['doctorUId'];
    requestStatus = map['requestStatus'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['patientUId'] = patientUId;
    map['majorId'] = majorId;
    map['doctorUId'] = doctorUId;
    map['note'] = note;
    map['medicalReports'] = medicalReports;
    map['timestamp'] = timestamp;
    map['requestStatus'] = requestStatus;
    return map;
  }
}
