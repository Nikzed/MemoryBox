import 'package:first_project_test/screens/home/home.dart';
import 'package:first_project_test/screens/home/profile.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
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
            selectedFontSize: 10,
            unselectedFontSize: 10,
            iconSize: 30,
            onTap: (value) {
              currentIndex = value;
              _pageController.animateToPage(
                value,
                duration: Duration(milliseconds: 400),
                curve: Curves.linear,
              );

              setState(() {});
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Подборки',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Запись',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Аудиозаписи',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Профиль',
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page){
          setState(() {
            currentIndex = page;
          });
        },
        children: [
          Home(),
          Profile(),
          Profile(),

          Profile(),

          Profile(),
        ],
      ),
    );
  }
}
