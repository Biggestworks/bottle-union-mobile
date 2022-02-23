class BannerListModel {
  bool? status;
  String? message;
  List<Data>? data;

  BannerListModel({this.status, this.message, this.data});

  BannerListModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? url;
  String? title;
  String? description;
  int? position;
  int? publish;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.image,
        this.url,
        this.title,
        this.description,
        this.position,
        this.publish,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    url = json['url'];
    title = json['title'];
    description = json['description'];
    position = json['position'];
    publish = json['publish'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['position'] = this.position;
    data['publish'] = this.publish;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}