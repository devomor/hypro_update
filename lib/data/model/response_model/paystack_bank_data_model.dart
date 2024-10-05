class PayStackBankDataModel {
  dynamic status;
  PayStackBankData? message;

  PayStackBankDataModel({this.status, this.message});

  PayStackBankDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new PayStackBankData.fromJson(json['message']) : null;
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

class PayStackBankData {
  dynamic status;
  List<DropDownData>? data;

  PayStackBankData({this.status, this.data});

  PayStackBankData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DropDownData>[];
      json['data'].forEach((v) {
        data!.add(new DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic code;
  dynamic longcode;
  dynamic gateway;
  dynamic payWithBank;
  dynamic active;
  dynamic country;
  dynamic currency;
  dynamic type;
  dynamic isDeleted;
  dynamic createdAt;
  dynamic updatedAt;

  DropDownData(
      {this.id,
        this.name,
        this.slug,
        this.code,
        this.longcode,
        this.gateway,
        this.payWithBank,
        this.active,
        this.country,
        this.currency,
        this.type,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  DropDownData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    code = json['code'];
    longcode = json['longcode'];
    gateway = json['gateway'];
    payWithBank = json['pay_with_bank'];
    active = json['active'];
    country = json['country'];
    currency = json['currency'];
    type = json['type'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['code'] = this.code;
    data['longcode'] = this.longcode;
    data['gateway'] = this.gateway;
    data['pay_with_bank'] = this.payWithBank;
    data['active'] = this.active;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['type'] = this.type;
    data['is_deleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
