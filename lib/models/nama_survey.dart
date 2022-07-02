import 'dart:convert';

List<NamaSurvey> listNamaSurveyFromJson(String str) =>
    List<NamaSurvey>.from(json.decode(str).map((x) => NamaSurvey.fromJson(x)));

String listNamaSurveyToJson(List<NamaSurvey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

NamaSurvey namaSurveyFromJson(String str) =>
    NamaSurvey.fromJson(json.decode(str));

String namaSurveyToJson(NamaSurvey data) => json.encode(data.toJson());

class NamaSurvey {
  NamaSurvey({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.isAktif,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String nama;
  String tipe;
  int isAktif;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NamaSurvey.fromJson(Map<String, dynamic> json) => NamaSurvey(
        id: json["id"],
        nama: json["nama"],
        tipe: json["tipe"],
        isAktif: int.parse(json["is_aktif"]),
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
        "nama": nama,
        "tipe": tipe,
        "is_aktif": isAktif,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
