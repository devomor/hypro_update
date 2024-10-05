class BadgesModel {
  String? status;
  List<BadgesData>? message;

  BadgesModel({this.status, this.message});

  BadgesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <BadgesData>[];
      json['message'].forEach((v) {
        message!.add(new BadgesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BadgesData {
  dynamic rankIcon;
  dynamic rankLavel;
  dynamic description;
  dynamic minInvest;
  dynamic minDeposit;
  dynamic minEarning;
  dynamic isCurrentRank;

  BadgesData(
      {this.rankIcon,
        this.rankLavel,
        this.description,
        this.minInvest,
        this.minDeposit,
        this.minEarning,
        this.isCurrentRank});

  BadgesData.fromJson(Map<String, dynamic> json) {
    rankIcon = json['rank_icon'];
    rankLavel = json['rank_lavel'];
    description = json['description'];
    minInvest = json['min_invest'];
    minDeposit = json['min_deposit'];
    minEarning = json['min_earning'];
    isCurrentRank = json['is_current_rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank_icon'] = this.rankIcon;
    data['rank_lavel'] = this.rankLavel;
    data['description'] = this.description;
    data['min_invest'] = this.minInvest;
    data['min_deposit'] = this.minDeposit;
    data['min_earning'] = this.minEarning;
    data['is_current_rank'] = this.isCurrentRank;
    return data;
  }
}
