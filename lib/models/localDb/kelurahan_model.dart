import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/kecamatan_model.dart';

@Entity()
class KelurahanModel {
  int id = 0;
  String nama;
  int? kecamatanId;

  KelurahanModel({
    required this.nama,
    this.kecamatanId,
  });

  final kecamatan = ToOne<KecamatanModel>();
}
