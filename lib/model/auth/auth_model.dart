class AuthModel {
  bool? status;
  String? message;
  Data? data;
  String? token;

  AuthModel({this.status, this.message, this.data, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String? idRegion;
  String? fullname;
  String? email;
  String? avatar;
  String? gender;
  String? phone;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.idRegion,
        this.fullname,
        this.email,
        this.avatar,
        this.gender,
        this.phone,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    idRegion = json['id_region'];
    fullname = json['fullname'];
    email = json['email'];
    avatar = json['avatar'];
    gender = json['gender'];
    phone = json['phone'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_region'] = this.idRegion;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}