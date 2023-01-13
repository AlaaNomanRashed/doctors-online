import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/firebase_messages/message_base_request.dart';
import '../models/firebase_messages/message_data_request.dart';
import '../models/firebase_messages/message_notification_request.dart';
import '../models/firebase_messages/sent_fire_base_message_from_server_base_response.dart';



class SendFireBaseMessageFromServer {
  Future<void> sentMessage({
    required List<String> fcmTokens,
    required String title,
    required String body,
    String topic = '',
    String to = 'fcm',
    /* fcm, topic*/
  }) async {
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var response = await http.post(
      url,
      body: jsonEncode(MessageBaseRequest(
        topic: topic,
        to: to,
        fcmTokens: fcmTokens,

        /// FCM Token(s) of the Receiver(s) of the Notification
        notification: MessageNotificationRequest(
          title: title,
          body: body,
          sound: 'default',
        ),
        data: MessageDataRequest(msgId: ''),
      ).toJson()),
      headers: {
        /// Authorization: Bearer + FireBase Server Key (FireBase Console > Selected Project > Project Settings > Cloud Messaging > Cloud Messaging API)
        'Authorization':
            'Bearer AAAAm90I4CE:APA91bHJidmPPeoUghpsqKKwwX4axTqvjWgL97q_7cMFMEhxFSoFdGQNQOlkaojL4S3NjtUg1sjnKQdO_RNjH8YzgUIBaB2kPwzA83MONxj-QRqrAuPryclsSgKGua0izOICGfTDsbKe',
        'Accept': '*/*',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      },
    );

    if (response.statusCode == 200) {
      SendFireBaseMessageFromServerBaseResponse.fromJson(
          jsonDecode(response.body));
    } else if (response.statusCode == 401) {}
  }
}
