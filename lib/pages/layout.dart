import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:survey_stunting/controllers/layout_controller.dart';
import 'package:survey_stunting/pages/Beranda/beranda_screen.dart';
import 'package:survey_stunting/pages/Export-Survey/export_survey_screen.dart';
import 'package:survey_stunting/pages/Profil/profil_screen.dart';
import 'package:survey_stunting/pages/Survey/survey_screen.dart';

class Layout extends StatelessWidget {
  Layout({Key? key}) : super(key: key);
  final layoutController = Get.find<LayoutController>();

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton =
        currentTime.difference(layoutController.backbuttonpressedTime) >
            const Duration(milliseconds: 1500);

    if (backButton) {
      layoutController.backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
        msg: "Tekan sekali lagi untuk keluar",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: layoutController.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/icons/outline/menu.svg",
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        // title: Text(
        //   "Dahboard",
        //   style: Theme.of(context).textTheme.titleLarge,
        // ),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: IndexedStack(
            index: layoutController.tabIndex,
            children: [
              const BerandaScreen(),
              const SurveyScreen(),
              ExportSurveyScreen(),
              const ProfilScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: layoutController.changeTabIndex,
        currentIndex: layoutController.tabIndex,
        type: BottomNavigationBarType.fixed,
        // showUnselectedLabels: false,
        // showSelectedLabels: false,
        elevation: 20,
        items: [
          BottomNavigationBarItem(
            label: 'Beranda',
            icon: SvgPicture.asset(
              "assets/icons/outline/home.svg",
              color: Theme.of(context).hintColor.withAlpha(100),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/bold/home.svg",
              color: Theme.of(context).primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Survey',
            icon: SvgPicture.asset(
              "assets/icons/outline/note.svg",
              color: Theme.of(context).hintColor.withAlpha(100),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/bold/note.svg",
              color: Theme.of(context).primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Export',
            icon: SvgPicture.asset(
              "assets/icons/outline/document-download.svg",
              color: Theme.of(context).hintColor.withAlpha(100),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/bold/document-download.svg",
              color: Theme.of(context).primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profil',
            icon: SvgPicture.asset(
              "assets/icons/outline/frame.svg",
              color: Theme.of(context).hintColor.withAlpha(100),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/bold/frame.svg",
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
