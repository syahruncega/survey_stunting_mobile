// To parse this JSON data, do
//
//     final provinsi = provinsiFromJson(jsonString);

import 'dart:convert';

Provinsi provinsiFromJson(String str) => Provinsi.fromJson(json.decode(str));

String provinsiToJson(Provinsi data) => json.encode(data.toJson());

class Provinsi {
  Provinsi({
    this.message,
    this.data,
  });

  String? message;
  List<DataProvinsi>? data;

  factory Provinsi.fromJson(Map<String, dynamic> json) => Provinsi(
        message: json["message"],
        data: List<DataProvinsi>.from(
            json["data"].map((x) => DataProvinsi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataProvinsi {
  DataProvinsi({
    required this.id,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String nama;
  dynamic createdAt;
  dynamic updatedAt;

  factory DataProvinsi.fromJson(Map<String, dynamic> json) => DataProvinsi(
        id: json["id"],
        nama: json["nama"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
