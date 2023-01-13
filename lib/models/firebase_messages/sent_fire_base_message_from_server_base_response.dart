
import 'package:doctors_online/models/firebase_messages/sent_fire_base_message_from_server_results.dart';

class SendFireBaseMessageFromServerBaseResponse {
  late int? multicastId;
  late int? success;
  late int? failure;
  late int? canonicalIds;
  late List<SendFireBaseMessageFromServerBaseResults>? results;

  SendFireBaseMessageFromServerBaseResponse({
    this.multicastId,
    this.success,
    this.failure,
    this.canonicalIds,
    this.results,
  });

  SendFireBaseMessageFromServerBaseResponse.fromJson(
      Map<String, dynamic> json) {
    multicastId = json['multicast_id'];
    success = json['success'];
    failure = json['failure'];
    canonicalIds = json['canonical_ids'];
    if (json['results'] != null) {
      results = <SendFireBaseMessageFromServerBaseResults>[];
      json['results'].forEach((v) {
        results!.add(SendFireBaseMessageFromServerBaseResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['multicast_id'] = multicastId;
    data['success'] = success;
    data['failure'] = failure;
    data['canonical_ids'] = canonicalIds;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
