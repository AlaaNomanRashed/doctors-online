import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      color = Colors.red;
      break;
    case ConsultationStatus.inProgress:
      color = Colors.orange;
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
      text = AppLocalizations.of(context)!.waiting;
      break;
    case ConsultationStatus.deleted:
      text = AppLocalizations.of(context)!.deleted;
      break;
    case ConsultationStatus.rejected:
      text = AppLocalizations.of(context)!.rejected;
      break;
    case ConsultationStatus.inProgress:
      text = AppLocalizations.of(context)!.inProgress;
      break;
    case ConsultationStatus.transferred:
      text = AppLocalizations.of(context)!.transferred;
      break;
    case ConsultationStatus.completed:
      text = AppLocalizations.of(context)!.completed;
      break;
  }
  return text;
}


class ConsultationModel {
  late String id;
  late String? patientUId;
  late String? majorId;
  late String? doctorUId;
  late String? pharmacyUId;
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
    pharmacyUId = map['pharmacyUId'];
    note = map['note'];
    medicalReports = map['medicalReports'];
    timestamp = map['timestamp'];
    requestStatus = map['requestStatus'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['patientUId'] = patientUId;
    map['majorId'] = majorId;
    map['doctorUId'] = doctorUId;
    map['pharmacyUId'] = pharmacyUId;
    map['note'] = note;
    map['medicalReports'] = medicalReports;
    map['timestamp'] = timestamp;
    map['requestStatus'] = requestStatus;
    return map;
  }
}
