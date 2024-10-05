class DashBoardModel {
  dynamic status;
  DashBoardData? message;

  DashBoardModel({this.status, this.message});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new DashBoardData.fromJson(json['message']) : null;
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

class DashBoardData {
  dynamic currency;
  dynamic mainBalance;
  dynamic interestBalance;
  dynamic totalDeposit;
  dynamic totalEarn;
  dynamic totalPayout;
  dynamic totalReferralBonus;
  Roi? roi;
  dynamic investComplete;
  dynamic ticket;
  dynamic rankLevel;
  dynamic rankName;
  dynamic rankImage;
  dynamic userImage;
  List<Transaction>? transaction;

  DashBoardData(
      {this.currency,
        this.mainBalance,
        this.interestBalance,
        this.totalDeposit,
        this.totalEarn,
        this.totalPayout,
        this.totalReferralBonus,
        this.roi,
        this.investComplete,
        this.ticket,
        this.rankLevel,
        this.rankName,
        this.rankImage,
        this.userImage,
        this.transaction});

  DashBoardData.fromJson(Map<dynamic, dynamic> json) {
    currency = json['currency'];
    mainBalance = json['mainBalance'] ?? 0;
    interestBalance = json['interestBalance'] ?? 0;
    totalDeposit = json['totalDeposit'] ?? 0;
    totalEarn = json['totalEarn'] ?? 0;
    totalPayout = json['totalPayout'] ?? 0;
    totalReferralBonus = json['totalReferralBonus'] ?? 0;
    roi = json['roi'] != null ? new Roi.fromJson(json['roi']) : null;
    investComplete = json['investComplete'] ?? 0;
    ticket = json['ticket'] ?? 0;
    rankLevel = json['rankLevel'] ?? 0;
    rankName = json['rankName'] ?? 0;
    rankImage = json['rankImage'] ?? 0;
    userImage = json['userImage'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['currency'] = this.currency;
    data['mainBalance'] = this.mainBalance;
    data['interestBalance'] = this.interestBalance;
    data['totalDeposit'] = this.totalDeposit;
    data['totalEarn'] = this.totalEarn;
    data['totalPayout'] = this.totalPayout;
    data['totalReferralBonus'] = this.totalReferralBonus;
    if (this.roi != null) {
      data['roi'] = this.roi!.toJson();
    }
    data['investComplete'] = this.investComplete;
    data['ticket'] = this.ticket;
    data['rankLevel'] = this.rankLevel;
    data['rankName'] = this.rankName;
    data['rankImage'] = this.rankImage;
    data['userImage'] = this.userImage;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roi {
  dynamic totalInvestAmount;
  dynamic totalInvest;
  dynamic completed;

  Roi({this.totalInvestAmount, this.totalInvest, this.completed});

  Roi.fromJson(Map<dynamic, dynamic> json) {
    totalInvestAmount = json['totalInvestAmount'];
    totalInvest = json['totalInvest'];
    completed = json['completed'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['totalInvestAmount'] = this.totalInvestAmount;
    data['totalInvest'] = this.totalInvest;
    data['completed'] = this.completed;
    return data;
  }
}

class Transaction {
  dynamic amount;
  dynamic charge;
  dynamic trxType;
  dynamic balanceType;
  dynamic remarks;
  dynamic trxId;
  dynamic time;

  Transaction(
      {this.amount,
        this.charge,
        this.trxType,
        this.balanceType,
        this.remarks,
        this.trxId,
        this.time});

  Transaction.fromJson(Map<dynamic, dynamic> json) {
    amount = json['amount'];
    charge = json['charge'];
    trxType = json['trx_type'];
    balanceType = json['balance_type'];
    remarks = json['remarks'];
    trxId = json['trx_id'];
    time = json['time'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['amount'] = this.amount;
    data['charge'] = this.charge;
    data['trx_type'] = this.trxType;
    data['balance_type'] = this.balanceType;
    data['remarks'] = this.remarks;
    data['trx_id'] = this.trxId;
    data['time'] = this.time;
    return data;
  }
}

