// To parse this JSON data, do
//
//     final akun = akunFromJson(jsonString);

import 'dart:convert';

Akun akunFromJson(String str) => Akun.fromJson(json.decode(str));

String akunToJson(Akun data) => json.encode(data.toJson());

class Akun {
  Akun({
    this.message,
    this.data,
  });

  String? message;
  DataAkun? data;

  factory Akun.fromJson(Map<String, dynamic> json) => Akun(
        message: json["message"],
        data: DataAkun.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class DataAkun {
  DataAkun({
    required this.id,
    required this.username,
    required this.password,
    required this.status,
    required this.role,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String username;
  String password;
  String status;
  String role;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory DataAkun.fromJson(Map<String, dynamic> json) => DataAkun(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        status: json["status"],
        role: json["role"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "status": status,
        "role": role,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
