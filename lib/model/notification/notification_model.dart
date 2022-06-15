class NotificationModel {
  int? id;
  int? userId;
  String? title;
  String? body;
  String? type;
  String? codeTransaction;
  dynamic regionId;
  int? isNew;
  String? createdAt;

  NotificationModel({this.id, this.userId, this.title, this.body, this.type, this.codeTransaction, this.regionId, this.isNew, this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    codeTransaction = json['code_transaction'];
    regionId = json['region_id'];
    isNew = json['is_new'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['code_transaction'] = this.codeTransaction;
    data['region_id'] = this.regionId;
    data['is_new'] = this.isNew;
    data['created_at'] = this.createdAt;
    return data;
  }
}