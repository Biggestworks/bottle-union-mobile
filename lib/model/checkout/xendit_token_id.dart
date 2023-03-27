// To parse this JSON data, do
//
//     final xenditTokenId = xenditTokenIdFromJson(jsonString);

import 'dart:convert';

XenditTokenId xenditTokenIdFromJson(String str) =>
    XenditTokenId.fromJson(json.decode(str));

String xenditTokenIdToJson(XenditTokenId data) => json.encode(data.toJson());

class XenditTokenId {
  XenditTokenId({
    required this.status,
    required this.data,
  });

  bool status;
  XenditTokenIdData data;

  factory XenditTokenId.fromJson(Map<String, dynamic> json) => XenditTokenId(
        status: json["status"],
        data: XenditTokenIdData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class XenditTokenIdData {
  XenditTokenIdData({
    required this.id,
    required this.type,
    required this.country,
    required this.businessId,
    this.customerId,
    required this.referenceId,
    required this.reusability,
    required this.status,
    required this.actions,
    required this.description,
    required this.created,
    required this.updated,
    required this.metadata,
    this.billingInformation,
    this.failureCode,
    this.ewallet,
    this.directBankTransfer,
    this.directDebit,
    required this.card,
    this.overTheCounter,
    this.qrCode,
    this.virtualAccount,
  });

  String id;
  String type;
  String country;
  String businessId;
  dynamic customerId;
  String referenceId;
  String reusability;
  String status;
  List<dynamic> actions;
  String description;
  DateTime created;
  DateTime updated;
  Metadata metadata;
  dynamic billingInformation;
  dynamic failureCode;
  dynamic ewallet;
  dynamic directBankTransfer;
  dynamic directDebit;
  Card card;
  dynamic overTheCounter;
  dynamic qrCode;
  dynamic virtualAccount;

  factory XenditTokenIdData.fromJson(Map<String, dynamic> json) =>
      XenditTokenIdData(
        id: json["id"],
        type: json["type"],
        country: json["country"],
        businessId: json["business_id"],
        customerId: json["customer_id"],
        referenceId: json["reference_id"],
        reusability: json["reusability"],
        status: json["status"],
        actions: List<dynamic>.from(json["actions"].map((x) => x)),
        description: json["description"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        metadata: Metadata.fromJson(json["metadata"]),
        billingInformation: json["billing_information"],
        failureCode: json["failure_code"],
        ewallet: json["ewallet"],
        directBankTransfer: json["direct_bank_transfer"],
        directDebit: json["direct_debit"],
        card: Card.fromJson(json["card"]),
        overTheCounter: json["over_the_counter"],
        qrCode: json["qr_code"],
        virtualAccount: json["virtual_account"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "country": country,
        "business_id": businessId,
        "customer_id": customerId,
        "reference_id": referenceId,
        "reusability": reusability,
        "status": status,
        "actions": List<dynamic>.from(actions.map((x) => x)),
        "description": description,
        "created": created.toIso8601String(),
        "updated": updated.toIso8601String(),
        "metadata": metadata.toJson(),
        "billing_information": billingInformation,
        "failure_code": failureCode,
        "ewallet": ewallet,
        "direct_bank_transfer": directBankTransfer,
        "direct_debit": directDebit,
        "card": card.toJson(),
        "over_the_counter": overTheCounter,
        "qr_code": qrCode,
        "virtual_account": virtualAccount,
      };
}

class Card {
  Card({
    required this.currency,
    required this.channelProperties,
    required this.cardInformation,
    this.cardVerificationResults,
  });

  String currency;
  ChannelProperties channelProperties;
  CardInformation cardInformation;
  dynamic cardVerificationResults;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        currency: json["currency"],
        channelProperties:
            ChannelProperties.fromJson(json["channel_properties"]),
        cardInformation: CardInformation.fromJson(json["card_information"]),
        cardVerificationResults: json["card_verification_results"],
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "channel_properties": channelProperties.toJson(),
        "card_information": cardInformation.toJson(),
        "card_verification_results": cardVerificationResults,
      };
}

class CardInformation {
  CardInformation({
    required this.tokenId,
    required this.maskedCardNumber,
    required this.cardholderName,
    required this.expiryMonth,
    required this.expiryYear,
    required this.type,
    required this.network,
    required this.country,
    required this.issuer,
    required this.fingerprint,
  });

  String tokenId;
  String maskedCardNumber;
  String cardholderName;
  String expiryMonth;
  String expiryYear;
  String type;
  String network;
  String country;
  String issuer;
  String fingerprint;

  factory CardInformation.fromJson(Map<String, dynamic> json) =>
      CardInformation(
        tokenId: json["token_id"],
        maskedCardNumber: json["masked_card_number"],
        cardholderName: json["cardholder_name"],
        expiryMonth: json["expiry_month"],
        expiryYear: json["expiry_year"],
        type: json["type"],
        network: json["network"],
        country: json["country"],
        issuer: json["issuer"],
        fingerprint: json["fingerprint"],
      );

  Map<String, dynamic> toJson() => {
        "token_id": tokenId,
        "masked_card_number": maskedCardNumber,
        "cardholder_name": cardholderName,
        "expiry_month": expiryMonth,
        "expiry_year": expiryYear,
        "type": type,
        "network": network,
        "country": country,
        "issuer": issuer,
        "fingerprint": fingerprint,
      };
}

class ChannelProperties {
  ChannelProperties({
    this.skipThreeDSecure,
    required this.successReturnUrl,
    required this.failureReturnUrl,
    this.cardonfileType,
  });

  dynamic skipThreeDSecure;
  String successReturnUrl;
  String failureReturnUrl;
  dynamic cardonfileType;

  factory ChannelProperties.fromJson(Map<String, dynamic> json) =>
      ChannelProperties(
        skipThreeDSecure: json["skip_three_d_secure"],
        successReturnUrl: json["success_return_url"],
        failureReturnUrl: json["failure_return_url"],
        cardonfileType: json["cardonfile_type"],
      );

  Map<String, dynamic> toJson() => {
        "skip_three_d_secure": skipThreeDSecure,
        "success_return_url": successReturnUrl,
        "failure_return_url": failureReturnUrl,
        "cardonfile_type": cardonfileType,
      };
}

class Metadata {
  Metadata({
    required this.foo,
  });

  String foo;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        foo: json["foo"],
      );

  Map<String, dynamic> toJson() => {
        "foo": foo,
      };
}
