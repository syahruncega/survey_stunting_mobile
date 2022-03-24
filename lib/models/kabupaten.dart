// To parse this JSON data, do
//
//     final kabupaten = kabupatenFromJson(jsonString);

import 'dart:convert';

Kabupaten kabupatenFromJson(String str) => Kabupaten.fromJson(json.decode(str));

String kabupatenToJson(Kabupaten data) => json.encode(data.toJson());

class Kabupaten {
  Kabupaten({
    this.message,
    this.data,
  });

  String? message;
  List<DataKabupaten>? data;

  factory Kabupaten.fromJson(Map<String, dynamic> json) => Kabupaten(
        message: json["message"],
        data: List<DataKabupaten>.from(
            json["data"].map((x) => DataKabupaten.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataKabupaten {
  DataKabupaten({
    required this.id,
    required this.provinsiId,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String provinsiId;
  String nama;
  dynamic createdAt;
  dynamic updatedAt;

  factory DataKabupaten.fromJson(Map<String, dynamic> json) => DataKabupaten(
        id: json["id"],
        provinsiId: json["provinsi_id"],
        nama: json["nama"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provinsi_id": provinsiId,
        "nama": nama,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
