import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/ubah_profil_controller.dart';

class UbahProfilScreen extends StatelessWidget {
  const UbahProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                            Text("Update Profil",
                                style: Theme.of(context).textTheme.headline1),
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            FilledTextField(
                              controller:
                                  controller.namaLengkapTextController.value,
                              title: "Nama Lengkap",
                              errorText: controller.namaLengkapError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledAutocomplete(
                              controller:
                                  controller.jenisKelaminTextController.value,
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
                                controller.jenisKelaminTextController.value
                                    .text = suggestion["value"];
                              },
                            ),
                            FilledTextField(
                              controller:
                                  controller.tempatLahirTextController.value,
                              title: "Tempat Lahir",
                              errorText: controller.tempatLahirError.value,
                              textInputAction: TextInputAction.next,
                            ),
                            FilledTextField(
                              controller:
                                  controller.tglLahirTextController.value,
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
                              controller: controller.alamatTextController.value,
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
                              controller:
                                  controller.nomorHpTextController.value,
                              title: "Nomor HP",
                              errorText: controller.nomorHpError.value,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                controller.nomorHpMaskFormatter
                              ],
                            ),
                            FilledTextField(
                              controller: controller.emailTextController.value,
                              title: "Email",
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
                                  String email =
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
