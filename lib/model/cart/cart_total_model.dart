class CartTotalModel {
  bool? status;
  String? message;
  int? total;

  CartTotalModel({this.status, this.message, this.total});

  CartTotalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}