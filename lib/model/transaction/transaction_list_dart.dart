class TransactionListModel {
  bool? status;
  String? message;
  Result? result;

  TransactionListModel({this.status, this.message, this.result});

  TransactionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Result(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Result.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  int? idStatusPayment;
  String? vaNumber;
  String? codeTransaction;
  String? orderedAt;
  String? paymentMethod;
  String? statusOrder;
  String? product;
  String? productImage;
  int? countProduct;
  int? totalPay;

  Data(
      {this.id,
        this.idStatusPayment,
        this.vaNumber,
        this.codeTransaction,
        this.orderedAt,
        this.paymentMethod,
        this.statusOrder,
        this.product,
        this.productImage,
        this.countProduct,
        this.totalPay});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idStatusPayment = json['id_status_payment'];
    vaNumber = json['va_number'];
    codeTransaction = json['code_transaction'];
    orderedAt = json['ordered_at'];
    paymentMethod = json['payment_method'];
    statusOrder = json['status_order'];
    product = json['product'];
    productImage = json['product_image'];
    countProduct = json['count_product'];
    totalPay = json['total_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_status_payment'] = this.idStatusPayment;
    data['va_number'] = this.vaNumber;
    data['code_transaction'] = this.codeTransaction;
    data['ordered_at'] = this.orderedAt;
    data['payment_method'] = this.paymentMethod;
    data['status_order'] = this.statusOrder;
    data['product'] = this.product;
    data['product_image'] = this.productImage;
    data['count_product'] = this.countProduct;
    data['total_pay'] = this.totalPay;
    return data;
  }
}