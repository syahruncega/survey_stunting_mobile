// To parse this JSON data, do
//
//     final kecamatan = kecamatanFromJson(jsonString);

import 'dart:convert';

Kecamatan kecamatanFromJson(String str) => Kecamatan.fromJson(json.decode(str));

String kecamatanToJson(Kecamatan data) => json.encode(data.toJson());

class Kecamatan {
  Kecamatan({
    this.message,
    this.data,
  });

  String? message;
  List<DataKecamatan>? data;

  factory Kecamatan.fromJson(Map<String, dynamic> json) => Kecamatan(
        message: json["message"],
        data: List<DataKecamatan>.from(
            json["data"].map((x) => DataKecamatan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataKecamatan {
  DataKecamatan({
    required this.id,
    required this.kabupatenKotaId,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kabupatenKotaId;
  String nama;
  dynamic createdAt;
  dynamic updatedAt;

  factory DataKecamatan.fromJson(Map<String, dynamic> json) => DataKecamatan(
        id: json["id"],
        kabupatenKotaId: json["kabupaten_kota_id"],
        nama: json["nama"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kabupaten_kota_id": kabupatenKotaId,
        "nama": nama,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
