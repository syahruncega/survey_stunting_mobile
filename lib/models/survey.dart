// To parse this JSON data, do
//
//     final survey = surveyFromJson(jsonString);

import 'dart:convert';

List<Survey> listSurveyFromJson(String str) =>
    List<Survey>.from(json.decode(str).map((x) => Survey.fromJson(x)));

String listSurveyToJson(List<Survey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Survey surveyFromJson(String str) => Survey.fromJson(json.decode(str));

String surveyToJson(Survey data) => json.encode(data.toJson());

class Survey {
  Survey({
    required this.id,
    required this.respondenId,
    required this.namaSurveyId,
    required this.profileId,
    this.kategoriSelanjutnya,
    required this.isSelesai,
    this.createdAt,
    this.updatedAt,
    required this.responden,
    required this.namaSurvey,
    required this.profile,
  });

  int id;
  String respondenId;
  String namaSurveyId;
  String profileId;
  String? kategoriSelanjutnya;
  String isSelesai;
  DateTime? createdAt;
  DateTime? updatedAt;
  Responden responden;
  NamaSurvey namaSurvey;
  Profile profile;

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        id: json["id"],
        respondenId: json["responden_id"],
        namaSurveyId: json["nama_survey_id"],
        profileId: json["profile_id"],
        kategoriSelanjutnya: json["kategori_selanjutnya"],
        isSelesai: json["is_selesai"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        responden: Responden.fromJson(json["responden"]),
        namaSurvey: NamaSurvey.fromJson(json["nama_survey"]),
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "responden_id": respondenId,
        "nama_survey_id": namaSurveyId,
        "profile_id": profileId,
        "kategori_selanjutnya": kategoriSelanjutnya,
        "is_selesai": isSelesai,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "responden": responden.toJson(),
        "nama_survey": namaSurvey.toJson(),
        "profile": profile.toJson(),
      };
}

class NamaSurvey {
  NamaSurvey({
    required this.id,
    required this.nama,
    required this.tipe,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String nama;
  String tipe;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NamaSurvey.fromJson(Map<String, dynamic> json) => NamaSurvey(
        id: json["id"],
        nama: json["nama"],
        tipe: json["tipe"],
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
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Profile {
  Profile({
    required this.id,
    required this.userId,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.provinsi,
    required this.kabupatenKota,
    required this.kecamatan,
    required this.desaKelurahan,
    required this.nomorHp,
    required this.email,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  String namaLengkap;
  String jenisKelamin;
  String tempatLahir;
  DateTime tanggalLahir;
  String alamat;
  String provinsi;
  String kabupatenKota;
  String kecamatan;
  String desaKelurahan;
  String nomorHp;
  String email;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        userId: json["user_id"],
        namaLengkap: json["nama_lengkap"],
        jenisKelamin: json["jenis_kelamin"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        alamat: json["alamat"],
        provinsi: json["provinsi"],
        kabupatenKota: json["kabupaten_kota"],
        kecamatan: json["kecamatan"],
        desaKelurahan: json["desa_kelurahan"],
        nomorHp: json["nomor_hp"],
        email: json["email"],
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
        "user_id": userId,
        "nama_lengkap": namaLengkap,
        "jenis_kelamin": jenisKelamin,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir":
            "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
        "alamat": alamat,
        "provinsi": provinsi,
        "kabupaten_kota": kabupatenKota,
        "kecamatan": kecamatan,
        "desa_kelurahan": desaKelurahan,
        "nomor_hp": nomorHp,
        "email": email,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Responden {
  Responden({
    required this.id,
    required this.kartuKeluarga,
    required this.alamat,
    required this.provinsiId,
    required this.kabupatenKotaId,
    required this.kecamatanId,
    required this.desaKelurahanId,
    required this.nomorHp,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kartuKeluarga;
  String alamat;
  String provinsiId;
  String kabupatenKotaId;
  String kecamatanId;
  String desaKelurahanId;
  String nomorHp;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Responden.fromJson(Map<String, dynamic> json) => Responden(
        id: json["id"],
        kartuKeluarga: json["kartu_keluarga"],
        alamat: json["alamat"],
        provinsiId: json["provinsi_id"],
        kabupatenKotaId: json["kabupaten_kota_id"],
        kecamatanId: json["kecamatan_id"],
        desaKelurahanId: json["desa_kelurahan_id"],
        nomorHp: json["nomor_hp"],
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
        "kartu_keluarga": kartuKeluarga,
        "alamat": alamat,
        "provinsi_id": provinsiId,
        "kabupaten_kota_id": kabupatenKotaId,
        "kecamatan_id": kecamatanId,
        "desa_kelurahan_id": desaKelurahanId,
        "nomor_hp": nomorHp,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
