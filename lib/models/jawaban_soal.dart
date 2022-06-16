// To parse this JSON data, do
//
//     final jawabanSoal = jawabanSoalFromJson(jsonString);

import 'dart:convert';

List<JawabanSoal> listJawabanSoalFromJson(String str) => List<JawabanSoal>.from(
    json.decode(str).map((x) => JawabanSoal.fromJson(x)));

String listJawabanSoalToJson(List<JawabanSoal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

JawabanSoal jawabanSoalFromJson(String str) =>
    JawabanSoal.fromJson(json.decode(str));

String jawabanSoalToJson(JawabanSoal data) => json.encode(data.toJson());

class JawabanSoal {
  JawabanSoal({
    required this.id,
    required this.jawaban,
    required this.soalId,
    required this.isLainnya,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String jawaban;
  String soalId;
  String isLainnya;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory JawabanSoal.fromJson(Map<String, dynamic> json) => JawabanSoal(
        id: json["id"],
        jawaban: json["jawaban"],
        soalId: json["soal_id"],
        isLainnya: json["is_lainnya"],
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
        "jawaban": jawaban,
        "soal_id": soalId,
        "is_lainnya": isLainnya,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
