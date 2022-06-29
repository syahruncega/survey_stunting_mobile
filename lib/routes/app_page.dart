import 'package:get/get.dart';
import 'package:survey_stunting/bindings/detail_survey_binding.dart';
import 'package:survey_stunting/bindings/isi_survey_binding.dart';
import 'package:survey_stunting/bindings/layout_binding.dart';
import 'package:survey_stunting/bindings/lengkapi_profil_binding.dart';
import 'package:survey_stunting/bindings/login_binding.dart';
import 'package:survey_stunting/bindings/tambah_responden_binding.dart';
import 'package:survey_stunting/bindings/ubah_akun_binding.dart';
import 'package:survey_stunting/bindings/ubah_profil_binding.dart';
import 'package:survey_stunting/pages/Detail-Survey/detail_survey_screen.dart';
import 'package:survey_stunting/pages/Isi-Survey/isi_survey_screen.dart';
import 'package:survey_stunting/pages/Login/login_screen.dart';
import 'package:survey_stunting/pages/Sinkronisasi/sinkronisasi_screen.dart';
import 'package:survey_stunting/pages/Tambah-Responden/tambah_responden_screen.dart';
import 'package:survey_stunting/pages/Ubah-Akun/ubah_akun_screen.dart';
import 'package:survey_stunting/pages/Ubah-Profil/ubah_profil_screen.dart';
import 'package:survey_stunting/pages/layout.dart';
import 'package:survey_stunting/routes/route_name.dart';

import '../bindings/sinkronisasi_binding.dart';
import '../pages/Lengkapi-Profil/lengkapi_profil_screen.dart';

class AppPage {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.layout,
      page: () => Layout(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: RouteName.tambahResponden,
      page: () => const TambahRespondenScreen(),
      binding: TambahRespondenBinding(),
    ),
    GetPage(
      name: RouteName.isiSurvey,
      page: () => const IsiSurveyScreen(),
      binding: IsiSurveyBinding(),
    ),
    GetPage(
      name: RouteName.detailSurvey,
      page: () => const DetailSurveyScreen(),
      binding: DetailSurveyBinding(),
    ),
    GetPage(
      name: RouteName.ubahProfil,
      page: () => const UbahProfilScreen(),
      binding: UbahProfilBinding(),
    ),
    GetPage(
      name: RouteName.ubahAkun,
      page: () => const UbahAkunScreen(),
      binding: UbahAkunBinding(),
    ),
    GetPage(
      name: RouteName.sinkronisasi,
      page: () => const SinkronisasiScreen(),
      binding: SinkronisasiBinding(),
    ),
    GetPage(
      name: RouteName.lengkapiProfil,
      page: () => const LengkapiProfilScreen(),
      binding: LengkapiProfilBinding(),
    ),
  ];
}
