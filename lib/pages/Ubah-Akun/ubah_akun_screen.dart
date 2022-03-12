import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/components/filled_text_field.dart';

class UbahAkunScreen extends StatelessWidget {
  const UbahAkunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ubah Akun",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              const FilledTextField(
                title: "Nama Pengguna",
                textInputAction: TextInputAction.next,
              ),
              const FilledTextField(
                title: "Kata Sandi",
                obsecureText: true,
                textInputAction: TextInputAction.next,
                helperText:
                    "Biarkan kosong apabila tidak ingin mengubah kata sandi.",
              ),
              const FilledTextField(
                title: "Konfirmasi Kata Sandi",
                obsecureText: true,
                textInputAction: TextInputAction.done,
                helperText:
                    "Biarkan kosong apabila tidak ingin mengubah kata sandi.",
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: SvgPicture.asset("assets/icons/outline/tick-square.svg",
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
    );
  }
}
