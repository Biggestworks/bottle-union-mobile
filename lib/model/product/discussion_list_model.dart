class DiscussionListModel {
  bool? status;
  String? message;
  List<Data>? data;

  DiscussionListModel({this.status, this.message, this.data});

  DiscussionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? idProduct;
  int? idUser;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<ReplyDiscussions>? replyDiscussions;

  Data(
      {this.id,
        this.idProduct,
        this.idUser,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.replyDiscussions});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProduct = json['id_product'];
    idUser = json['id_user'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['reply_discussions'] != null) {
      replyDiscussions = <ReplyDiscussions>[];
      json['reply_discussions'].forEach((v) {
        replyDiscussions!.add(new ReplyDiscussions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_product'] = this.idProduct;
    data['id_user'] = this.idUser;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.replyDiscussions != null) {
      data['reply_discussions'] =
          this.replyDiscussions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyDiscussions {
  int? id;
  int? idDiscussion;
  int? idUser;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ReplyDiscussions(
      {this.id,
        this.idDiscussion,
        this.idUser,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ReplyDiscussions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idDiscussion = json['id_discussion'];
    idUser = json['id_user'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_discussion'] = this.idDiscussion;
    data['id_user'] = this.idUser;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}