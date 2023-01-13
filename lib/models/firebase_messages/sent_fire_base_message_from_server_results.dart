class SendFireBaseMessageFromServerBaseResults {
  late String? error;

  SendFireBaseMessageFromServerBaseResults({
    this.error,
  });

  SendFireBaseMessageFromServerBaseResults.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
