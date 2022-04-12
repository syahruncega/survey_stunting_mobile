import 'package:objectbox/objectbox.dart';
import 'package:survey_stunting/models/localDb/survey_model.dart';
import 'package:survey_stunting/models/localDb/user_model.dart';

@Entity()
class ProfileModel {
  int id = 0;
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
  String? userId;

  ProfileModel(
      {required this.namaLengkap,
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
      this.userId});

  final user = ToOne<UserModel>();

  @Backlink()
  final survey = ToMany<SurveyModel>();
}
