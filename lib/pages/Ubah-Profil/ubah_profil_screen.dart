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
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.jenisKelaminTextController.value,
                              title: "Jenis Kelamin",
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
                              textInputAction: TextInputAction.next,
                            ),
                            FilledTextField(
                              controller:
                                  controller.tglLahirTextController.value,
                              title: "Tanggal Lahir",
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [controller.maskFormatter],
                              helperText: "Contoh: 1998-06-26",
                            ),
                            FilledTextField(
                              controller: controller.alamatTextController.value,
                              title: "Alamat",
                              minLine: 2,
                              maxLine: null,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller: controller.provinsiTextController,
                              title: "Provisi",
                              items: ubahProfilController.listProvinsi,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.provinsiTextController.text =
                                    suggestion["label"];
                                log('provinsi selected id : ' +
                                    suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller: controller.kabupatenTextController,
                              title: "Kabupaten / Kota",
                              items: ubahProfilController.listKabupaten,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kabupatenTextController.text =
                                    suggestion["label"];
                                log('kabupaten selected id : ' +
                                    suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller: controller.kecamatanTextController,
                              title: "Kecamatan",
                              items: ubahProfilController.listKecamatan,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kecamatanTextController.text =
                                    suggestion["label"];
                                log('kecamatan selected id : ' +
                                    suggestion['value']);
                              },
                            ),
                            FilledAutocomplete(
                              controller: controller.kelurahanTextController,
                              title: "Desa / Kelurahan",
                              items: ubahProfilController.listKelurahan,
                              textInputAction: TextInputAction.next,
                              onSuggestionSelected:
                                  (Map<String, dynamic> suggestion) {
                                controller.kelurahanTextController.text =
                                    suggestion["label"];
                                log('kelurahan selected id : ' +
                                    suggestion['value']);
                              },
                            ),
                            FilledTextField(
                              controller:
                                  controller.nomorHpTextController.value,
                              title: "Nomor HP",
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledTextField(
                              controller: controller.emailTextController.value,
                              title: "Email",
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  log(ubahProfilController
                                      .namaLengkapTextController.value.text
                                      .toString());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: SvgPicture.asset(
                                  "assets/icons/outline/tick-square.svg",
                                  color: Colors.white,
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
