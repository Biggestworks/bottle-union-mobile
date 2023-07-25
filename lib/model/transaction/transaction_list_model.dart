// To parse this JSON data, do
//
//     final transactionListModel = transactionListModelFromJson(jsonString);

import 'dart:convert';

TransactionListModel transactionListModelFromJson(String str) =>
    TransactionListModel.fromJson(json.decode(str));

String transactionListModelToJson(TransactionListModel data) =>
    json.encode(data.toJson());

class TransactionListModel {
  TransactionListModel({
    required this.status,
    required this.message,
    required this.result,
  });

  bool? status;
  String? message;
  Result? result;

  factory TransactionListModel.fromJson(Map<String, dynamic> json) =>
      TransactionListModel(
        status: json["status"],
        message: json["message"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result != null ? result!.toJson() : null,
      };
}

class Result {
  Result({
    this.currentPage,
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
    this.total,
  });

  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic? prevPageUrl;
  int? to;
  int? total;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : null,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.idStatusPayment,
    this.idRegion,
    this.region,
    this.vaNumber,
    this.deeplink,
    this.gosend,
    this.codeTransaction,
    this.orderedAt,
    this.paymentMethod,
    this.statusOrder,
    this.product,
    this.productImage,
    this.qtyProduct,
    this.totalPay,
  });

  int? id;
  int? idStatusPayment;
  int? idRegion;
  String? region;
  dynamic? vaNumber;
  String? deeplink;
  List<Gosend>? gosend;
  String? codeTransaction;
  DateTime? orderedAt;
  String? paymentMethod;
  String? statusOrder;
  String? product;
  String? productImage;
  int? qtyProduct;
  int? totalPay;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        idStatusPayment: json["id_status_payment"],
        idRegion: json["id_region"],
        region: json["region"],
        vaNumber: json["va_number"],
        deeplink: json["deeplink"],
        gosend: json['gosend'] != null
            ? List<Gosend>.from(json["gosend"]
                .map((x) => x != null ? Gosend.fromJson(x) : Gosend()))
            : null,
        codeTransaction: json["code_transaction"],
        orderedAt: DateTime.parse(json["ordered_at"]),
        paymentMethod: json["payment_method"],
        statusOrder: json["status_order"],
        product: json["product"],
        productImage: json["product_image"],
        qtyProduct: json["qty_product"],
        totalPay: json["total_pay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_status_payment": idStatusPayment,
        "id_region": idRegion,
        "region": region,
        "va_number": vaNumber,
        "deeplink": deeplink,
        "gosend": gosend != null
            ? List<dynamic>.from(gosend!.map((x) => x.toJson()))
            : null,
        "code_transaction": codeTransaction,
        "ordered_at": orderedAt != null ? orderedAt!.toIso8601String() : null,
        "payment_method": paymentMethod,
        "status_order": statusOrder,
        "product": product,
        "product_image": productImage,
        "qty_product": qtyProduct,
        "total_pay": totalPay,
      };
}

class Gosend {
  Gosend({
    this.id,
    this.orderNo,
    this.status,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverPhoto,
    this.vehicleNumber,
    this.totalDiscount,
    this.totalPrice,
    this.receiverName,
    this.orderCreatedTime,
    this.orderDispatchTime,
    this.orderArrivalTime,
    this.orderClosedTime,
    this.orderCancelledTime,
    this.sellerAddressName,
    this.sellerAddressDetail,
    this.buyerAddressName,
    this.buyerAddressDetail,
    this.bookingType,
    this.cancelDescription,
    this.storeOrderId,
    this.liveTrackingUrl,
    this.insuranceDetails,
    this.proofs,
    this.bookingStatus,
  });

  int? id;
  String? orderNo;
  String? status;
  int? driverId;
  String? driverName;
  String? driverPhone;
  String? driverPhoto;
  String? vehicleNumber;
  int? totalDiscount;
  int? totalPrice;
  String? receiverName;
  DateTime? orderCreatedTime;
  DateTime? orderDispatchTime;
  DateTime? orderArrivalTime;
  DateTime? orderClosedTime;
  dynamic? orderCancelledTime;
  String? sellerAddressName;
  String? sellerAddressDetail;
  String? buyerAddressName;
  String? buyerAddressDetail;
  String? bookingType;
  dynamic? cancelDescription;
  String? storeOrderId;
  String? liveTrackingUrl;
  InsuranceDetails? insuranceDetails;
  Proofs? proofs;
  String? bookingStatus;

