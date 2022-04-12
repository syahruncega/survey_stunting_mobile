import 'package:objectbox/objectbox.dart';

import 'kecamatan_model.dart';
import 'provinsi_model.dart';

@Entity()
class KabupatenModel {
  int? id = 0;
  String nama;
  int? provinsiId;

  KabupatenModel({this.id, required this.nama, this.provinsiId});

  @Backlink()
  final kecamatan = ToMany<KecamatanModel>();
  final provinsi = ToOne<ProvinsiModel>();
}
