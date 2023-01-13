import 'message_data_request.dart';
import 'message_notification_request.dart';

class MessageBaseRequest {
  late List<String>? fcmTokens;
  late String? topic;
  late String? to;
  late MessageNotificationRequest? notification;
  late MessageDataRequest? data;

  MessageBaseRequest({
    required this.topic,
    required this.to,
    required this.fcmTokens,
    required this.notification,
    required this.data,
  });

  MessageBaseRequest.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    fcmTokens = json['registration_ids'].cast<String>();
    notification = json['notification'] != null
        ? MessageNotificationRequest.fromJson(json['notification'])
        : null;
    data =
        json['data'] != null ? MessageDataRequest.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (to == 'fcm') {
      data['registration_ids'] = fcmTokens;
    } else {
      data['to'] = '/topics/$topic';
    }

    if (notification != null) {
      data['notification'] = notification!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
