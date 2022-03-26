// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

UserProfile profileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String profileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfile({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
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
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String namaLengkap;
  String jenisKelamin;
  String tempatLahir;
  String tanggalLahir;
  String alamat;
  String provinsi;
  String kabupatenKota;
  String kecamatan;
  String desaKelurahan;
  String nomorHp;
  String email;
  dynamic deletedAt;
  DateTime createdAt;
  dynamic updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        namaLengkap: json["nama_lengkap"],
        jenisKelamin: json["jenis_kelamin"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        alamat: json["alamat"],
        provinsi: json["provinsi"],
        kabupatenKota: json["kabupaten_kota"],
        kecamatan: json["kecamatan"],
        desaKelurahan: json["desa_kelurahan"],
        nomorHp: json["nomor_hp"],
        email: json["email"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nama_lengkap": namaLengkap,
        "jenis_kelamin": jenisKelamin,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "alamat": alamat,
        "provinsi": provinsi,
        "kabupaten_kota": kabupatenKota,
        "kecamatan": kecamatan,
        "desa_kelurahan": desaKelurahan,
        "nomor_hp": nomorHp,
        "email": email,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
      };
}
