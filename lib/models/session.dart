// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  Data data;
  String token;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        message: json["message"],
        data: Data.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.password,
    required this.status,
    required this.role,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String username;
  String password;
  String status;
  String role;
  dynamic deletedAt;
  dynamic createdAt;
  dynamic updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        "password": password,
        "status": status,
        "role": role,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
