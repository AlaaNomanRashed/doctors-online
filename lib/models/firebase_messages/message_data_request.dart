class MessageDataRequest {
  late String? msgId;

  MessageDataRequest({
    this.msgId,
  });

  MessageDataRequest.fromJson(Map<String, dynamic> json) {
    msgId = json['msgId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msgId'] = msgId;
    return data;
  }
}
