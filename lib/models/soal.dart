// To parse this JSON data, do
//
//     final soal = soalFromJson(jsonString);

import 'dart:convert';

List<Soal> listSoalFromJson(String str) =>
    List<Soal>.from(json.decode(str).map((x) => Soal.fromJson(x)));

String listSoalToJson(List<Soal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Soal soalFromJson(String str) => Soal.fromJson(json.decode(str));

String soalToJson(Soal data) => json.encode(data.toJson());

class Soal {
  Soal({
    required this.id,
    required this.soal,
    required this.urutan,
    required this.tipeJawaban,
    required this.isNumerik,
    required this.kategoriSoalId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String soal;
  String urutan;
  String tipeJawaban;
  String isNumerik;
  String kategoriSoalId;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Soal.fromJson(Map<String, dynamic> json) => Soal(
        id: json["id"],
        soal: json["soal"],
        urutan: json["urutan"],
        tipeJawaban: json["tipe_jawaban"],
        isNumerik: json["is_numerik"],
        kategoriSoalId: json["kategori_soal_id"],
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "soal": soal,
        "urutan": urutan,
        "tipe_jawaban": tipeJawaban,
        "is_numerik": isNumerik,
        "kategori_soal_id": kategoriSoalId,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
