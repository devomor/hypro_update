// To parse this JSON data, do
//
//     final payoutModel = payoutModelFromJson(jsonString);

import 'dart:convert';

PayoutModel payoutModelFromJson(String str) => PayoutModel.fromJson(json.decode(str));

String payoutModelToJson(PayoutModel data) => json.encode(data.toJson());

class PayoutModel {
  dynamic status;
  PayoutData? message;

  PayoutModel({
    this.status,
    this.message,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) => PayoutModel(
    status: json["status"],
    message: json["message"] == null ? null : PayoutData.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message?.toJson(),
  };
}

class PayoutData {
  dynamic balance;
  dynamic depositAmount;
  dynamic interestAmount;
  dynamic interestBalance;
  List<Gateway>? gateways;
  List<dynamic>? openDaysList;
  dynamic today;
  dynamic isOffDay;

  PayoutData({
    this.balance,
    this.depositAmount,
    this.interestAmount,
    this.interestBalance,
    this.gateways,
    this.openDaysList,
    this.today,
    this.isOffDay,
  });

  factory PayoutData.fromJson(Map<String, dynamic> json) => PayoutData(
    balance: json["balance"],
    depositAmount: json["depositAmount"],
    interestAmount: json["interestAmount"],
    interestBalance: json["interest_balance"],
    gateways: json["gateways"] == null ? [] : List<Gateway>.from(json["gateways"]!.map((x) => Gateway.fromJson(x))),
    openDaysList: json["openDaysList"] == null ? [] : List<String>.from(json["openDaysList"]!.map((x) => x)),
    today: json["today"],
    isOffDay: json["isOffDay"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "depositAmount": depositAmount,
    "interestAmount": interestAmount,
    "interest_balance": interestBalance,
    "gateways": gateways == null ? [] : List<dynamic>.from(gateways!.map((x) => x.toJson())),
    "openDaysList": openDaysList == null ? [] : List<dynamic>.from(openDaysList!.map((x) => x)),
    "today": today,
    "isOffDay": isOffDay,
  };
}

class Gateway {
  dynamic id;
  dynamic name;
  dynamic image;
  dynamic currencySymbol;
  dynamic currency;
  dynamic minimumAmount;
  dynamic maximumAmount;
  dynamic fixedCharge;
  dynamic percentCharge;
  dynamic dynamicForm;
  dynamic bankName;
  dynamic supportedCurrency;
  dynamic convertRate;
  dynamic isAutomatic;

