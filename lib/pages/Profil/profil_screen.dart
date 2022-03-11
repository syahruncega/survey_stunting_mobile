import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            "Update profil, username dan password anda.",
            style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
          ),
          SizedBox(height: size.height * 0.04),
          ListTile(
            leading: SvgPicture.asset(
              "assets/icons/bold/frame.svg",
              height: 26,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Profil"),
            subtitle: const Text("Update informasi profil"),
            onTap: () {},
            dense: true,
            trailing: SvgPicture.asset("assets/icons/outline/arrow-right.svg"),
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/icons/bold/lock.svg",
              height: 26,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Username & Password"),
            subtitle: const Text("Ganti username atau password"),
            onTap: () {},
            dense: true,
            trailing: SvgPicture.asset("assets/icons/outline/arrow-right.svg"),
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/icons/bold/logout.svg",
              height: 26,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Logout"),
            onTap: () {},
            dense: true,
            trailing: SvgPicture.asset("assets/icons/outline/arrow-right.svg"),
          )
        ],
      ),
    );
  }
}
