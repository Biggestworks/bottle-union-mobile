class TransactionDetailModel {
  bool? status;
  String? message;
  Data? data;

  TransactionDetailModel({this.status, this.message, this.data});

  TransactionDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? codeTransaction;
  String? orderedAt;
  String? statusOrder;
  List<Order>? order;
  ShipmentInformation? shipmentInformation;
  List<Product>? product;
  int? countProduct;
  int? totalProductWeight;
  DetailPayments? detailPayments;
  int? totalPay;

  Data(
      {this.id,
        this.codeTransaction,
        this.orderedAt,
        this.statusOrder,
        this.order,
        this.shipmentInformation,
        this.product,
        this.countProduct,
        this.totalProductWeight,
        this.detailPayments,
        this.totalPay});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codeTransaction = json['code_transaction'];
    orderedAt = json['ordered_at'];
    statusOrder = json['status_order'];
    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(new Order.fromJson(v));
      });
    }
    shipmentInformation = json['shipment_information'] != null
        ? new ShipmentInformation.fromJson(json['shipment_information'])
        : null;
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    countProduct = json['count_product'];
    totalProductWeight = json['total_product_weight'];
    detailPayments = json['detail_payments'] != null
        ? new DetailPayments.fromJson(json['detail_payments'])
        : null;
    totalPay = json['total_pay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code_transaction'] = this.codeTransaction;
    data['ordered_at'] = this.orderedAt;
    data['status_order'] = this.statusOrder;
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    if (this.shipmentInformation != null) {
      data['shipment_information'] = this.shipmentInformation!.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['count_product'] = this.countProduct;
    data['total_product_weight'] = this.totalProductWeight;
    if (this.detailPayments != null) {
      data['detail_payments'] = this.detailPayments!.toJson();
    }
    data['total_pay'] = this.totalPay;
    return data;
  }
}

class Order {
  int? id;
  int? idShipping;
  int? idUser;
  int? idProduct;
  int? qty;
  int? price;
  String? codeTransaction;
  int? statusPaid;
  String? voucherCode;
  String? voucherAmount;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Product? product;
  Payment? payment;

  Order(
      {this.id,
        this.idShipping,
        this.idUser,
        this.idProduct,
        this.qty,
        this.price,
        this.codeTransaction,
        this.statusPaid,
        this.voucherCode,
        this.voucherAmount,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.product,
        this.payment});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShipping = json['id_shipping'];
    idUser = json['id_user'];
    idProduct = json['id_product'];
    qty = json['qty'];
    price = json['price'];
    codeTransaction = json['code_transaction'];
    statusPaid = json['status_paid'];
    voucherCode = json['voucher_code'];
    voucherAmount = json['voucher_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_shipping'] = this.idShipping;
    data['id_user'] = this.idUser;
    data['id_product'] = this.idProduct;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['code_transaction'] = this.codeTransaction;
    data['status_paid'] = this.statusPaid;
    data['voucher_code'] = this.voucherCode;
    data['voucher_amount'] = this.voucherAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  int? idBrand;
  int? idCategory;
  int? idFlag;
  String? manufactureCountry;
  String? originCountry;
  String? year;
  String? name;
  int? price;
  int? regularPrice;
  int? salePrice;
  String? description;
  int? weight;
  int? publish;
  bool? isPopular;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;
  int? stock;
  int? width;
  int? height;
  String? rating;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Product(
      {this.id,
        this.idBrand,
        this.idCategory,
        this.idFlag,
        this.manufactureCountry,
        this.originCountry,
        this.year,
        this.name,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.description,
        this.weight,
        this.publish,
        this.isPopular,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.image5,
        this.stock,
        this.width,
        this.height,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idBrand = json['id_brand'];
    idCategory = json['id_category'];
    idFlag = json['id_flag'];
    manufactureCountry = json['manufacture_country'];
    originCountry = json['origin_country'];
    year = json['year'];
    name = json['name'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    description = json['description'];
    weight = json['weight'];
    publish = json['publish'];
    isPopular = json['is_popular'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
    image4 = json['image_4'];
    image5 = json['image_5'];
    stock = json['stock'];
    width = json['width'];
    height = json['height'];
    rating = json['rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_brand'] = this.idBrand;
    data['id_category'] = this.idCategory;
    data['id_flag'] = this.idFlag;
    data['manufacture_country'] = this.manufactureCountry;
    data['origin_country'] = this.originCountry;
    data['year'] = this.year;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['weight'] = this.weight;
    data['publish'] = this.publish;
    data['is_popular'] = this.isPopular;
    data['image_1'] = this.image1;
    data['image_2'] = this.image2;
    data['image_3'] = this.image3;
    data['image_4'] = this.image4;
    data['image_5'] = this.image5;
    data['stock'] = this.stock;
    data['width'] = this.width;
    data['height'] = this.height;
    data['rating'] = this.rating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Payment {
  int? id;
  String? idOrder;
  int? idUser;
  int? idShipment;
  int? idStatusPayment;
  String? statusMessage;
  String? descriptionMessage;
  StatusPayment? statusPayment;
  int? amount;
  String? paymentMethod;
  String? paymentType;
  String? evidanceOfTransfer;
  int? isApproved;
  int? approvedBy;
  String? expiredAt;
  String? courierName;
  String? courierDesc;
  String? courierEtd;
  int? courierCost;
  String? transactionTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Payment(
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

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrder = json['id_order'];
    idUser = json['id_user'];
    idShipment = json['id_shipment'];
    idStatusPayment = json['id_status_payment'];
    statusMessage = json['status_message'];
    descriptionMessage = json['description_message'];
    statusPayment = json['status_payment'] != null
        ? new StatusPayment.fromJson(json['status_payment'])
        : null;
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
    if (this.statusPayment != null) {
      data['status_payment'] = this.statusPayment!.toJson();
    }
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

class StatusPayment {
  int? id;
  String? description;
  String? createdAt;
  String? updatedAt;

  StatusPayment({this.id, this.description, this.createdAt, this.updatedAt});

  StatusPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ShipmentInformation {
  String? courierName;
  String? courierDescription;
  String? courierEtd;
  Shipment? shipment;

  ShipmentInformation(
      {this.courierName,
        this.courierDescription,
        this.courierEtd,
        this.shipment});

  ShipmentInformation.fromJson(Map<String, dynamic> json) {
    courierName = json['courier_name'];
    courierDescription = json['courier_description'];
    courierEtd = json['courier_etd'];
    shipment = json['shipment'] != null
        ? new Shipment.fromJson(json['shipment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courier_name'] = this.courierName;
    data['courier_description'] = this.courierDescription;
    data['courier_etd'] = this.courierEtd;
    if (this.shipment != null) {
      data['shipment'] = this.shipment!.toJson();
    }
    return data;
  }
}

class Shipment {
  String? receiver;
  String? phone;
  String? address;

  Shipment({this.receiver, this.phone, this.address});

  Shipment.fromJson(Map<String, dynamic> json) {
    receiver = json['receiver'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver'] = this.receiver;
    data['phone'] = this.phone;
    data['address'] = this.address;
    return data;
  }
}

class DetailPayments {
  String? paymentMethod;
  int? totalPrice;
  int? courierCost;

  DetailPayments({this.paymentMethod, this.totalPrice, this.courierCost});

  DetailPayments.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    totalPrice = json['total_price'];
    courierCost = json['courier_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    data['total_price'] = this.totalPrice;
    data['courier_cost'] = this.courierCost;
    return data;
  }
}