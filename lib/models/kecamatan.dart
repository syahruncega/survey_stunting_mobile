// To parse this JSON data, do
//
//     final kecamatan = kecamatanFromJson(jsonString);

import 'dart:convert';

List<Kecamatan> listKecamatanFromJson(String str) =>
    List<Kecamatan>.from(json.decode(str).map((x) => Kecamatan.fromJson(x)));

String listKecamatanToJson(List<Kecamatan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Kecamatan kecamatanFromJson(String str) => Kecamatan.fromJson(json.decode(str));

String kecamatanToJson(Kecamatan data) => json.encode(data.toJson());

class Kecamatan {
  Kecamatan({
    required this.id,
    required this.kabupatenKotaId,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kabupatenKotaId;
  String nama;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Kecamatan.fromJson(Map<String, dynamic> json) => Kecamatan(
        id: json["id"],
        kabupatenKotaId: json["kabupaten_kota_id"],
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
        "kabupaten_kota_id": kabupatenKotaId,
        "nama": nama,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
