class UserModel {
  bool? status;
  String? message;
  Data? data;
  String? token;
  Map<String, dynamic>? errors;

  UserModel({this.status, this.message, this.data, this.token, this.errors});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    data['errors'] = this.errors;
    return data;
  }
}

class Data {
  int? id;
  int? idRegion;
  String? providerUid;
  String? providerId;
  String? fullname;
  String? email;
  String? emailVerifiedAt;
  String? avatar;
  String? dateOfBirth;
  String? phone;
  String? gender;
  int? isAdmin;
  int? isVerified;
  String? fcmToken;
  String? validationCode;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Data(
      {this.id,
        this.idRegion,
        this.providerUid,
        this.providerId,
        this.fullname,
        this.email,
        this.emailVerifiedAt,
        this.avatar,
        this.dateOfBirth,
        this.phone,
        this.gender,
        this.isAdmin,
        this.isVerified,
        this.fcmToken,
        this.validationCode,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRegion = json['id_region'];
    providerUid = json['provider_uid'];
    providerId = json['provider_id'];
    fullname = json['fullname'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    avatar = json['avatar'];
    dateOfBirth = json['date_of_birth'];
    phone = json['phone'];
    gender = json['gender'];
    isAdmin = json['is_admin'];
    isVerified = json['is_verified'];
    fcmToken = json['fcm_token'];
    validationCode = json['validation_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_region'] = this.idRegion;
    data['provider_uid'] = this.providerUid;
    data['provider_id'] = this.providerId;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['avatar'] = this.avatar;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['is_admin'] = this.isAdmin;
    data['is_verified'] = this.isVerified;
    data['fcm_token'] = this.fcmToken;
    data['validation_code'] = this.validationCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}