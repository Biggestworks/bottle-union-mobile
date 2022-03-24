class MidtransPaymentModel {
  bool? status;
  String? message;
  Data? data;

  MidtransPaymentModel({this.status, this.message, this.data});

  MidtransPaymentModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? redirectUrl;

  Data({this.token, this.redirectUrl});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['redirect_url'] = this.redirectUrl;
    return data;
  }
}