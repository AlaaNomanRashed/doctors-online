import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/models/appointment_model.dart';
import '../../shared_preferences/shared_preferences.dart';

class AppointmentsFbController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(AppointmentModel appointmentModel) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentModel.id)
        .set(appointmentModel.toMap());
  }

  Stream<QuerySnapshot<AppointmentModel>> readPatientAppointments() async* {
    yield* _firestore
        .collection('appointments')
        .where('patientUId', isEqualTo: SharedPreferencesController().getter(type: String, key: SpKeys.uId).toString()).withConverter<AppointmentModel>(
      fromFirestore: (snapshot, options) =>AppointmentModel.fromMap(snapshot.data()!) ,
      toFirestore: (value, options) =>value.toMap() ,
    )
        .snapshots();
  }

Future<void> update(AppointmentModel appointmentModel) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentModel.id)
        .update({});
  }

  Future<void> delete(AppointmentModel appointmentModel) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentModel.id)
        .delete();
  }

}
