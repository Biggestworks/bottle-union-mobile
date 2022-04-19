class UserDetailModel {
  User? user;
  Region? region;

  UserDetailModel({this.user, this.region});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    region =
    json['region'] != null ? new Region.fromJson(json['region']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    return data;
  }
}

class User {
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
  int? isActive;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User(
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
        this.isActive,
        this.fcmToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
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
    isActive = json['is_active'];
    fcmToken = json['fcm_token'];
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
    data['is_active'] = this.isActive;
    data['fcm_token'] = this.fcmToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Region {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Region({this.id, this.name, this.createdAt, this.updatedAt, this.deletedAt});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}