// To parse this JSON data, do
//
//     final payoutHistorySearchModel = payoutHistorySearchModelFromJson(jsonString);

import 'dart:convert';

PayoutHistorySearchModel payoutHistorySearchModelFromJson(String str) =>
    PayoutHistorySearchModel.fromJson(json.decode(str));

String payoutHistorySearchModelToJson(PayoutHistorySearchModel data) =>
    json.encode(data.toJson());

class PayoutHistorySearchModel {
  dynamic status;
  PayoutHistorySearchData? message;

  PayoutHistorySearchModel({
    this.status,
    this.message,
  });

  factory PayoutHistorySearchModel.fromJson(Map<String, dynamic> json) =>
      PayoutHistorySearchModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : PayoutHistorySearchData.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
      };
}

class PayoutHistorySearchData {
  dynamic currentPage;
  List<Data>? data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  PayoutHistorySearchData({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PayoutHistorySearchData.fromJson(Map<String, dynamic> json) =>
      PayoutHistorySearchData(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Data {
  dynamic transactionId;
  dynamic gateway;
  dynamic amount;
  dynamic charge;
  dynamic currency;
  dynamic status;
  dynamic time;
  dynamic adminFeedback;
  dynamic paymentInformation;

  Data({
    this.transactionId,
    this.gateway,
    this.amount,
    this.charge,
    this.currency,
    this.status,
    this.time,
    this.adminFeedback,
    this.paymentInformation,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transactionId: json["transactionId"],
        gateway: json["gateway"],
        amount: json["amount"],
        charge: json["charge"],
        currency: json["currency"],
        status: json["status"]!,
        time: json["time"],
        adminFeedback: json["adminFeedback"],
        paymentInformation: json["paymentInformation"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "gateway": gateway,
        "amount": amount,
        "charge": charge,
        "currency": currency,
        "status": status,
        "time": time,
        "adminFeedback": adminFeedback,
        "paymentInformation": paymentInformation,
      };
}

class PaymentInformationClass {
  dynamic network;
  dynamic address;
  dynamic amount;
  dynamic cryptoAddress;
  dynamic receiver;
  dynamic recipientType;
  dynamic bankName;
  dynamic yourAddress;
  dynamic transactionProve;

  PaymentInformationClass({
    this.network,
    this.address,
    this.amount,
    this.cryptoAddress,
    this.receiver,
    this.recipientType,
    this.bankName,
    this.yourAddress,
    this.transactionProve,
  });

  factory PaymentInformationClass.fromJson(Map<String, dynamic> json) =>
      PaymentInformationClass(
        network: json["network"],
        address: json["address"],
        amount: json["amount"]?.toDouble(),
        cryptoAddress: json["crypto_address"],
        receiver: json["receiver"],
        recipientType: json["recipient_type"],
        bankName: json["bank_name"],
        yourAddress: json["your_address"],
        transactionProve: json["transaction_prove"],
      );

  Map<String, dynamic> toJson() => {
        "network": network,
        "address": address,
        "amount": amount,
        "crypto_address": cryptoAddress,
        "receiver": receiver,
        "recipient_type": recipientType,
        "bank_name": bankName,
        "your_address": yourAddress,
        "transaction_prove": transactionProve,
      };
}

enum Status { PENDING }

final statusValues = EnumValues({"Pending": Status.PENDING});

class Link {
  dynamic url;
  dynamic label;
  dynamic active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
