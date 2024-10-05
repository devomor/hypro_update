class PayoutBankFormModel {
  dynamic status;
  PayoutBankFormData? message;

  PayoutBankFormModel({this.status, this.message});

  PayoutBankFormModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new PayoutBankFormData.fromJson(json['message']) : null;
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

class PayoutBankFormData {
  Bank? bank;
  InputForm? inputForm;

  PayoutBankFormData({this.bank, this.inputForm});

  PayoutBankFormData.fromJson(Map<String, dynamic> json) {
    bank = json['bank'] != null ? new Bank.fromJson(json['bank']) : null;
    inputForm = json['input_form'] != null
        ? new InputForm.fromJson(json['input_form'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    if (this.inputForm != null) {
      data['input_form'] = this.inputForm!.toJson();
    }
    return data;
  }
}

class Bank {
  dynamic status;
  List<Data>? data;

  Bank({this.status, this.data});

  Bank.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  dynamic id;
  dynamic code;
  dynamic name;

  Data({this.id, this.code, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class InputForm {
  dynamic accountNumber;
  dynamic narration;
  dynamic reference;
  dynamic beneficiaryName;

  InputForm(
      {this.accountNumber,
        this.narration,
        this.reference,
        this.beneficiaryName});

  InputForm.fromJson(Map<String, dynamic> json) {
    accountNumber = json['account_number'];
    narration = json['narration'];
    reference = json['reference'];
    beneficiaryName = json['beneficiary_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_number'] = this.accountNumber;
    data['narration'] = this.narration;
    data['reference'] = this.reference;
    data['beneficiary_name'] = this.beneficiaryName;
    return data;
  }
}
