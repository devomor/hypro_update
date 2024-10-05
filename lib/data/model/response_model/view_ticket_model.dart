class ViewTicketModel {
  dynamic status;
  ViewTicketData? message;

  ViewTicketModel({this.status, this.message});

  ViewTicketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
    json['message'] != null ? new ViewTicketData.fromJson(json['message']) : null;
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

class ViewTicketData {
  dynamic id;
  dynamic pageTitle;
  dynamic userImage;
  dynamic userUsername;
  dynamic status;
  List<Messages>? messages;

  ViewTicketData(
      {this.id,
        this.pageTitle,
        this.userImage,
        this.userUsername,
        this.status,
        this.messages});

  ViewTicketData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pageTitle = json['page_title'];
    userImage = json['userImage'];
    userUsername = json['userUsername'];
    status = json['status'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['page_title'] = this.pageTitle;
    data['userImage'] = this.userImage;
    data['userUsername'] = this.userUsername;
    data['status'] = this.status;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  dynamic id;
  dynamic ticketId;
  dynamic adminId;
  dynamic message;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic adminImage;
  List<Attachments>? attachments;

  Messages(
      {this.id,
        this.ticketId,
        this.adminId,
        this.message,
        this.createdAt,
        this.updatedAt,
        this.adminImage,
        this.attachments});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    adminId = json['admin_id'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminImage = json['adminImage'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['admin_id'] = this.adminId;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['adminImage'] = this.adminImage;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  dynamic id;
  dynamic ticketMessageId;
  dynamic image;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic attachmentPath;
  dynamic attachmentName;

  Attachments(
      {this.id,
        this.ticketMessageId,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.attachmentPath,
        this.attachmentName});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketMessageId = json['ticket_message_id'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attachmentPath = json['attachment_path'];
    attachmentName = json['attachment_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_message_id'] = this.ticketMessageId;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['attachment_path'] = this.attachmentPath;
    data['attachment_name'] = this.attachmentName;
    return data;
  }
}
