import 'package:objectbox/objectbox.dart';

import 'kabupaten_model.dart';

@Entity()
class ProvinsiModel {
  int id = 0;
  String nama;

  ProvinsiModel({required this.nama});

  @Backlink()
  final kabupaten = ToMany<KabupatenModel>();
}
