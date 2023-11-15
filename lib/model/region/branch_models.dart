// To parse this JSON data, do
//
//     final branchModels = branchModelsFromJson(jsonString);

import 'dart:convert';

BranchModels branchModelsFromJson(String str) =>
    BranchModels.fromJson(json.decode(str));

String branchModelsToJson(BranchModels data) => json.encode(data.toJson());

class BranchModels {
  int statusCode;
  List<BranchData> data;

  BranchModels({
    required this.statusCode,
    required this.data,
  });

  factory BranchModels.fromJson(Map<String, dynamic> json) => BranchModels(
        statusCode: json["status_code"],
        data: List<BranchData>.from(
            json["data"].map((x) => BranchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BranchData {
  int id;
  String name;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;

  BranchData({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) => BranchData(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
