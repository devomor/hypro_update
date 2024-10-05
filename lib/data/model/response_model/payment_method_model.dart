import 'dart:convert';

PaymentMethodModel paymentMethodModelFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
  dynamic status;
  PaymentGatewayData? message;

  PaymentMethodModel({
    this.status,
    this.message,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        status: json["status"],
        message: json["message"] == null
            ? null
            : PaymentGatewayData.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message?.toJson(),
      };
}

class PaymentGatewayData {
  dynamic baseCurrency;
  dynamic baseSymbol;
  List<Gateway>? gateways;

  PaymentGatewayData({
    this.baseCurrency,
    this.baseSymbol,
    this.gateways,
  });

  factory PaymentGatewayData.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayData(
        baseCurrency: json["baseCurrency"],
        baseSymbol: json["baseSymbol"],
        gateways: json["gateways"] == null
            ? null
            : List<Gateway>.from(
                json["gateways"].map((x) => Gateway.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "baseCurrency": baseCurrency,
        "baseSymbol": baseSymbol,
        "gateways": gateways == null
            ? null
            : List<dynamic>.from(gateways!.map((x) => x.toJson())),
      };
}

class Gateway {
  dynamic id;
  dynamic name;
  dynamic code;
  dynamic currency;
  dynamic symbol;
  Map<dynamic, dynamic>? parameters; // Store dynamic parameters as a map
  ExtraParameters? extraParameters;
  dynamic conventionRate;
  dynamic currencies;
  dynamic minAmount;
  dynamic maxAmount;
  dynamic percentageCharge;
  dynamic fixedCharge;
  dynamic status;
  dynamic note;
  dynamic image;
  dynamic sortBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Gateway({
    this.id,
    this.name,
    this.code,
    this.currency,
    this.symbol,
    this.parameters,
    this.extraParameters,
    this.conventionRate,
    this.currencies,
    this.minAmount,
    this.maxAmount,
    this.percentageCharge,
    this.fixedCharge,
    this.status,
    this.note,
    this.image,
    this.sortBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        currency: json["currency"],
        symbol: json["symbol"],
        parameters: json["parameters"] is Map
            ? json["parameters"]
            : {},
        extraParameters: json["extra_parameters"] == null
            ? null
            : ExtraParameters.fromJson(json["extra_parameters"]),
        conventionRate: json["convention_rate"],
        currencies: json["currencies"],
        minAmount: json["min_amount"],
        maxAmount: json["max_amount"],
        percentageCharge: json["percentage_charge"],
        fixedCharge: json["fixed_charge"],
        status: json["status"],
        note: json["note"],
        image: json["image"],
        sortBy: json["sort_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "id": id,
      "name": name,
      "code": code,
      "currency": currency,
      "symbol": symbol,
      "extra_parameters": extraParameters?.toJson(),
      "convention_rate": conventionRate,
      "currencies": currencies,
      "min_amount": minAmount,
      "max_amount": maxAmount,
      "percentage_charge": percentageCharge,
      "fixed_charge": fixedCharge,
      "status": status,
      "note": note,
      "image": image,
      "sort_by": sortBy,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };

    // Add parameters to the data map if they exist
    if (parameters != null) {
      data["parameters"] = parameters;
    }

    return data;
  }
}

class ExtraParameters {
  dynamic cron;
  dynamic ipnUrl;
  dynamic webhook;
  dynamic paymentNotificationUrl;
  dynamic finishRedirectUrl;
  dynamic unfinishRedirectUrl;
  dynamic errorRedirectUrl;
  dynamic callback;
  dynamic status;
  dynamic approvedUrl;

  ExtraParameters({
    this.cron,
    this.ipnUrl,
    this.webhook,
    this.paymentNotificationUrl,
    this.finishRedirectUrl,
    this.unfinishRedirectUrl,
    this.errorRedirectUrl,
    this.callback,
    this.status,
    this.approvedUrl,
  });

  factory ExtraParameters.fromJson(Map<String, dynamic> json) =>
      ExtraParameters(
        cron: json["cron"],
        ipnUrl: json["ipn_url"],
        webhook: json["webhook"],
        paymentNotificationUrl: json["payment_notification_url"],
        finishRedirectUrl: json["finish redirect_url"],
        unfinishRedirectUrl: json["unfinish redirect_url"],
        errorRedirectUrl: json["error redirect_url"],
        callback: json["callback"],
        status: json["status"],
        approvedUrl: json["approved_url"],
      );

  Map<String, dynamic> toJson() => {
        "cron": cron,
        "ipn_url": ipnUrl,
        "webhook": webhook,
        "payment_notification_url": paymentNotificationUrl,
        "finish redirect_url": finishRedirectUrl,
        "unfinish redirect_url": unfinishRedirectUrl,
        "error redirect_url": errorRedirectUrl,
        "callback": callback,
        "status": status,
        "approved_url": approvedUrl,
      };
}

class AccountNumber {
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;

  AccountNumber({
    this.fieldName,
    this.fieldLevel,
    this.type,
    this.validation,
  });

  factory AccountNumber.fromJson(Map<String, dynamic> json) => AccountNumber(
        fieldName: json["field_name"],
        fieldLevel: json["field_level"],
        type: json["type"],
        validation: json["validation"],
      );

  Map<String, dynamic> toJson() => {
        "field_name": fieldName,
        "field_level": fieldLevel,
        "type": type,
        "validation": validation,
      };
}