  Gateway({
    this.id,
    this.name,
    this.image,
    this.currencySymbol,
    this.currency,
    this.minimumAmount,
    this.maximumAmount,
    this.fixedCharge,
    this.percentCharge,
    this.dynamicForm,
    this.bankName,
    this.supportedCurrency,
    this.convertRate,
    this.isAutomatic,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) =>
      Gateway(
        id : json["id"],
        name: json["name"],
        image: json["image"],
        currencySymbol: json["currencySymbol"],
        currency: json["currency"],
        minimumAmount: json["minimumAmount"],
        maximumAmount: json["maximumAmount"],
        fixedCharge: json["fixedCharge"],
        percentCharge: json["percentCharge"],
        dynamicForm: json["dynamicForm"],
        bankName: json["bankName"],
        supportedCurrency: json["supportedCurrency"],
        convertRate: json["convertRate"],
        isAutomatic: json["isAutomatic"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id" : id,
        "name": name,
        "image": image,
        "currencySymbol": currencySymbol,
        "currency": currency,
        "minimumAmount": minimumAmount,
        "maximumAmount": maximumAmount,
        "fixedCharge": fixedCharge,
        "percentCharge": percentCharge,
        "dynamicForm": dynamicForm,
        "bankName": bankName,
        "supportedCurrency": supportedCurrency,
        "convertRate": convertRate,
        "isAutomatic": isAutomatic,
      };
}

class ConvertRateClass {
  dynamic usd;
  dynamic kes;
  dynamic ghs;
  dynamic ngn;
  dynamic gbp;
  dynamic eur;
  dynamic tzs;
  dynamic inr;
  dynamic zar;
  dynamic bnb;
  dynamic btc;
  dynamic xrp;
  dynamic eth;
  dynamic eth2;
  dynamic usdt;
  dynamic bch;
  dynamic ltc;
  dynamic xmr;
  dynamic ton;
  dynamic aud;
  dynamic brl;
  dynamic cad;
  dynamic czk;
  dynamic dkk;
  dynamic hkd;
  dynamic huf;
  dynamic ils;
  dynamic jpy;
  dynamic myr;
  dynamic mxn;
  dynamic twd;
  dynamic nzd;
  dynamic nok;
  dynamic php;
  dynamic pln;
  dynamic rub;
  dynamic sgd;
  dynamic sek;
  dynamic chf;
  dynamic thb;

  ConvertRateClass({
    this.usd,
    this.kes,
    this.ghs,
    this.ngn,
    this.gbp,
    this.eur,
    this.tzs,
    this.inr,
    this.zar,
    this.bnb,
    this.btc,
    this.xrp,
    this.eth,
    this.eth2,
    this.usdt,
    this.bch,
    this.ltc,
    this.xmr,
    this.ton,
    this.aud,
    this.brl,
    this.cad,
    this.czk,
    this.dkk,
    this.hkd,
    this.huf,
    this.ils,
    this.jpy,
    this.myr,
    this.mxn,
    this.twd,
    this.nzd,
    this.nok,
    this.php,
    this.pln,
    this.rub,
    this.sgd,
    this.sek,
    this.chf,
    this.thb,
  });

  factory ConvertRateClass.fromJson(Map<String, dynamic> json) => ConvertRateClass(
    usd: json["USD"],
    kes: json["KES"],
    ghs: json["GHS"],
    ngn: json["NGN"],
    gbp: json["GBP"],
    eur: json["EUR"],
    tzs: json["TZS"],
    inr: json["INR"],
    zar: json["ZAR"],
    bnb: json["BNB"],
    btc: json["BTC"],
    xrp: json["XRP"],
    eth: json["ETH"],
    eth2: json["ETH2"],
    usdt: json["USDT"],
    bch: json["BCH"],
    ltc: json["LTC"],
    xmr: json["XMR"],
    ton: json["TON"],
    aud: json["AUD"],
    brl: json["BRL"],
    cad: json["CAD"],
    czk: json["CZK"],
    dkk: json["DKK"],
    hkd: json["HKD"],
    huf: json["HUF"],
    ils: json["ILS"],
    jpy: json["JPY"],
    myr: json["MYR"],
    mxn: json["MXN"],
    twd: json["TWD"],
    nzd: json["NZD"],
    nok: json["NOK"],
    php: json["PHP"],
    pln: json["PLN"],
    rub: json["RUB"],
    sgd: json["SGD"],
    sek: json["SEK"],
    chf: json["CHF"],
    thb: json["THB"],
  );

  Map<String, dynamic> toJson() => {
    "USD": usd,
    "KES": kes,
    "GHS": ghs,
    "NGN": ngn,
    "GBP": gbp,
    "EUR": eur,
    "TZS": tzs,
    "INR": inr,
    "ZAR": zar,
    "BNB": bnb,
    "BTC": btc,
    "XRP": xrp,
    "ETH": eth,
    "ETH2": eth2,
    "USDT": usdt,
    "BCH": bch,
    "LTC": ltc,
    "XMR": xmr,
    "TON": ton,
    "AUD": aud,
    "BRL": brl,
    "CAD": cad,
    "CZK": czk,
    "DKK": dkk,
    "HKD": hkd,
    "HUF": huf,
    "ILS": ils,
    "JPY": jpy,
    "MYR": myr,
    "MXN": mxn,
    "TWD": twd,
    "NZD": nzd,
    "NOK": nok,
    "PHP": php,
    "PLN": pln,
    "RUB": rub,
    "SGD": sgd,
    "SEK": sek,
    "CHF": chf,
    "THB": thb,
  };
}

class DynamicFormClass {
  BankName? email;
  BankName? nidNumber;
  BankName? passportNumber;
  BankName? mazid;
  BankName? bankName;
  BankName? transactionProve;
  BankName? yourAddress;
  BankName? bayazid;
  AccountNumber? name;
  AccountNumber? dynamicFormEmail;
  AccountNumber? ifsc;
  AccountNumber? accountNumber;
  AccountNumber? cryptoAddress;
  AccountNumber? receiver;
  AccountNumber? network;
  AccountNumber? address;

  DynamicFormClass({
    this.email,
    this.nidNumber,
    this.passportNumber,
    this.mazid,
    this.bankName,
    this.transactionProve,
    this.yourAddress,
    this.bayazid,
    this.name,
    this.dynamicFormEmail,
    this.ifsc,
    this.accountNumber,
    this.cryptoAddress,
    this.receiver,
    this.network,
    this.address,
  });

  factory DynamicFormClass.fromJson(Map<String, dynamic> json) => DynamicFormClass(
    email: json["Email"] == null ? null : BankName.fromJson(json["Email"]),
    nidNumber: json["NIDNumber"] == null ? null : BankName.fromJson(json["NIDNumber"]),
    passportNumber: json["PassportNumber"] == null ? null : BankName.fromJson(json["PassportNumber"]),
    mazid: json["Mazid"] == null ? null : BankName.fromJson(json["Mazid"]),
    bankName: json["BankName"] == null ? null : BankName.fromJson(json["BankName"]),
    transactionProve: json["TransactionProve"] == null ? null : BankName.fromJson(json["TransactionProve"]),
    yourAddress: json["YourAddress"] == null ? null : BankName.fromJson(json["YourAddress"]),
    bayazid: json["Bayazid"] == null ? null : BankName.fromJson(json["Bayazid"]),
    name: json["name"] == null ? null : AccountNumber.fromJson(json["name"]),
    dynamicFormEmail: json["email"] == null ? null : AccountNumber.fromJson(json["email"]),
    ifsc: json["ifsc"] == null ? null : AccountNumber.fromJson(json["ifsc"]),
    accountNumber: json["account_number"] == null ? null : AccountNumber.fromJson(json["account_number"]),
    cryptoAddress: json["crypto_address"] == null ? null : AccountNumber.fromJson(json["crypto_address"]),
    receiver: json["receiver"] == null ? null : AccountNumber.fromJson(json["receiver"]),
    network: json["network"] == null ? null : AccountNumber.fromJson(json["network"]),
    address: json["address"] == null ? null : AccountNumber.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "Email": email?.toJson(),
    "NIDNumber": nidNumber?.toJson(),
    "PassportNumber": passportNumber?.toJson(),
    "Mazid": mazid?.toJson(),
    "BankName": bankName?.toJson(),
    "TransactionProve": transactionProve?.toJson(),
    "YourAddress": yourAddress?.toJson(),
    "Bayazid": bayazid?.toJson(),
    "name": name?.toJson(),
    "email": dynamicFormEmail?.toJson(),
    "ifsc": ifsc?.toJson(),
    "account_number": accountNumber?.toJson(),
    "crypto_address": cryptoAddress?.toJson(),
    "receiver": receiver?.toJson(),
    "network": network?.toJson(),
    "address": address?.toJson(),
  };
}

class AccountNumber {
  dynamic name;
  dynamic label;
  Type? type;
  Validation? validation;

  AccountNumber({
    this.name,
    this.label,
    this.type,
    this.validation,
  });

  factory AccountNumber.fromJson(Map<String, dynamic> json) => AccountNumber(
    name: json["name"],
    label: json["label"],
    type: typeValues.map[json["type"]]!,
    validation: validationValues.map[json["validation"]]!,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "label": label,
    "type": typeValues.reverse[type],
    "validation": validationValues.reverse[validation],
  };
}

enum Type {
  TEXT
}

final typeValues = EnumValues({
  "text": Type.TEXT
});

enum Validation {
  REQUIRED
}

final validationValues = EnumValues({
  "required": Validation.REQUIRED
});

class BankName {
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;

  BankName({
    this.fieldName,
    this.fieldLevel,
    this.type,
    this.validation,
  });

  factory BankName.fromJson(Map<String, dynamic> json) => BankName(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
