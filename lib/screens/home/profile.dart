import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            child: CustomPaint(
              painter: CirclePainter(),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 5),
              child: IconButton(
                color: Colors.white,
                iconSize: 28,
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Профиль',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Твоя частичка',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 228,
                  width: 228,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Имя',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  width: 292,
                  height: 22,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    elevation: 9,
                    shadowColor: Colors.black.withOpacity(0.4),
                    child: Text(
                      '+380936728934',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Редактировать'),
                ),
                SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Подписка'),
                ),
                Container(
                  height: 15,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('150/500 мб'),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [Text('Выйти из приложения'),Spacer(), Text('Удалить аккаунт')],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
