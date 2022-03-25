import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/custom_elevated_button_icon.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
import 'package:survey_stunting/controllers/tambah_responden_controller.dart';

class TambahRespondenScreen extends StatelessWidget {
  const TambahRespondenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<TambahRespondenController>(
      builder: (controller) => Scaffold(
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
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: size.height * 0.02,
                children: [
                  Text(
                    "Tambah Responden",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  const FilledTextField(
                    title: "Nomor Kartu Keluarga",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                  ),
                  const FilledTextField(
                    title: "Alamat",
                    minLine: 2,
                    maxLine: null,
                    textInputAction: TextInputAction.newline,
                  ),
                  Obx(
                    () => FilledAutocomplete(
                      title: "Provinsi",
                      controller: controller.provinsiTEC,
                      items: controller.provinsi
                          .map((e) => {"label": e.nama, "value": e.id})
                          .toList(),
                      onSuggestionSelected:
                          (Map<String, dynamic> suggestion) async {
                        controller.provinsiTEC.text = suggestion["label"];
                        controller.idProvinsi = suggestion["value"];
                        await controller.getKabupaten();
                      },
                    ),
                  ),
                  Obx(
                    () => FilledAutocomplete(
                      title: "Kabupaten / Kota",
                      controller: controller.kabupatenTEC,
                      items: controller.kabupaten
                          .map((e) => {"label": e.nama, "value": e.id})
                          .toList(),
                      onSuggestionSelected:
                          (Map<String, dynamic> suggestion) async {
                        controller.kabupatenTEC.text = suggestion["label"];
                        controller.idKabupaten = suggestion["value"];
                        await controller.getKecamatan();
                      },
                    ),
                  ),
                  Obx(
                    () => FilledAutocomplete(
                      title: "Kecamatan",
                      controller: controller.kecamatanTEC,
                      items: controller.kecamatan
                          .map((e) => {"label": e.nama, "value": e.id})
                          .toList(),
                      onSuggestionSelected:
                          (Map<String, dynamic> suggestion) async {
                        controller.kecamatanTEC.text = suggestion["label"];
                        controller.idKecamatan = suggestion["value"];
                        await controller.getKelurahan();
                      },
                    ),
                  ),
                  Obx(
                    () => FilledAutocomplete(
                      title: "Desa / Kelurahan",
                      controller: controller.kelurahanTEC,
                      items: controller.kelurahan
                          .map((e) => {"label": e.nama, "value": e.id})
                          .toList(),
                      onSuggestionSelected: (Map<String, dynamic> suggestion) {
                        controller.kelurahanTEC.text = suggestion["label"];
                        controller.idKelurahan = suggestion["value"];
                      },
                    ),
                  ),
                  const FilledTextField(
                    title: "Nomor HP (Optional)",
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                  ),
                  Center(
                    child: CustomElevatedButtonIcon(
                      label: "simpan",
                      icon: SvgPicture.asset(
                        "assets/icons/outline/tick-square.svg",
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
