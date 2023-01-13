import 'package:cloud_firestore/cloud_firestore.dart';
import '../../enums.dart';
import '../../models/notifications_model.dart';
import '../../shared_preferences/shared_preferences.dart';

class NotificationFbController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(NotificationsModel notifications) async {
    await _firestore
        .collection('notifications')
        .doc(notifications.id)
        .set(notifications.toMap());
  }

  Stream<QuerySnapshot<NotificationsModel>> read() async* {
    yield* _firestore
        .collection('notifications')
        .where('receiverUId',
            arrayContains: SharedPreferencesController()
                .getter(type: String, key: SpKeys.uId)
                .toString())
         .orderBy('timestamp',descending: true)
        .withConverter<NotificationsModel>(
          fromFirestore: (snapshot, options) =>
              NotificationsModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .snapshots();
  }

  Future<void> delete(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }
}
