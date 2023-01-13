import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import 'package:doctors_online/enums.dart';

class UserFbController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel userModel) async {
    await _firestore
        .collection('users')
        .doc(userModel.uId)
        .set(userModel.toMap());
  }

  Future<UserModel?> getOneUser(String uId) async {
    var data = await _firestore
        .collection('users')
        .doc(uId)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .get();
    return data.data();
  }

  Future<List<UserModel>> getPharmaciesByCity(int cityId) async {
   var data = await _firestore
        .collection('users')
        .where('type', isEqualTo: 'pharmacy')
        .where('cityId', isEqualTo: cityId).withConverter<UserModel>(
       fromFirestore: (snapshot, options) => UserModel.fromMap(snapshot.data()!) ,
       toFirestore: (value, options) => value.toMap(),
   )
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  Stream<QuerySnapshot> readUser() async* {
    yield* _firestore
        .collection('users')
        .where('uId',
            isEqualTo: SharedPreferencesController()
                .getter(type: String, key: SpKeys.uId)
                .toString())
        .snapshots();
  }

  Future<void> addNewFile(String image) async {
    await _firestore
        .collection('users')
        .doc(SharedPreferencesController()
            .getter(type: String, key: SpKeys.uId)
            .toString())
        .update({
      'medicalReports': FieldValue.arrayUnion([image]),
    });
  }

  Future<void> deleteFile(String image) async {
    _firestore
        .collection('users')
        .doc(SharedPreferencesController()
            .getter(type: String, key: SpKeys.uId)
            .toString())
        .update({
      'medicalReports': FieldValue.arrayRemove([image]),
    });
  }

  Future<List<UserModel>?> getUsersByType({required UserTypes types}) async {
    try {
      var data = await _firestore
          .collection('users')
          .where('type', isEqualTo: types.name)
          .get();
      return data.docs.map((e) => UserModel.fromMap(e.data())).toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    await _firestore.collection('users').doc(userModel.uId).update({
      'username': userModel.username,
      'mobile': userModel.mobile,
      'avatar': userModel.avatar,
    });
  }

  Future<void> updateFCMToken(String uId, String fcm) async {
    await _firestore.collection('users').doc(uId).update({'fcmToken': fcm});
  }

  Future<void> deleteUser(UserModel userModel) async {
    await _firestore.collection('users').doc(userModel.uId).delete();
  }
}
