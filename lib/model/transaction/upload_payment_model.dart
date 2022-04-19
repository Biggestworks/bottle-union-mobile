class UploadPaymentModel {
  bool? status;
  String? message;
  Data? data;

  UploadPaymentModel({this.status, this.message, this.data});

  UploadPaymentModel.fromJson(Map<String, dynamic> json) {
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
  String? idOrder;
  int? idUser;
  int? idShipment;
  int? idStatusPayment;
  String? statusMessage;
  String? descriptionMessage;
  String? statusPayment;
  int? amount;
  String? paymentMethod;
  String? paymentType;
  String? evidanceOfTransfer;
  bool? isApproved;
  String? approvedBy;
  String? expiredAt;
  String? courierName;
  String? courierDesc;
  String? courierEtd;
  int? courierCost;
  String? transactionTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Data(
      {this.id,
        this.idOrder,
        this.idUser,
        this.idShipment,
        this.idStatusPayment,
        this.statusMessage,
        this.descriptionMessage,
        this.statusPayment,
        this.amount,
        this.paymentMethod,
        this.paymentType,
        this.evidanceOfTransfer,
        this.isApproved,
        this.approvedBy,
        this.expiredAt,
        this.courierName,
        this.courierDesc,
        this.courierEtd,
        this.courierCost,
        this.transactionTime,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrder = json['id_order'];
    idUser = json['id_user'];
    idShipment = json['id_shipment'];
    idStatusPayment = json['id_status_payment'];
    statusMessage = json['status_message'];
    descriptionMessage = json['description_message'];
    statusPayment = json['status_payment'];
    amount = json['amount'];
    paymentMethod = json['payment_method'];
    paymentType = json['payment_type'];
    evidanceOfTransfer = json['evidance_of_transfer'];
    isApproved = json['is_approved'];
    approvedBy = json['approved_by'];
    expiredAt = json['expired_at'];
    courierName = json['courier_name'];
    courierDesc = json['courier_desc'];
    courierEtd = json['courier_etd'];
    courierCost = json['courier_cost'];
    transactionTime = json['transaction_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_order'] = this.idOrder;
    data['id_user'] = this.idUser;
    data['id_shipment'] = this.idShipment;
    data['id_status_payment'] = this.idStatusPayment;
    data['status_message'] = this.statusMessage;
    data['description_message'] = this.descriptionMessage;
    data['status_payment'] = this.statusPayment;
    data['amount'] = this.amount;
    data['payment_method'] = this.paymentMethod;
    data['payment_type'] = this.paymentType;
    data['evidance_of_transfer'] = this.evidanceOfTransfer;
    data['is_approved'] = this.isApproved;
    data['approved_by'] = this.approvedBy;
    data['expired_at'] = this.expiredAt;
    data['courier_name'] = this.courierName;
    data['courier_desc'] = this.courierDesc;
    data['courier_etd'] = this.courierEtd;
    data['courier_cost'] = this.courierCost;
    data['transaction_time'] = this.transactionTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}