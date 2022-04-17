import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';
import 'package:survey_stunting/models/localDb/user_model.dart';

@Entity()
class ProfileModel {
  @Id(assignable: true)
  int? id = 0;
  String namaLengkap;
  String jenisKelamin;
  String tempatLahir;
  String tanggalLahir;
  String alamat;
  String provinsiId;
  String kabupatenId;
  String kecamatanId;
  String kelurahanId;
  String nomorHp;
  String email;
  int? userId;
  String lastModified;

  ProfileModel({
    this.id,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.provinsiId,
    required this.kabupatenId,
    required this.kecamatanId,
    required this.kelurahanId,
    required this.nomorHp,
    required this.email,
    this.userId,
    required this.lastModified,
  });

  final user = ToOne<UserModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();
}
