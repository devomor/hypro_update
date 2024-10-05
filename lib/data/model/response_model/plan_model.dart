class PlanModel {
  dynamic status;
  PlanData? message;

  PlanModel({this.status, this.message});

  PlanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? new PlanData.fromJson(json['message']) : null;
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

class PlanData {
  dynamic title;
  dynamic subTitle;
  dynamic shortDetails;
  dynamic balance;
  dynamic interestBalance;
  List<Plans>? plans;

  PlanData(
      {this.title,
      this.subTitle,
      this.shortDetails,
      this.balance,
      this.interestBalance,
      this.plans});

  PlanData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subTitle = json['sub_title'];
    shortDetails = json['short_details'];
    balance = json['balance'];
    interestBalance = json['interest_balance'];
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['short_details'] = this.shortDetails;
    data['balance'] = this.balance;
    data['interest_balance'] = this.interestBalance;
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  dynamic id;
  dynamic name;
  dynamic min;
  dynamic max;
  dynamic price;
  dynamic profit;
  dynamic profitType;
  dynamic profitFor;
  dynamic capitalBack;
  dynamic capitalEarning;

  Plans(
      {this.id,
      this.name,
      this.min,
      this.max,
      this.price,
      this.profit,
      this.profitType,
      this.profitFor,
      this.capitalBack,
      this.capitalEarning});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    min = json['min'];
    max = json['max'];
    price = json['price'];
    profit = json['profit'];
    profitType = json['profitType'];
    profitFor = json['profitFor'];
    capitalBack = json['capitalBack'];
    capitalEarning = json['capitalEarning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['min'] = this.min;
    data['max'] = this.max;
    data['price'] = this.price;
    data['profit'] = this.profit;
    data['profitType'] = this.profitType;
    data['profitFor'] = this.profitFor;
    data['capitalBack'] = this.capitalBack;
    data['capitalEarning'] = this.capitalEarning;
    return data;
  }
}
