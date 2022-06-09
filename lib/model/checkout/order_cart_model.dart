class OrderCartModel {
  bool? status;
  String? message;
  String? deeplink;
  List<Result>? result;

  OrderCartModel({this.status, this.message, this.deeplink, this.result});

  OrderCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    deeplink = json['deeplink'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['deeplink'] = this.deeplink;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? idRegion;
  String? region;
  String? codeTransaction;
  String? vaNumber;
  String? paymentType;
  int? amount;
  String? statusPayment;
  String? createdAt;
  String? expiredAt;
  List<Data>? data;

  Result(
      {this.idRegion,
        this.region,
        this.codeTransaction,
        this.vaNumber,
        this.paymentType,
        this.amount,
        this.statusPayment,
        this.createdAt,
        this.expiredAt,
        this.data});

  Result.fromJson(Map<String, dynamic> json) {
    idRegion = json['id_region'];
    region = json['region'];
    codeTransaction = json['code_transaction'];
    vaNumber = json['va_number'];
    paymentType = json['payment_type'];
    amount = json['amount'];
    statusPayment = json['status_payment'];
    createdAt = json['created_at'];
    expiredAt = json['expired_at'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_region'] = this.idRegion;
    data['region'] = this.region;
    data['code_transaction'] = this.codeTransaction;
    data['va_number'] = this.vaNumber;
    data['payment_type'] = this.paymentType;
    data['amount'] = this.amount;
    data['status_payment'] = this.statusPayment;
    data['created_at'] = this.createdAt;
    data['expired_at'] = this.expiredAt;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? idCart;
  int? idUser;
  int? idProcduct;
  Product? product;
  int? qty;
  int? isSelected;
  String? statusPaid;
  String? courierName;
  String? courierDesc;
  String? courierEtd;
  int? courierCost;
  Shipment? shipment;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.idCart,
        this.idUser,
        this.idProcduct,
        this.product,
        this.qty,
        this.isSelected,
        this.statusPaid,
        this.courierName,
        this.courierDesc,
        this.courierEtd,
        this.courierCost,
        this.shipment,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    idCart = json['id_cart'];
    idUser = json['id_user'];
    idProcduct = json['id_procduct'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    qty = json['qty'];
    isSelected = json['is_selected'];
    statusPaid = json['status_paid'];
    courierName = json['courier_name'];
    courierDesc = json['courier_desc'];
    courierEtd = json['courier_etd'];
    courierCost = json['courier_cost'];
    shipment = json['shipment'] != null
        ? new Shipment.fromJson(json['shipment'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_cart'] = this.idCart;
    data['id_user'] = this.idUser;
    data['id_procduct'] = this.idProcduct;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['qty'] = this.qty;
    data['is_selected'] = this.isSelected;
    data['status_paid'] = this.statusPaid;
    data['courier_name'] = this.courierName;
    data['courier_desc'] = this.courierDesc;
    data['courier_etd'] = this.courierEtd;
    data['courier_cost'] = this.courierCost;
    if (this.shipment != null) {
      data['shipment'] = this.shipment!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
  int? isPopular;
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

class Shipment {
  int? id;
  String? idOrder;
  String? receiver;
  String? address;
  String? phone;
  String? provinceName;
  String? cityName;
  String? postalCode;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Shipment(
      {this.id,
        this.idOrder,
        this.receiver,
        this.address,
        this.phone,
        this.provinceName,
        this.cityName,
        this.postalCode,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Shipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idOrder = json['id_order'];
    receiver = json['receiver'];
    address = json['address'];
    phone = json['phone'];
    provinceName = json['province_name'];
    cityName = json['city_name'];
    postalCode = json['postal_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_order'] = this.idOrder;
    data['receiver'] = this.receiver;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['province_name'] = this.provinceName;
    data['city_name'] = this.cityName;
    data['postal_code'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}