import 'package:first_project_test/controllers/wrapper_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _wrapperController = Get.put(WrapperController());
  var drawerColor = Color(0xff3A3A55);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // restorationId: "root",
      extendBody: true,
      // TODO implement logic
      drawerEnableOpenDragGesture: _wrapperController.showDrawer,
      // drawerEnableOpenDragGesture: showDrawer,
      bottomNavigationBar: _getBottomNavigationBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _wrapperController.pageController,
        onPageChanged: (page) {
          _wrapperController.onPageChanged(page);
        },
        // children: _wrapperController.pages,
        children: _wrapperController.pages,
      ),
      drawer: _getDrawer(),
    );
  }

  Widget _getDrawer() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Drawer(
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Аудисказки',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Меню',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xd93A3A5580),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 70,
                left: 30,
                right: 50,
              ),
              child: Column(
                children: [
                  _getDrawerButton(
                    'assets/home.svg',
                    'Главная',
                    0,
                  ),
                  SizedBox(height: 15),
                  _getDrawerButton(
                    'assets/profile.svg',
                    'Профиль',
                    4,
                  ),
                  SizedBox(height: 15),
                  _getDrawerButton(
                    'assets/category.svg',
                    'Подборки',
                    1,
                  ),
                  SizedBox(height: 15),
                  _getDrawerButton(
                    'assets/paper.svg',
                    'Все аудиофалы',
                    3,
                  ),
                  SizedBox(height: 15),
                  _getDrawerButton(
                    'assets/search.svg',
                    'Поиск',
                    5,
                  ),
                  SizedBox(height: 15),
                  _getDrawerButton(
                    'assets/delete.svg',
                    'Недавно удаленные',
                    0,
                  ),
                  SizedBox(height: 40),
                  _getDrawerButton(
                    'assets/wallet.svg',
                    'Подписка',
                    0,
                  ),
                  SizedBox(height: 40),
                  _getDrawerButton(
                    'assets/edit.svg',
                    'Написать в поддержку',
                    0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDrawerButton(String asset, String text, int page) {
    return InkWell(
      onTap: () {
        _wrapperController.goTo(page);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            // style: TextStyle(color: Colors.black, fontSize: 18),
            children: [
              WidgetSpan(
                child: Container(
                  width: 50,
                  child: Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      asset,
                      color: drawerColor,
                    ),
                  ),
                ),
              ),
              WidgetSpan(
                child: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              // TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 5,
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: Obx(
          () => BottomNavigationBar(
            // currentIndex: currentIndex,
            currentIndex: _wrapperController.currentIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: Color(0xff8c84e2),
            iconSize: 30,
            onTap: (value) {
              _wrapperController.goTo(value);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/home.svg',
                  color: Color(0xff8c84e2),
                ),
                icon: SvgPicture.asset(
                  'assets/home.svg',
                  color: Color(0x803A3A55CC),
                ),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/category.svg',
                  color: Color(0xff8c84e2),
                ),
                icon: SvgPicture.asset(
                  'assets/category.svg',
                  color: Color(0x803A3A55CC),
                ),
                label: 'Подборки',
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/record.svg',
                  color: Color(0xffF1B488),
                ),
                icon: SvgPicture.asset(
                  'assets/record.svg',
                ),
                // label: recordLabelText,
                label: _wrapperController.recordLabelText.value,
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/paper.svg',
                  color: Color(0xff8c84e2),
                ),
                icon: SvgPicture.asset(
                  'assets/paper.svg',
                  color: Color(0x803A3A55CC),
                ),
                label: 'Аудиозаписи',
              ),
              BottomNavigationBarItem(
                activeIcon: SvgPicture.asset(
                  'assets/profile.svg',
                  color: Color(0xff8c84e2),
                ),
                icon: SvgPicture.asset(
                  'assets/profile.svg',
                  color: Color(0x803A3A55CC),
                ),
                label: 'Профиль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
