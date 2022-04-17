import 'package:objectbox/objectbox.dart';

import 'kabupaten_model.dart';
import 'kelurahan_model.dart';

@Entity()
class KecamatanModel {
  int? id = 0;
  String nama;
  int? kabupatenId;
  String lastModified;

  KecamatanModel({
    this.id,
    required this.nama,
    this.kabupatenId,
    required this.lastModified,
  });

  @Backlink()
  final kelurahan = ToMany<KelurahanModel>();
  final kabupaten = ToOne<KabupatenModel>();
}
