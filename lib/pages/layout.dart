import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';
import 'package:survey_stunting/models/localDb/helpers.dart';
import 'package:survey_stunting/pages/Beranda/beranda_screen.dart';
import 'package:survey_stunting/pages/Export-Survey/export_survey_screen.dart';
import 'package:survey_stunting/pages/Profil/profil_screen.dart';
import 'package:survey_stunting/pages/Survey/survey_screen.dart';
import 'package:survey_stunting/routes/route_name.dart';
import '../../consts/globals_lib.dart' as global;
import '../components/synchronize_dialog.dart';

class Layout extends StatelessWidget {
  Layout({Key? key}) : super(key: key);
  final screens = [
    const BerandaScreen(),
    const SurveyScreen(),
    const ExportSurveyScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutController>(
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: controller.openDrawer,
              icon: SvgPicture.asset(
                "assets/icons/outline/menu.svg",
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              // statusBarColor: Theme.of(context).primaryColor,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            // title: Text(
            //   "Dahboard",
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
          ),
          body: Obx(
            () => WillPopScope(
              onWillPop: controller.onWillPop,
              child: Stack(
                children: <Widget>[
                  SafeArea(
                    child: screens[controller.tabIndex],
                  ),
                  AnimatedOpacity(
                    opacity: global.isFabVisible.value ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FloatingActionButton(
                              child: SvgPicture.asset(
                                "assets/icons/outline/cloud-data-sync.svg",
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                              backgroundColor: primaryColor,
                              onPressed: () async {
                                await synchronizeDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 60, 14, 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: CircleAvatar(
                              child: Text(controller.session.data.username[0]
                                  .toUpperCase()),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: Text(
                            controller.session.data.username,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                          subtitle: Text(controller.session.data.role),
                          onTap: null,
                          dense: true,
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            "Mode malam",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          secondary: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: SvgPicture.asset(
                                "assets/icons/bulk/moon.svg",
                                height: 26,
                                color: Colors.indigoAccent,
                              ),
                            ),
                          ),
                          value: controller.isDarkTheme.value,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onChanged: (value) {
                            controller.isDarkTheme.value = value;
                            Get.changeThemeMode(
                              controller.isDarkTheme.value
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                            );
                          },
                        )
                      ],
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            "assets/icons/bold/logout.svg",
                            height: 26,
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text("Logout"),
                      subtitle: const Text("Keluar dari akun anda"),
                      onTap: () {
                        Get.defaultDialog(
                          onConfirm: () async {
                            GetStorage().remove("token");
                            GetStorage().remove("userId");
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
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: controller.changeTabIndex,
            currentIndex: controller.tabIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).hintColor.withAlpha(150),
            type: BottomNavigationBarType.fixed,
            // showUnselectedLabels: false,
            // showSelectedLabels: false,
            elevation: 20,
            items: [
              BottomNavigationBarItem(
                label: 'Beranda',
                icon: SvgPicture.asset(
                  "assets/icons/outline/home.svg",
                  color: Theme.of(context).hintColor.withAlpha(150),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/bold/home.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Survey',
                icon: SvgPicture.asset(
                  "assets/icons/outline/note.svg",
                  color: Theme.of(context).hintColor.withAlpha(150),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/bold/note.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Export',
                icon: SvgPicture.asset(
                  "assets/icons/outline/document-download.svg",
                  color: Theme.of(context).hintColor.withAlpha(150),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/bold/document-download.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profil',
                icon: SvgPicture.asset(
                  "assets/icons/outline/frame.svg",
                  color: Theme.of(context).hintColor.withAlpha(150),
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/bold/frame.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
