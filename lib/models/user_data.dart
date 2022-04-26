// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'dart:convert';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
  UserData({
    this.status,
    this.token,
    this.data,
  });

  String? status;
  String? token;
  Data? data;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    status: json["status"],
    token: json["token"],
    data: Data.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "token": token,
    "data": data!.toMap(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.roleId,
    this.cityId,
    this.status,
    this.activeStatus,
    this.timezone,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  String? contact;
  int? roleId;
  int? cityId;
  int? status;
  int? activeStatus;
  String? timezone;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    contact: json["contact"],
    roleId: json["role_id"],
    cityId: json["city_id"],
    status: json["status"],
    activeStatus: json["active_status"],
    timezone: json["timezone"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "contact": contact,
    "role_id": roleId,
    "city_id": cityId,
    "status": status,
    "active_status": activeStatus,
    "timezone": timezone,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
