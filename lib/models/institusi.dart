// To parse this JSON data, do
//
//     final institusi = institusiFromJson(jsonString);

import 'dart:convert';

List<Institusi> institusiFromJson(String str) =>
    List<Institusi>.from(json.decode(str).map((x) => Institusi.fromJson(x)));

String institusiToJson(List<Institusi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Institusi {
  Institusi({
    required this.id,
    required this.nama,
    required this.alamat,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  String nama;
  String alamat;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  factory Institusi.fromJson(Map<String, dynamic> json) => Institusi(
        id: json["id"],
        nama: json["nama"],
        alamat: json["alamat"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "alamat": alamat,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
