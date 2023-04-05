class PaymentListModel {
  bool? status;
  String? message;
  List<Data>? data;

  PaymentListModel({this.status, this.message, this.data});

  PaymentListModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? description;
  String? image;
  int? cvv;
  String? card_token;
  int? user_id;
  String? card_number;
  String? cardholder_name;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.cvv,
      this.card_token,
      this.user_id,
      this.card_number,
      this.cardholder_name,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cvv = json['cvv'];
    description = json['description'];
    image = json['image'];
    card_token = json['card_token'];
    user_id = json['user_id'];
    card_number = json['card_number'];
    cardholder_name = json['cardholder_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['cvv'] = this.cvv;
    data['card_token'] = this.card_token;
    data['user_id'] = this.user_id;
    data['card_number'] = this.card_number;
    data['cardholder_name'] = this.cardholder_name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