  factory Gosend.fromJson(Map<String, dynamic> json) => Gosend(
        id: json["id"],
        orderNo: json["orderNo"],
        status: json["status"],
        driverId: json["driverId"],
        driverName: json["driverName"],
        driverPhone: json["driverPhone"],
        driverPhoto: json["driverPhoto"],
        vehicleNumber: json["vehicleNumber"],
        totalDiscount: json["totalDiscount"],
        totalPrice: json["totalPrice"],
        receiverName: json["receiverName"],
        orderCreatedTime: DateTime.parse(json["orderCreatedTime"]),
        orderDispatchTime: json["orderDispatchTime"] == null
            ? null
            : DateTime.parse(json["orderDispatchTime"]),
        orderArrivalTime: json["orderArrivalTime"] == null
            ? null
            : DateTime.parse(json["orderArrivalTime"]),
        orderClosedTime: json["orderClosedTime"] == null
            ? null
            : DateTime.parse(json["orderClosedTime"]),
        orderCancelledTime: json["orderCancelledTime"],
        sellerAddressName: json["sellerAddressName"],
        sellerAddressDetail: json["sellerAddressDetail"],
        buyerAddressName: json["buyerAddressName"],
        buyerAddressDetail: json["buyerAddressDetail"],
        bookingType: json["bookingType"],
        cancelDescription: json["cancelDescription"],
        storeOrderId: json["storeOrderId"],
        liveTrackingUrl: json["liveTrackingUrl"],
        insuranceDetails: InsuranceDetails.fromJson(json["insuranceDetails"]),
        proofs: Proofs.fromJson(json["proofs"]),
        bookingStatus: json["bookingStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderNo": orderNo,
        "status": status,
        "driverId": driverId,
        "driverName": driverName,
        "driverPhone": driverPhone,
        "driverPhoto": driverPhoto,
        "vehicleNumber": vehicleNumber,
        "totalDiscount": totalDiscount,
        "totalPrice": totalPrice,
        "receiverName": receiverName,
        "orderCreatedTime": orderCreatedTime != null
            ? orderCreatedTime!.toIso8601String()
            : null,
        "orderDispatchTime": orderDispatchTime?.toIso8601String(),
        "orderArrivalTime": orderArrivalTime?.toIso8601String(),
        "orderClosedTime": orderClosedTime?.toIso8601String(),
        "orderCancelledTime": orderCancelledTime,
        "sellerAddressName": sellerAddressName,
        "sellerAddressDetail": sellerAddressDetail,
        "buyerAddressName": buyerAddressName,
        "buyerAddressDetail": buyerAddressDetail,
        "bookingType": bookingType,
        "cancelDescription": cancelDescription,
        "storeOrderId": storeOrderId,
        "liveTrackingUrl": liveTrackingUrl,
        "insuranceDetails":
            insuranceDetails != null ? insuranceDetails!.toJson() : null,
        "proofs": proofs != null ? proofs!.toJson() : null,
        "bookingStatus": bookingStatus,
      };
}

class InsuranceDetails {
  InsuranceDetails({
    this.applied,
    this.fee,
    this.productDescription,
    this.productPrice,
  });

  String? applied;
  String? fee;
  String? productDescription;
  String? productPrice;

  factory InsuranceDetails.fromJson(Map<String, dynamic> json) =>
      InsuranceDetails(
        applied: json["applied"],
        fee: json["fee"],
        productDescription: json["product_description"],
        productPrice: json["product_price"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "fee": fee,
        "product_description": productDescription,
        "product_price": productPrice,
      };
}

class Proofs {
  Proofs({
    this.pop,
    this.pod,
  });

  dynamic? pop;
  dynamic? pod;

  factory Proofs.fromJson(Map<String, dynamic> json) => Proofs(
        pop: json["pop"],
        pod: json["pod"],
      );

  Map<String, dynamic> toJson() => {
        "pop": pop,
        "pod": pod,
      };
}
