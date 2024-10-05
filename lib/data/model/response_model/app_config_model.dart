class AppConfigModel {
  dynamic status;
  ConfigData? message;

  AppConfigModel({this.status, this.message});

  AppConfigModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new ConfigData.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class ConfigData {
  dynamic baseColor;
  dynamic version;
  dynamic appBuild;
  dynamic isMajor;
  dynamic paymentSuccessUrl;
  dynamic paymentFailedUrl;

  ConfigData(
      {this.baseColor,
        this.version,
        this.appBuild,
        this.isMajor,
        this.paymentSuccessUrl,
        this.paymentFailedUrl});

  ConfigData.fromJson(Map<String, dynamic> json) {
    baseColor = json['baseColor'];
    version = json['version'];
    appBuild = json['appBuild'];
    isMajor = json['isMajor'];
    paymentSuccessUrl = json['paymentSuccessUrl'];
    paymentFailedUrl = json['paymentFailedUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseColor'] = this.baseColor;
    data['version'] = this.version;
    data['appBuild'] = this.appBuild;
    data['isMajor'] = this.isMajor;
    data['paymentSuccessUrl'] = this.paymentSuccessUrl;
    data['paymentFailedUrl'] = this.paymentFailedUrl;
    return data;
  }
}
