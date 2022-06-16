import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/routes/route_name.dart';

import '../../models/localDb/helpers.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profil",
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            "Update profil, akun (nama pengguna & kata sandi) anda",
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
          ),
          SizedBox(height: size.height * 0.04),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                "assets/icons/bold/frame.svg",
                height: 26,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Profil"),
            subtitle: const Text(
              "Update informasi profil",
            ),
            onTap: () => Get.toNamed(RouteName.ubahProfil),
            dense: true,
            trailing: SvgPicture.asset(
              "assets/icons/outline/arrow-right.svg",
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                "assets/icons/bold/lock.svg",
                height: 26,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Akun"),
            subtitle: const Text("Ubah informasi akun"),
            onTap: () => Get.toNamed(RouteName.ubahAkun),
            dense: true,
            trailing: SvgPicture.asset(
              "assets/icons/outline/arrow-right.svg",
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                "assets/icons/bold/sincronize.svg",
                height: 26,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Sinkronisasi"),
            subtitle: const Text("Siknronisasi data"),
            onTap: () => Get.toNamed(RouteName.sinkronisasi),
            dense: true,
            trailing: SvgPicture.asset(
              "assets/icons/outline/arrow-right.svg",
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SvgPicture.asset(
                "assets/icons/bold/logout.svg",
                height: 26,
                color: Theme.of(context).errorColor,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Logout"),
            subtitle: const Text("Keluar dari akun anda"),
            onTap: () {
              Get.defaultDialog(
                onConfirm: () async {
                  GetStorage().remove("token");
                  GetStorage().remove("session");
                  await DbHelper.deleteAll(Objectbox.store_);
                  Get.offAllNamed(RouteName.login);
                },
                confirmTextColor: Colors.white,
                title: "Logout",
                middleText:
                    "Anda yakin akan logout? \n Semua data akan terhapus!",
                buttonColor: Theme.of(context).errorColor,
                textConfirm: "Logout",
              );
            },
            dense: true,
          )
        ],
      ),
    );
  }
}
