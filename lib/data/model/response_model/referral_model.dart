// To parse this JSON data, do
//
//     final referralModel = referralModelFromJson(jsonString);

import 'dart:convert';

ReferralModel referralModelFromJson(String str) => ReferralModel.fromJson(json.decode(str));

String referralModelToJson(ReferralModel data) => json.encode(data.toJson());

class ReferralModel {
  dynamic status;
  ReferralData? message;

  ReferralModel({
    this.status,
    this.message,
  });

  factory ReferralModel.fromJson(Map<String, dynamic> json) => ReferralModel(
    status: json["status"],
    message: json["message"] == null ? null : ReferralData.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message?.toJson(),
  };
}

class ReferralData {
  dynamic referralLink;
  Map<dynamic, List<Referral>>? referrals;

  ReferralData({
    this.referralLink,
    this.referrals,
  });

  factory ReferralData.fromJson(Map<String, dynamic> json) => ReferralData(
    referralLink: json["referralLink"],
      referrals: Map.from(json["referrals"]!).map((k, v) => MapEntry<dynamic, List<Referral>>(k, List<Referral>.from(v.map((x) => Referral.fromJson(x))??{}))),
  );

  Map<String, dynamic> toJson() => {
    "referralLink": referralLink,
    "referrals": Map.from(referrals!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}

class Referral {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic phoneCode;
  dynamic phone;
  dynamic referralId;
  DateTime? createdAt;
  dynamic fullname;
  dynamic mobile;

  Referral({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.phoneCode,
    this.phone,
    this.referralId,
    this.createdAt,
    this.fullname,
    this.mobile,
  });

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    email: json["email"],
    phoneCode: json["phone_code"],
    phone: json["phone"],
    referralId: json["referral_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    fullname: json["fullname"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "phone_code": phoneCode,
    "phone": phone,
    "referral_id": referralId,
    "created_at": createdAt?.toIso8601String(),
    "fullname": fullname,
    "mobile": mobile,
  };
}
