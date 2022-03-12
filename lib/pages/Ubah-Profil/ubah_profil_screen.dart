import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_autocomplete.dart';
import 'package:survey_stunting/components/filled_text_field.dart';
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
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            // title: Text(
            //   "Dahboard",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Update Profil",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    const FilledTextField(
                      title: "Nama Lengkap",
                      textInputAction: TextInputAction.next,
                    ),
                    const FilledTextField(
                      title: "Tempat Lahir",
                      textInputAction: TextInputAction.next,
                    ),
                    FilledTextField(
                      title: "Tanggal Lahir",
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [controller.maskFormatter],
                      helperText: "Contoh: 14-01-1998",
                    ),
                    const FilledTextField(
                      title: "Alamat",
                      minLine: 2,
                      maxLine: null,
                      textInputAction: TextInputAction.next,
                    ),
                    FilledAutocomplete(
                      controller: controller.provinsi,
                      title: "Provisi",
                      items: const ["1", "2"],
                      textInputAction: TextInputAction.next,
                    ),
                    FilledAutocomplete(
                      controller: controller.kabupatan,
                      title: "Kabupaten / Kota",
                      items: const ["1", "2"],
                      textInputAction: TextInputAction.next,
                    ),
                    FilledAutocomplete(
                      controller: controller.kecamatan,
                      title: "Kecamatan",
                      items: const ["1", "2"],
                      textInputAction: TextInputAction.next,
                    ),
                    FilledAutocomplete(
                      controller: controller.kelurahan,
                      title: "Desa / Kelurahan",
                      items: const ["1", "2"],
                      textInputAction: TextInputAction.next,
                    ),
                    const FilledTextField(
                      title: "Nomor HP",
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const FilledTextField(
                      title: "Email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: SvgPicture.asset(
                            "assets/icons/outline/tick-square.svg",
                            color: Theme.of(context).backgroundColor),
                        label: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
