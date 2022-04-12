import 'package:objectbox/objectbox.dart';

import 'kabupaten_model.dart';
import 'kelurahan_model.dart';

@Entity()
class KecamatanModel {
  int id = 0;
  String nama;
  int? kabupatenId;

  KecamatanModel({required this.nama, this.kabupatenId});

  @Backlink()
  final kelurahan = ToMany<KelurahanModel>();
  final kabupaten = ToOne<KabupatenModel>();
}
