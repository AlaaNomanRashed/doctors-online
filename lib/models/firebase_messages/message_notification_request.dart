class MessageNotificationRequest {
  late String? title;
  late String? body;
  late String? sound;

  MessageNotificationRequest({
    this.title,
    this.body,
    this.sound,
  });

  MessageNotificationRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['sound'] = sound;
    return data;
  }
}
