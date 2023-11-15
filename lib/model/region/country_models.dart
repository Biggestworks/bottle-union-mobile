// To parse this JSON data, do
//
//     final countryModels = countryModelsFromJson(jsonString);

import 'dart:convert';

CountryModels countryModelsFromJson(String str) =>
    CountryModels.fromJson(json.decode(str));

String countryModelsToJson(CountryModels data) => json.encode(data.toJson());

class CountryModels {
  int statusCode;
  List<CountryData> data;

  CountryModels({
    required this.statusCode,
    required this.data,
  });

  factory CountryModels.fromJson(Map<String, dynamic> json) => CountryModels(
        statusCode: json["status_code"],
        data: List<CountryData>.from(
            json["data"].map((x) => CountryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CountryData {
  int id;
  String code;
  String name;
  int active;
  DateTime createdAt;
  DateTime updatedAt;

  CountryData({
    required this.id,
    required this.code,
    required this.name,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
