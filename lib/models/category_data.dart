// To parse this JSON data, do
//
//     final categoryData = categoryDataFromMap(jsonString);

import 'dart:convert';

CategoryData categoryDataFromMap(String str) => CategoryData.fromMap(json.decode(str));

String categoryDataToMap(CategoryData data) => json.encode(data.toMap());

class CategoryData {
  CategoryData({
     this.status,
     this.data,
  });

  String? status;
  List<Datum>? data;

  factory CategoryData.fromMap(Map<String, dynamic> json) => CategoryData(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "data": List<dynamic>.from(data!.map((x) => x.toMap())),
  };
}

class Datum {
  Datum({
     this.id,
     this.categoryType,
     this.startRange,
     this.endRange,
     this.createdAt,
     this.updatedAt,
  });

  int? id;
  String? categoryType;
  String? startRange;
  String? endRange;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryType: json["category_type"],
    startRange: json["start_range"],
    endRange: json["end_range"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "category_type": categoryType,
    "start_range": startRange,
    "end_range": endRange,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
