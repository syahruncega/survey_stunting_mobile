import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/ubah_profil_controller.dart';

class UbahProfilScreen extends StatefulWidget {
  const UbahProfilScreen({Key? key}) : super(key: key);

  @override
  State<UbahProfilScreen> createState() => _UbahProfilScreenState();
}

class _UbahProfilScreenState extends State<UbahProfilScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UbahProfilController ubahProfilController = Get.put(UbahProfilController());
    return GetBuilder<UbahProfilController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: SvgPicture.asset(
                "assets/icons/outline/arrow-left.svg",
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
            // title: Text(
            //   "Dahboard",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
          ),
          body: Obx(
            () => ubahProfilController.isLoaded.value == false
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
                            Text("Update Profil",
                                style: Theme.of(context).textTheme.headline1),
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            FilledTextField(
                              controller:
                                  controller.namaLengkapTextController.value,
                              title: "Nama Lengkap",
                              errorText:
                                  ubahProfilController.namaLengkapError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.jenisKelaminTextController.value,
                              title: "Jenis Kelamin",
                              errorText:
                                  ubahProfilController.jenisKelaminError.value,
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
                                controller.jenisKelaminTextController.value
                                    .text = suggestion["value"];
                              },
                            ),
                            FilledTextField(
                              controller:
                                  controller.tempatLahirTextController.value,
                              title: "Tempat Lahir",
                              errorText:
                                  ubahProfilController.tempatLahirError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledTextField(
                              controller:
                                  controller.tglLahirTextController.value,
                              title: "Tanggal Lahir",
                              errorText:
                                  ubahProfilController.tglLahirError.value,
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                controller.tglLahirMaskFormatter
                              ],
                              helperText: "Contoh: 1998-06-26",
                            ),
                            FilledTextField(
                              controller: controller.alamatTextController.value,
                              title: "Alamat",
                              errorText: ubahProfilController.alamatError.value,
                              minLine: 2,
                              maxLine: null,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.provinsiTextController.value,
                              title: "Provisi",
                              errorText:
                                  ubahProfilController.provinsiError.value,
                              items: ubahProfilController.listProvinsi,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.provinsiTextController.value.text =
                                    suggestion["label"];
                                log('provinsi selected id : ' +
                                    suggestion['value']);
                                controller.updateUserAddressUi(
                                    provinsiId: suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.kabupatenTextController.value,
                              title: "Kabupaten / Kota",
                              items: ubahProfilController.listKabupaten,
                              errorText:
                                  ubahProfilController.kabupatenError.value,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kabupatenTextController.value.text =
                                    suggestion["label"];
                                log('kabupaten selected id : ' +
                                    suggestion['value']);
                                controller.updateUserAddressUi(
                                    kabupatenId: suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.kecamatanTextController.value,
                              title: "Kecamatan",
                              items: ubahProfilController.listKecamatan,
                              errorText:
                                  ubahProfilController.kecamatanError.value,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kecamatanTextController.value.text =
                                    suggestion["label"];
                                log('kecamatan selected id : ' +
                                    suggestion['value']);
                                controller.updateUserAddressUi(
                                    kecamatanId: suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.kelurahanTextController.value,
                              title: "Desa / Kelurahan",
                              items: ubahProfilController.listKelurahan,
                              errorText:
                                  ubahProfilController.kelurahanError.value,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kelurahanTextController.value.text =
                                    suggestion["label"];
                                log('kelurahan selected id : ' +
                                    suggestion['value']);
                                controller.updateUserAddressUi(
                                    kelurahanId: suggestion['value']);
                              },
                            ),
                            FilledTextField(
                              controller:
                                  controller.nomorHpTextController.value,
                              title: "Nomor HP",
                              errorText:
                                  ubahProfilController.nomorHpError.value,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                controller.nomorHpMaskFormatter
                              ],
                            ),
                            FilledTextField(
                              controller: controller.emailTextController.value,
                              title: "Email",
                              errorText: ubahProfilController.emailError.value,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  String namaLengkap = ubahProfilController
                                      .namaLengkapTextController.value.text;
                                  String jenisKelamin = ubahProfilController
                                      .jenisKelaminTextController.value.text;
                                  String tempatLahir = ubahProfilController
                                      .tempatLahirTextController.value.text;
                                  String tglLahir = ubahProfilController
                                      .tglLahirTextController.value.text;
                                  String alamat = ubahProfilController
                                      .alamatTextController.value.text;
                                  String nomorHp = ubahProfilController
                                      .nomorHpTextController.value.text;
                                  String email = ubahProfilController
                                      .emailTextController.value.text;

                                  ubahProfilController
                                              .profileUpdateStatus.value ==
                                          'waiting'
                                      ? null
                                      : ubahProfilController.updateUserProfile(
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
                                icon: ubahProfilController
                                                .profileUpdateStatus.value ==
                                            '' ||
                                        ubahProfilController
                                                .profileUpdateStatus.value ==
                                            'failed' ||
                                        ubahProfilController
                                                .profileUpdateStatus.value ==
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
