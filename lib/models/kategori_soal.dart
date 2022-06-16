// To parse this JSON data, do
//
//     final kategoriSoal = kategoriSoalFromJson(jsonString);

import 'dart:convert';

List<KategoriSoal> listKategoriSoalFromJson(String str) =>
    List<KategoriSoal>.from(
        json.decode(str).map((x) => KategoriSoal.fromJson(x)));

String listKategoriSoalToJson(List<KategoriSoal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

KategoriSoal kategoriSoalFromJson(String str) =>
    KategoriSoal.fromJson(json.decode(str));

String kategoriSoalToJson(KategoriSoal data) => json.encode(data.toJson());

class KategoriSoal {
  KategoriSoal({
    required this.id,
    required this.urutan,
    required this.nama,
    required this.namaSurveyId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String urutan;
  String nama;
  String namaSurveyId;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory KategoriSoal.fromJson(Map<String, dynamic> json) => KategoriSoal(
        id: json["id"],
        urutan: json["urutan"],
        nama: json["nama"],
        namaSurveyId: json["nama_survey_id"],
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
        "urutan": urutan,
        "nama": nama,
        "nama_survey_id": namaSurveyId,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
