import 'package:first_project_test/models/painter_model.dart';
import 'package:flutter/material.dart';

class Audios extends StatefulWidget {
  @override
  _AudiosState createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 350,
          child: CustomPaint(
            painter: CirclePainter(color: Color(0xff5E77CE)),
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
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Аудиозаписи',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Все в одном месте',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 42, right: 10),
            child: IconButton(
              color: Colors.white,
              iconSize: 38,
              icon: Icon(Icons.more_horiz),
              onPressed: () => null,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 170,left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('20 аудио',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text('10:30 часов',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 170, right: 20),
            child: Text(''),
          ),
        ),
      ],
    );
  }
}
