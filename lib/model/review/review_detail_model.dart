class ReviewDetailModel {
  bool? status;
  String? message;
  Data? data;

  ReviewDetailModel({this.status, this.message, this.data});

  ReviewDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? idUser;
  int? idProduct;
  int? rating;
  String? comment;
  String? commentFromAdmin;
  int? like;
  String? image1;
  String? image2;
  String? image3;
  String? createdAt;
  String? updatedAt;
  User? user;
  Product? product;

  Data(
      {this.id,
        this.idUser,
        this.idProduct,
        this.rating,
        this.comment,
        this.commentFromAdmin,
        this.like,
        this.image1,
        this.image2,
        this.image3,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.product});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    idProduct = json['id_product'];
    rating = json['rating'];
    comment = json['comment'];
    commentFromAdmin = json['comment_from_admin'];
    like = json['like'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['id_product'] = this.idProduct;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['comment_from_admin'] = this.commentFromAdmin;
    data['like'] = this.like;
    data['image_1'] = this.image1;
    data['image_2'] = this.image2;
    data['image_3'] = this.image3;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  int? idRegion;
  int? idMembership;
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
        this.idMembership,
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
    idMembership = json['id_membership'];
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
    data['id_membership'] = this.idMembership;
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

class Product {
  int? id;
  int? idBrand;
  int? idCategory;
  int? idFlag;
  String? manufactureCountry;
  String? originCountry;
  String? year;
  String? name;
  int? price;
  int? regularPrice;
  int? salePrice;
  String? description;
  int? weight;
  int? publish;
  int? isPopular;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  int? stock;
  int? width;
  int? height;
  String? rating;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Product(
      {this.id,
        this.idBrand,
        this.idCategory,
        this.idFlag,
        this.manufactureCountry,
        this.originCountry,
        this.year,
        this.name,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.description,
        this.weight,
        this.publish,
        this.isPopular,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.image5,
        this.stock,
        this.width,
        this.height,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idBrand = json['id_brand'];
    idCategory = json['id_category'];
    idFlag = json['id_flag'];
    manufactureCountry = json['manufacture_country'];
    originCountry = json['origin_country'];
    year = json['year'];
    name = json['name'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    description = json['description'];
    weight = json['weight'];
    publish = json['publish'];
    isPopular = json['is_popular'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
    image4 = json['image_4'];
    image5 = json['image_5'];
    stock = json['stock'];
    width = json['width'];
    height = json['height'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_brand'] = this.idBrand;
    data['id_category'] = this.idCategory;
    data['id_flag'] = this.idFlag;
    data['manufacture_country'] = this.manufactureCountry;
    data['origin_country'] = this.originCountry;
    data['year'] = this.year;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['weight'] = this.weight;
    data['publish'] = this.publish;
    data['is_popular'] = this.isPopular;
    data['image_1'] = this.image1;
    data['image_2'] = this.image2;
    data['image_3'] = this.image3;
    data['image_4'] = this.image4;
    data['image_5'] = this.image5;
    data['stock'] = this.stock;
    data['width'] = this.width;
    data['height'] = this.height;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}