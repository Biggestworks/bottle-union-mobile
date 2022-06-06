class ProductOrderModel {
  int? idProduct;
  int? idRegion;
  int? qty;

  ProductOrderModel({this.idProduct, this.idRegion, this.qty});

  ProductOrderModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    idProduct = json['id_region'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_product'] = this.idProduct;
    data['id_region'] = this.idRegion;
    data['qty'] = this.qty;
    return data;
  }
}