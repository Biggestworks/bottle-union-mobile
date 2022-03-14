class AddressListModel {
  bool? status;
  String? message;
  List<Data>? data;

  AddressListModel({this.status, this.message, this.data});

  AddressListModel.fromJson(Map<String, dynamic> json) {
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
  int? idUser;
  String? address;
  String? detailNote;
  int? provinceCode;
  String? provinceName;
  int? cityCode;
  String? cityName;
  String? postCode;
  String? label;
  String? latitude;
  String? longitude;
  int? isChoosed;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  User? user;

  Data(
      {this.id,
        this.idUser,
        this.address,
        this.detailNote,
        this.provinceCode,
        this.provinceName,
        this.cityCode,
        this.cityName,
        this.postCode,
        this.label,
        this.latitude,
        this.longitude,
        this.isChoosed,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    address = json['address'];
    detailNote = json['detail_note'];
    provinceCode = json['province_code'];
    provinceName = json['province_name'];
    cityCode = json['city_code'];
    cityName = json['city_name'];
    postCode = json['post_code'];
    label = json['label'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isChoosed = json['is_choosed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['address'] = this.address;
    data['detail_note'] = this.detailNote;
    data['province_code'] = this.provinceCode;
    data['province_name'] = this.provinceName;
    data['city_code'] = this.cityCode;
    data['city_name'] = this.cityName;
    data['post_code'] = this.postCode;
    data['label'] = this.label;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['is_choosed'] = this.isChoosed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
  String? fcmToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Region? region;

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
        this.fcmToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.region});

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
    fcmToken = json['fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    region =
    json['region'] != null ? new Region.fromJson(json['region']) : null;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
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