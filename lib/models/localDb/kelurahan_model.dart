import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/kecamatan_model.dart';

@Entity()
class KelurahanModel {
  int? id = 0;
  String nama;
  int? kecamatanId;
  String lastModified;

  KelurahanModel({
    this.id,
    required this.nama,
    this.kecamatanId,
    required this.lastModified,
  });

  final kecamatan = ToOne<KecamatanModel>();
}
