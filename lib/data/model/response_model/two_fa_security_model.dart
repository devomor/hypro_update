class TwoFactorSecurityModel {
  dynamic status;
  TwoFaSecurityData? message;

  TwoFactorSecurityModel({this.status, this.message});

  TwoFactorSecurityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new TwoFaSecurityData.fromJson(json['message']) : null;
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

class TwoFaSecurityData {
  dynamic twoFactorEnable;
  dynamic secret;
  dynamic qrCodeUrl;
  dynamic previousCode;
  dynamic previousQR;
  dynamic downloadApp;

  TwoFaSecurityData(
      {this.twoFactorEnable,
        this.secret,
        this.qrCodeUrl,
        this.previousCode,
        this.previousQR,
        this.downloadApp});

  TwoFaSecurityData.fromJson(Map<String, dynamic> json) {
    twoFactorEnable = json['twoFactorEnable'];
    secret = json['secret'];
    qrCodeUrl = json['qrCodeUrl'];
    previousCode = json['previousCode'];
    previousQR = json['previousQR'];
    downloadApp = json['downloadApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['twoFactorEnable'] = this.twoFactorEnable;
    data['secret'] = this.secret;
    data['qrCodeUrl'] = this.qrCodeUrl;
    data['previousCode'] = this.previousCode;
    data['previousQR'] = this.previousQR;
    data['downloadApp'] = this.downloadApp;
    return data;
  }
}
