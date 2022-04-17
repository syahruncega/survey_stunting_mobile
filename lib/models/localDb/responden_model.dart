import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/provinsi_model.dart';

import 'kabupaten_model.dart';
import 'kecamatan_model.dart';
import 'kelurahan_model.dart';

@Entity()
class RespondenModel {
  int? id = 0;
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
}
