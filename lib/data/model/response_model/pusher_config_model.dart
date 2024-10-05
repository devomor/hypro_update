class PusherConfigModel {
  dynamic status;
  dynamic message; // Allow dynamic type for 'message'

  PusherConfigModel({this.status, this.message});

  factory PusherConfigModel.fromJson(Map<String, dynamic> json) {
    return PusherConfigModel(
      status: json['status'],
      message: _parseMessage(json['message']),
    );
  }

  static _parseMessage(dynamic message) {
    // Check if 'message' is a String, and parse accordingly
    if (message is String) {
      // Handle the case where 'message' is a String
      // You might want to return a default value or handle it in a way that makes sense for your app
      return PusherConfigData(); // or return a default value
    } else if (message is Map<String, dynamic>) {
      // Handle the case where 'message' is a Map<String, dynamic>
      return PusherConfigData.fromJson(message);
    } else {
      // Handle other cases or return a default value
      return PusherConfigData(); // or return a default value
    }
  }
}

class PusherConfigData {
  dynamic apiKey;
  dynamic cluster;
  dynamic channel;
  dynamic event;

  PusherConfigData({this.apiKey, this.cluster, this.channel, this.event});

  factory PusherConfigData.fromJson(Map<String, dynamic> json) {
    return PusherConfigData(
      apiKey: json['apiKey'] ?? "",
      cluster: json['cluster'] ?? "",
      channel: json['channel'] ?? "",
      event: json['event'] ?? "",
    );
  }
}
