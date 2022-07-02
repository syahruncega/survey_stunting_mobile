import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';

import 'kabupaten_model.dart';
import 'kecamatan_model.dart';
import 'kelurahan_model.dart';

@Entity()
class RespondenModel {
  @Id(assignable: true)
  int? id = 0;
  int kodeUnik;
  int kartuKeluarga;
  String namaKepalaKeluarga;
  String alamat;
  String? nomorHp;
  int? provinsiId;
  int? kabupatenId;
  int? kecamatanId;
  int? kelurahanId;
  String lastModified;
  String? deletedAt;

  RespondenModel({
    this.id,
    required this.kodeUnik,
    required this.kartuKeluarga,
    required this.alamat,
    required this.namaKepalaKeluarga,
    this.nomorHp,
    this.provinsiId,
    this.kabupatenId,
    this.kecamatanId,
    this.kelurahanId,
    required this.lastModified,
    this.deletedAt,
  });

  final provinsi = ToOne<ProvinsiModel>();
  final kabupaten = ToOne<KabupatenModel>();
  final kecamatan = ToOne<KecamatanModel>();
  final kelurahan = ToOne<KelurahanModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();

  factory RespondenModel.fromJson(Map<String, dynamic> json) => RespondenModel(
        id: json["id"],
        kodeUnik: int.parse(json["kode_unik"]),
        kartuKeluarga: int.parse(json["kartu_keluarga"]),
        alamat: json["alamat"],
        namaKepalaKeluarga: json["nama_kepala_keluarga"],
        provinsiId: int.parse(json["provinsi_id"]),
        kabupatenId: int.parse(json["kabupaten_kota_id"]),
        kecamatanId: int.parse(json["kecamatan_id"]),
        kelurahanId: int.parse(json["desa_kelurahan_id"]),
        nomorHp: json["nomor_hp"],
        lastModified: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_unik": kodeUnik.toString(),
        "kartu_keluarga": kartuKeluarga.toString(),
        "alamat": alamat.toString(),
        "nama_kepala_keluarga": namaKepalaKeluarga.toString(),
        "provinsi_id": provinsi.targetId.toString(),
        "kabupaten_kota_id": kabupaten.targetId.toString(),
        "kecamatan_id": kecamatan.targetId.toString(),
        "desa_kelurahan_id": kelurahan.targetId.toString(),
        "nomor_hp": nomorHp.toString(),
        "updated_at": lastModified.toString(),
        "deleted_at": deletedAt != "null" ? deletedAt : null,
      };
}
