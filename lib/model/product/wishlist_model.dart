class WishlistModel {
  bool? status;
  String? message;
  Data? data;

  WishlistModel({this.status, this.message, this.data});

  WishlistModel.fromJson(Map<String, dynamic> json) {
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
  int? idUser;
  int? idProduct;
  String? flag;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.idUser,
        this.idProduct,
        this.flag,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    idProduct = json['id_product'];
    flag = json['flag'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['id_product'] = this.idProduct;
    data['flag'] = this.flag;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}