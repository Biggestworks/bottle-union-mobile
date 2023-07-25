// To parse this JSON data, do
//
//     final contactUs = contactUsFromJson(jsonString);

import 'dart:convert';

ContactUs contactUsFromJson(String str) => ContactUs.fromJson(json.decode(str));

String contactUsToJson(ContactUs data) => json.encode(data.toJson());

class ContactUs {
  bool status;
  List<ContactUsResult> result;

  ContactUs({
    required this.status,
    required this.result,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) => ContactUs(
        status: json["status"],
        result: List<ContactUsResult>.from(
            json["result"].map((x) => ContactUsResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class ContactUsResult {
  int id;
  String title;
  String value;

  ContactUsResult({
    required this.id,
    required this.title,
    required this.value,
  });

  factory ContactUsResult.fromJson(Map<String, dynamic> json) =>
      ContactUsResult(
        id: json["id"],
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "value": value,
      };
}
