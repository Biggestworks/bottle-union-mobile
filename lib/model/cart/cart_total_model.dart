class CartTotalModel {
  bool? status;
  int? total;
  String? message;
  List<Result>? result;

  CartTotalModel({this.status, this.total, this.message, this.result});

  CartTotalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    total = json['total'];
    message = json['message'];
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
    data['total'] = this.total;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? idRegion;
  String? region;
  int? idProvince;
  List<Data>? data;

  Result({this.idRegion, this.region, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    idRegion = json['id_region'];
    region = json['region'];
    idProvince = json['id_province'];
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
    data['id_province'] = this.idProvince;
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