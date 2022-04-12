import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/kecamatan_model.dart';

@Entity()
class KelurahanModel {
  int? id = 0;
  String nama;
  int? kecamatanId;

  KelurahanModel({
    this.id,
    required this.nama,
    this.kecamatanId,
  });

  final kecamatan = ToOne<KecamatanModel>();
}
