import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/enums.dart';
import 'package:doctors_online/models/consultation_model.dart';

import '../../shared_preferences/shared_preferences.dart';

class ConsultationsFbController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(ConsultationModel consultationModel) async {
    await _firestore
        .collection('consultations')
        .doc(consultationModel.id)
        .set(consultationModel.toMap());
  }

  Stream<QuerySnapshot<ConsultationModel>> readPatientConsultations() async* {
    yield* _firestore
        .collection('consultations')
        .where('patientUId', isEqualTo: SharedPreferencesController().getter(type: String, key: SpKeys.uId).toString()).withConverter<ConsultationModel>(
        fromFirestore: (snapshot, options) =>ConsultationModel.fromMap(snapshot.data()!) ,
        toFirestore: (value, options) =>value.toMap() ,
    )
        .snapshots();
  }










  Stream<QuerySnapshot<ConsultationModel>> readDoctorConsultations() async* {
    yield* _firestore
        .collection('consultations')
        .where('doctorUId', isEqualTo: SharedPreferencesController().getter(type: String, key: SpKeys.uId).toString()).withConverter<ConsultationModel>(
      fromFirestore: (snapshot, options) =>ConsultationModel.fromMap(snapshot.data()!) ,
      toFirestore: (value, options) =>value.toMap() ,
    )
        .snapshots();
  }









  Stream<QuerySnapshot<ConsultationModel>> readPharmacyConsultations() async* {
    yield* _firestore
        .collection('consultations')
        .where('pharmacyUId', isEqualTo: SharedPreferencesController().getter(type: String, key: SpKeys.uId).toString()).withConverter<ConsultationModel>(
      fromFirestore: (snapshot, options) =>ConsultationModel.fromMap(snapshot.data()!) ,
      toFirestore: (value, options) =>value.toMap() ,
    )
        .snapshots();
  }





  Future<void> update(ConsultationModel consultationModel) async {
    await _firestore
        .collection('consultations')
        .doc(consultationModel.id)
        .update({});
  }

  Future<void> delete(ConsultationModel consultationModel) async {
    await _firestore
        .collection('consultations')
        .doc(consultationModel.id)
        .delete();
  }


  Future<void> updateConsultation(ConsultationStatus consultationStatus, String consultationId,
      {String pharmacyUId = ''})async{
await _firestore.collection('consultations').doc(consultationId).update({
  'requestStatus': consultationStatus.name,
  'pharmacyUId' :pharmacyUId
});
  }

}
