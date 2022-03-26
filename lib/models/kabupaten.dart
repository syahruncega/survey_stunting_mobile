// To parse this JSON data, do
//
//     final kabupaten = kabupatenFromJson(jsonString);

import 'dart:convert';

List<Kabupaten> listKabupatenFromJson(String str) =>
    List<Kabupaten>.from(json.decode(str).map((x) => Kabupaten.fromJson(x)));

String listKabupatenToJson(List<Kabupaten> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Kabupaten kabupatenFromJson(String str) => Kabupaten.fromJson(json.decode(str));

String kabupatenToJson(Kabupaten data) => json.encode(data.toJson());

class Kabupaten {
  Kabupaten({
    required this.id,
    required this.provinsiId,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String provinsiId;
  String nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Kabupaten.fromJson(Map<String, dynamic> json) => Kabupaten(
        id: json["id"],
        provinsiId: json["provinsi_id"],
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
        "provinsi_id": provinsiId,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
