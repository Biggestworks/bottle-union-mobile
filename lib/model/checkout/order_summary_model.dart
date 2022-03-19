class OrderSummaryModel {
  bool? status;
  String? message;
  Data? data;

  OrderSummaryModel({this.status, this.message, this.data});

  OrderSummaryModel.fromJson(Map<String, dynamic> json) {
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
  int? totalPrice;
  int? deliveryCost;
  int? totalPay;

  Data({this.totalPrice, this.deliveryCost, this.totalPay});

  Data.fromJson(Map<String, dynamic> json) {
    totalPrice = json['total_price'];
    deliveryCost = json['delivery_cost'];
    totalPay = json['total_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_price'] = this.totalPrice;
    data['delivery_cost'] = this.deliveryCost;
    data['total_pay'] = this.totalPay;
    return data;
  }
}