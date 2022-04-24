import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';

import 'kabupaten_model.dart';
import 'kecamatan_model.dart';
import 'kelurahan_model.dart';

@Entity()
class RespondenModel {
  int? id = 0;
  @Id(assignable: true)
  int kodeUnik;
  int kartuKeluarga;
  String alamat;
  String nomorHp;
  int? provinsiId;
  int? kabupatenId;
  int? kecamatanId;
  int? kelurahanId;
  String lastModified;

  RespondenModel({
    this.id,
    required this.kodeUnik,
    required this.kartuKeluarga,
    required this.alamat,
    required this.nomorHp,
    this.provinsiId,
    this.kabupatenId,
    this.kecamatanId,
    this.kelurahanId,
    required this.lastModified,
  });

  final provinsi = ToOne<ProvinsiModel>();
  final kabupaten = ToOne<KabupatenModel>();
  final kecamatan = ToOne<KecamatanModel>();
  final kelurahan = ToOne<KelurahanModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_unik": kodeUnik.toString(),
        "kartu_keluarga": kartuKeluarga.toString(),
        "alamat": alamat.toString(),
        "provinsi_id": provinsiId.toString(),
        "kabupaten_kota_id": kabupatenId.toString(),
        "kecamatan_id": kecamatanId.toString(),
        "desa_kelurahan_id": kelurahanId.toString(),
        "nomor_hp": nomorHp.toString(),
        "updated_at": lastModified.toString(),
      };
}
