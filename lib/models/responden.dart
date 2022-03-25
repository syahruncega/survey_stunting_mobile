import 'dart:convert';

List<Responden> listRespondenFromJson(String str) =>
    List<Responden>.from(json.decode(str).map((x) => Responden.fromJson(x)));

String listRespondenToJson(List<Responden> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Responden respondenFromJson(String str) => Responden.fromJson(json.decode(str));

String respondenToJson(Responden data) => json.encode(data.toJson());

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
