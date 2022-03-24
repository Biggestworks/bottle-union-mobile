class ProductOrderModel {
  int? idProduct;
  int? qty;

  ProductOrderModel({this.idProduct, this.qty});

  ProductOrderModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['id_product'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_product'] = this.idProduct;
    data['qty'] = this.qty;
    return data;
  }
}