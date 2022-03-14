import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';
import 'package:survey_stunting/pages/Beranda/beranda_screen.dart';
import 'package:survey_stunting/pages/Export-Survey/export_survey_screen.dart';
import 'package:survey_stunting/pages/Profil/profil_screen.dart';
import 'package:survey_stunting/pages/Survey/survey_screen.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

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
          body: WillPopScope(
            onWillPop: controller.onWillPop,
            child: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: [
                  const BerandaScreen(),
                  SurveyScreen(),
                  ExportSurveyScreen(),
                  const ProfilScreen(),
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
