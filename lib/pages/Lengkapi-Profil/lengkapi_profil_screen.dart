import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/consts/colors.dart';

import '../../controllers/lengkapi_profil_controller.dart';

class LengkapiProfilScreen extends StatelessWidget {
  const LengkapiProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<LengkapiProfilController>(
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => controller.isLoaded.value == false
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: size.height * 0.02,
                          children: [
                            Center(
                              child: Text("Lengkapi Profil",
                                  style: Theme.of(context).textTheme.headline1),
                            ),
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            Obx(
                              () => FilledAutocomplete(
                                controller: controller.institusiTextController,
                                hintText: "Pilih Institusi",
                                title: "Institusi",
                                errorText: controller.namaInstitusiError.value,
                                items: controller.institusi
                                    .map(
                                        (e) => {"label": e.nama, "value": e.id})
                                    .toList(),
                                textInputAction: TextInputAction.next,
                                onSuggestionSelected:
                                    (Map<String, dynamic> suggestion) async {
                                  controller.institusiTextController.text =
                                      suggestion["label"];
                                  controller.institusiId = suggestion["value"];
                                },
                              ),
                            ),
                            FilledTextField(
                              controller: controller.namaLengkapTextController,
                              title: "Nama Lengkap",
                              errorText: controller.namaLengkapError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller: controller.jenisKelaminTextController,
                              title: "Jenis Kelamin",
                              errorText: controller.jenisKelaminError.value,
                              items: const [
                                {
                                  "label": "Laki - laki",
                                  "value": "Laki - laki"
                                },
                                {"label": "Perempuan", "value": "Perempuan"}
                              ],
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.jenisKelaminTextController.text =
                                    suggestion["value"];
                              },
                            ),
                            FilledTextField(
                              controller: controller.tempatLahirTextController,
                              title: "Tempat Lahir",
                              errorText: controller.tempatLahirError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledTextField(
                              controller: controller.tglLahirTextController,
                              title: "Tanggal Lahir",
                              errorText: controller.tglLahirError.value,
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                controller.tglLahirMaskFormatter
                              ],
                              helperText: "Contoh: 1998-06-26",
                            ),
                            FilledTextField(
                              controller: controller.alamatTextController,
                              title: "Alamat",
                              errorText: controller.alamatError.value,
                              minLine: 2,
                              maxLine: null,
                              textInputAction: TextInputAction.next,
                            ),
                            Obx(
                              () => FilledAutocomplete(
                                controller: controller.provinsiTEC,
                                hintText: "Pilih Provinsi",
                                title: "Provisi",
                                errorText: controller.provinsiError.value,
                                items: controller.provinsi
                                    .map(
                                        (e) => {"label": e.nama, "value": e.id})
                                    .toList(),
                                textInputAction: TextInputAction.next,
                                onSuggestionSelected:
                                    (Map<String, dynamic> suggestion) async {
                                  controller.provinsiTEC.text =
                                      suggestion["label"];
                                  controller.provinsiId = suggestion["value"];
                                  await controller.getKabupaten();
                                },
                              ),
                            ),
                            Obx(
                              () => FilledAutocomplete(
                                controller: controller.kabupatenTEC,
                                hintText: "Pilih Kabupaten / Kota",
                                title: "Kabupaten / Kota",
                                enabled: controller.provinsiId != 0,
                                items: controller.kabupaten
                                    .map(
                                        (e) => {"label": e.nama, "value": e.id})
                                    .toList(),
                                errorText: controller.kabupatenError.value,
                                textInputAction: TextInputAction.next,
                                onSuggestionSelected:
                                    (Map<String, dynamic> suggestion) async {
                                  controller.kabupatenTEC.text =
                                      suggestion["label"];
                                  controller.kabupatenId = suggestion["value"];
                                  await controller.getKecamatan();
                                },
                              ),
                            ),
                            Obx(
                              () => FilledAutocomplete(
                                controller: controller.kecamatanTEC,
                                title: "Kecamatan",
                                hintText: "Pilih kecamatan",
                                enabled: controller.kabupatenId != 0,
                                items: controller.kecamatan
                                    .map(
                                        (e) => {"label": e.nama, "value": e.id})
                                    .toList(),
                                errorText: controller.kecamatanError.value,
                                textInputAction: TextInputAction.next,
                                onSuggestionSelected:
                                    (Map<String, dynamic> suggestion) async {
                                  controller.kecamatanTEC.text =
                                      suggestion["label"];
                                  controller.kecamatanId = suggestion["value"];
                                  await controller.getKelurahan();
                                },
                              ),
                            ),
                            Obx(
                              () => FilledAutocomplete(
                                controller: controller.kelurahanTEC,
                                title: "Desa / Kelurahan",
                                hintText: "Pilih Desa / Kelurahan",
                                enabled: controller.kecamatanId != 0,
                                items: controller.kelurahan
                                    .map(
                                        (e) => {"label": e.nama, "value": e.id})
                                    .toList(),
                                errorText: controller.kelurahanError.value,
                                textInputAction: TextInputAction.next,
                                onSuggestionSelected:
                                    (Map<String, dynamic> suggestion) {
                                  controller.kelurahanTEC.text =
                                      suggestion["label"];
                                  controller.kelurahanId = suggestion["value"];
                                },
                              ),
                            ),
                            FilledTextField(
                              controller: controller.nomorHpTextController,
                              title: "Nomor HP",
                              errorText: controller.nomorHpError.value,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                controller.nomorHpMaskFormatter
                              ],
                            ),
                            FilledTextField(
                              controller: controller.emailTextController,
                              title: "Email (Optional)",
                              errorText: controller.emailError.value,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  String namaLengkap = controller
                                      .namaLengkapTextController.value.text;
                                  String jenisKelamin = controller
                                      .jenisKelaminTextController.value.text;
                                  String tempatLahir = controller
                                      .tempatLahirTextController.value.text;
                                  String tglLahir = controller
                                      .tglLahirTextController.value.text;
                                  String alamat = controller
                                      .alamatTextController.value.text;
                                  String nomorHp = controller
                                      .nomorHpTextController.value.text;
                                  String? email =
                                      controller.emailTextController.value.text;

                                  controller.profileUpdateStatus.value ==
                                          'waiting'
                                      ? null
                                      : controller.updateUserProfile(
                                          nama: namaLengkap,
                                          jenisKelamin: jenisKelamin,
                                          tempatLahir: tempatLahir,
                                          tglLahir: tglLahir,
                                          alamat: alamat,
                                          nomorHp: nomorHp,
                                          email: email);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: controller.profileUpdateStatus.value ==
                                            '' ||
                                        controller.profileUpdateStatus.value ==
                                            'failed' ||
                                        controller.profileUpdateStatus.value ==
                                            'successful'
                                    ? SvgPicture.asset(
                                        "assets/icons/outline/tick-square.svg",
                                        color: Colors.white,
                                      )
                                    : Container(
                                        width: 24,
                                        height: 24,
                                        padding: const EdgeInsets.all(2.0),
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                label: Text(
                                  "Simpan",
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
