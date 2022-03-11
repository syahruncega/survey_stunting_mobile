import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class LayoutController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime backbuttonpressedTime = DateTime.now();

  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
