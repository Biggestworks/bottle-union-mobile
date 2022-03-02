class DefaultModel {
  bool? status;
  String? message;
  Map<String, dynamic>? errors;

  DefaultModel({this.status, this.message});

  DefaultModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['errors'] = this.errors;
    return data;
  }
}