import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsModel{
  late String id;
  late String title;
  late String body;
  late List<dynamic> receiverUId ;
  late Timestamp timestamp;

  NotificationsModel();

  NotificationsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    receiverUId = map['receiverUId'];
    timestamp = map['timestamp'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['receiverUId'] = receiverUId;
    map['timestamp'] = timestamp;
    return map;
  }
}