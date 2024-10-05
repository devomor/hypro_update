class MyAccountModel {
  dynamic status;
  MyAccountData? message;

  MyAccountModel({this.status, this.message});

  MyAccountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] != null
        ? MyAccountData.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class MyAccountData {
  dynamic userImage;
  dynamic username;
  dynamic userLevel;
  dynamic userRankName;
  dynamic userJoinDate;
  dynamic userFirstName;
  dynamic userLastName;
  dynamic userUsername;
  dynamic userEmail;
  dynamic userPhone;
  dynamic userLanguageId;
  dynamic userAddress;
  dynamic userIdentityVerifyFromShow;
  dynamic userIdentityVerifyMsg;
  dynamic userAddressVerifyFromShow;
  dynamic userAddressVerifyMsg;
  List<Languages>? languages;
  List<IdentityFormList>? identityFormList;

  MyAccountData({
    this.userImage,
    this.username,
    this.userLevel,
    this.userRankName,
    this.userJoinDate,
    this.userFirstName,
    this.userLastName,
    this.userUsername,
    this.userEmail,
    this.userPhone,
    this.userLanguageId,
    this.userAddress,
    this.userIdentityVerifyFromShow,
    this.userIdentityVerifyMsg,
    this.userAddressVerifyFromShow,
    this.userAddressVerifyMsg,
    this.languages,
    this.identityFormList,
  });

  MyAccountData.fromJson(Map<String, dynamic> json) {
    userImage = json['userImage'];
    username = json['username'];
    userLevel = json['userLevel'];
    userRankName = json['userRankName'];
    userJoinDate = json['userJoinDate'];
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
    userUsername = json['userUsername'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    userLanguageId = json['userLanguageId'];
    userAddress = json['userAddress'];
    userIdentityVerifyFromShow = json['userIdentityVerifyFromShow'];
    userIdentityVerifyMsg = json['userIdentityVerifyMsg'];
    userAddressVerifyFromShow = json['userAddressVerifyFromShow'];
    userAddressVerifyMsg = json['userAddressVerifyMsg'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    if (json['identityFormList'] != null) {
      identityFormList = <IdentityFormList>[];
      json['identityFormList'].forEach((v) {
        identityFormList!.add(IdentityFormList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userImage'] = userImage;
    data['username'] = username;
    data['userLevel'] = userLevel;
    data['userRankName'] = userRankName;
    data['userJoinDate'] = userJoinDate;
    data['userFirstName'] = userFirstName;
    data['userLastName'] = userLastName;
    data['userUsername'] = userUsername;
    data['userEmail'] = userEmail;
    data['userPhone'] = userPhone;
    data['userLanguageId'] = userLanguageId;
    data['userAddress'] = userAddress;
    data['userIdentityVerifyFromShow'] = userIdentityVerifyFromShow;
    data['userIdentityVerifyMsg'] = userIdentityVerifyMsg;
    data['userAddressVerifyFromShow'] = userAddressVerifyFromShow;
    data['userAddressVerifyMsg'] = userAddressVerifyMsg;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    if (identityFormList != null) {
      data['identityFormList'] =
          identityFormList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  dynamic id;
  dynamic name;
  dynamic shortName;
  dynamic flag;
  dynamic isActive;
  dynamic rtl;
  dynamic createdAt;
  dynamic updatedAt;

  Languages({
    this.id,
    this.name,
    this.shortName,
    this.flag,
    this.isActive,
    this.rtl,
    this.createdAt,
    this.updatedAt,
  });

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    flag = json['flag'];
    isActive = json['is_active'];
    rtl = json['rtl'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_name'] = shortName;
    data['flag'] = flag;
    data['is_active'] = isActive;
    data['rtl'] = rtl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class IdentityFormList {
  dynamic id;
  dynamic name;
  dynamic slug;
  Map<dynamic, dynamic>? servicesForm;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  IdentityFormList({
    this.id,
    this.name,
    this.slug,
    this.servicesForm,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  IdentityFormList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    servicesForm = json['services_form'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    if (servicesForm != null) {
      data['services_form'] = servicesForm!;
    }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ServicesForm {
  FrontPage? frontPage;
  FrontPage? rearPage;
  FrontPage? passportNumber;
  FrontPage? address;
  FrontPage? passportImage;
  FrontPage? nidNumber;

  ServicesForm({
    this.frontPage,
    this.rearPage,
    this.passportNumber,
    this.address,
    this.passportImage,
    this.nidNumber,
  });

  ServicesForm.fromJson(Map<String, dynamic> json) {
    frontPage = json['FrontPage'] != null
        ? FrontPage.fromJson(json['FrontPage'])
        : null;
    rearPage = json['RearPage'] != null
        ? FrontPage.fromJson(json['RearPage'])
        : null;
    passportNumber = json['PassportNumber'] != null
        ? FrontPage.fromJson(json['PassportNumber'])
        : null;
    address = json['Address'] != null
        ? FrontPage.fromJson(json['Address'])
        : null;
    passportImage = json['PassportImage'] != null
        ? FrontPage.fromJson(json['PassportImage'])
        : null;
    nidNumber = json['NidNumber'] != null
        ? FrontPage.fromJson(json['NidNumber'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (frontPage != null) {
      data['FrontPage'] = frontPage!.toJson();
    }
    if (rearPage != null) {
      data['RearPage'] = rearPage!.toJson();
    }
    if (passportNumber != null) {
      data['PassportNumber'] = passportNumber!.toJson();
    }
    if (address != null) {
      data['Address'] = address!.toJson();
    }
    if (passportImage != null) {
      data['PassportImage'] = passportImage!.toJson();
    }
    if (nidNumber != null) {
      data['NidNumber'] = nidNumber!.toJson();
    }
    return data;
  }
}

class FrontPage {
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic fieldLength;
  dynamic lengthType;
  dynamic validation;

  FrontPage({
    this.fieldName,
    this.fieldLevel,
    this.type,
    this.fieldLength,
    this.lengthType,
    this.validation,
  });

  FrontPage.fromJson(Map<String, dynamic> json) {
    fieldName = json['field_name'];
    fieldLevel = json['field_level'];
    type = json['type'];
    fieldLength = json['field_length'];
    lengthType = json['length_type'];
    validation = json['validation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_name'] = fieldName;
    data['field_level'] = fieldLevel;
    data['type'] = type;
    data['field_length'] = fieldLength;
    data['length_type'] = lengthType;
    data['validation'] = validation;
    return data;
  }
}
