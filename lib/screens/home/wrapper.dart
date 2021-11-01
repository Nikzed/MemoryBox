import 'dart:ui';
import 'package:first_project_test/screens/home/home.dart';
import 'package:first_project_test/screens/home/profile.dart';
import 'package:first_project_test/screens/home/record.dart';
import 'package:first_project_test/screens/home/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  var accentColor = Color(0xff8c84e2);
  int currentIndex = 0;
  bool showDrawer = true;
  String recordLabelText = 'Запись';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawerEnableOpenDragGesture: showDrawer,
      bottomNavigationBar: _getBottomNavigationBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            currentIndex = page;
            if (page == 1) {
              showDrawer = false;
            } else {
              showDrawer = true;
            }
            if (currentIndex == 2) {
              recordLabelText = '';
            } else {
              recordLabelText = 'Запись';
            }
          });
        },
        children: [
          Home(),
          Profile(),
          Record(),
          RecordToStreamExample(),
          Profile(),
        ],
      ),
      drawer: _getDrawer(),
    );
  }

  Widget _getDrawer() {
    return Drawer(
      child: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 90),
              child: Text(
                'Аудисказки',
                style: TextStyle(fontSize: 24),
              )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'Меню',
              style: TextStyle(fontSize: 22, color: Color(0xd93A3A5580)),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 80, left: 40),
            child: Stack(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.home),
                        ),
                      ),
                      TextSpan(text: 'Главная'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Color(0xff8c84e2),
          iconSize: 30,
          onTap: (value) {
            _pageController.animateToPage(
              value,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
            );

            setState(() {});
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/Home.svg',
                color: Color(0xff8c84e2),
              ),
              icon: SvgPicture.asset(
                'assets/Home.svg',
                color: Color(0x803A3A55CC),
              ),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/Category.svg',
                color: Color(0xff8c84e2),
              ),
              icon: SvgPicture.asset(
                'assets/Category.svg',
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
              label: recordLabelText,
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/Paper.svg',
                color: Color(0xff8c84e2),
              ),
              icon: SvgPicture.asset(
                'assets/Paper.svg',
                color: Color(0x803A3A55CC),
              ),
              label: 'Аудиозаписи',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/Profile.svg',
                color: Color(0xff8c84e2),
              ),
              icon: SvgPicture.asset(
                'assets/Profile.svg',
                color: Color(0x803A3A55CC),
              ),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
