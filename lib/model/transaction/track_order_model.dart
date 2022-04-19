class TrackOrderModel {
  bool? status;
  String? message;
  List<Data>? data;

  TrackOrderModel({this.status, this.message, this.data});

  TrackOrderModel.fromJson(Map<String, dynamic> json) {
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
  String? idOrder;
  int? idAdmin;
  String? statusCode;
  String? statusMessage;
  String? description;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.idOrder,
        this.idAdmin,
        this.statusCode,
        this.statusMessage,
        this.description,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrder = json['id_order'];
    idAdmin = json['id_admin'];
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_order'] = this.idOrder;
    data['id_admin'] = this.idAdmin;
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}