import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/consts/colors.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';
import 'package:survey_stunting/pages/Beranda/beranda_screen.dart';
import 'package:survey_stunting/pages/Export-Survey/export_survey_screen.dart';
import 'package:survey_stunting/pages/Profil/profil_screen.dart';
import 'package:survey_stunting/pages/Survey/survey_screen.dart';
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
          drawer: const Drawer(),
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
