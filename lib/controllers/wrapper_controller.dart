import 'package:first_project_test/screens/additional_screens/search.dart';
import 'package:first_project_test/screens/home/collections.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:first_project_test/screens/home/profile.dart';
import 'package:first_project_test/screens/home/record.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WrapperController extends GetxController {
  PageController pageController = PageController(
    initialPage: 0,
  );
  Rx<int> currentIndex = 0.obs;
  // TODO implement logic
  bool showDrawer = true;
  Rx<String> recordLabelText = 'Запись'.obs;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  List<Widget> pages = [
    Home(),
    Compilations(),
    Record(),
    Search(),
    Profile(),
    // additional_screens
    Search(),
  ];

  void goTo(int page) {
    // currentIndex.value = 0;
    pageController.jumpToPage(page);
    print('current index: $currentIndex');
  }

  onPageChanged(page){
    if (page < 5)
      currentIndex.value = page;
    else
      currentIndex.value = 0;
    // if (page == 1) {
    //   showDrawer = false;
    // } else {
    //   showDrawer = true;
    // }
    if (currentIndex == 2) {
      recordLabelText.value = '';
    } else {
      recordLabelText.value = 'Запись';
    }
    print('current index now is: $currentIndex, so it must be changed');
  }
}
