import 'package:objectbox/objectbox.dart';

import 'kabupaten_model.dart';

@Entity()
class ProvinsiModel {
  @Id(assignable: true)
  int? id = 0;
  String nama;
  String lastModified;

  ProvinsiModel({
    this.id,
    required this.nama,
    required this.lastModified,
  });

  @Backlink()
  final kabupaten = ToMany<KabupatenModel>();
}
