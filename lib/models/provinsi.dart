// To parse this JSON data, do
//
//     final provinsi = provinsiFromJson(jsonString);

import 'dart:convert';

List<Provinsi> listProvinsiFromJson(String str) =>
    List<Provinsi>.from(json.decode(str).map((x) => Provinsi.fromJson(x)));

String listProvinsiToJson(List<Provinsi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Provinsi provinsiFromJson(String str) => Provinsi.fromJson(json.decode(str));

String provinsiToJson(Provinsi data) => json.encode(data.toJson());

class Provinsi {
  Provinsi({
    required this.id,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Provinsi.fromJson(Map<String, dynamic> json) => Provinsi(
        id: json["id"],
        nama: json["nama"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
