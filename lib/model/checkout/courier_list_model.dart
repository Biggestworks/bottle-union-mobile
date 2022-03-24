class CourierListModel {
  bool? status;
  List<Data>? data;

  CourierListModel({this.status, this.data});

  CourierListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? courier;
  String? description;
  String? etd;
  int? price;

  Data({this.courier, this.description, this.etd, this.price});

  Data.fromJson(Map<String, dynamic> json) {
    courier = json['courier'];
    description = json['description'];
    etd = json['etd'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courier'] = this.courier;
    data['description'] = this.description;
    data['etd'] = this.etd;
    data['price'] = this.price;
    return data;
  }
}