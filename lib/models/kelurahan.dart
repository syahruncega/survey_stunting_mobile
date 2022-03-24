// To parse this JSON data, do
//
//     final kelurahan = kelurahanFromJson(jsonString);

import 'dart:convert';

Kelurahan kelurahanFromJson(String str) => Kelurahan.fromJson(json.decode(str));

String kelurahanToJson(Kelurahan data) => json.encode(data.toJson());

class Kelurahan {
  Kelurahan({
    this.message,
    this.data,
  });

  String? message;
  List<DataKelurahan>? data;

  factory Kelurahan.fromJson(Map<String, dynamic> json) => Kelurahan(
        message: json["message"],
        data: List<DataKelurahan>.from(
            json["data"].map((x) => DataKelurahan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataKelurahan {
  DataKelurahan({
    required this.id,
    required this.kecamatanId,
    required this.nama,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kecamatanId;
  String nama;
  dynamic createdAt;
  dynamic updatedAt;

  factory DataKelurahan.fromJson(Map<String, dynamic> json) => DataKelurahan(
        id: json["id"],
        kecamatanId: json["kecamatan_id"],
        nama: json["nama"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kecamatan_id": kecamatanId,
        "nama": nama,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
