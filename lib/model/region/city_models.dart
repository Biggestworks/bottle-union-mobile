// To parse this JSON data, do
//
//     final cityModels = cityModelsFromJson(jsonString);

import 'dart:convert';

CityModels cityModelsFromJson(String str) =>
    CityModels.fromJson(json.decode(str));

String cityModelsToJson(CityModels data) => json.encode(data.toJson());

class CityModels {
  int statusCode;
  List<CityData> data;

  CityModels({
    required this.statusCode,
    required this.data,
  });

  factory CityModels.fromJson(Map<String, dynamic> json) => CityModels(
        statusCode: json["status_code"],
        data:
            List<CityData>.from(json["data"].map((x) => CityData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CityData {
  int id;
  String name;
  int provinceId;
  DateTime createdAt;
  DateTime updatedAt;

  CityData({
    required this.id,
    required this.name,
    required this.provinceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        id: json["id"],
        name: json["name"],
        provinceId: json["province_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "province_id": provinceId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
