import 'package:first_project_test/models/painter_model.dart';
import 'package:flutter/material.dart';

class Compilations extends StatefulWidget {
  @override
  _CompilationsState createState() => _CompilationsState();
}

class _CompilationsState extends State<Compilations> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 350,
          child: CustomPaint(
            painter: CirclePainter(color: Color(0xff71A59F)),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 5),
            child: IconButton(
              color: Colors.white,
              iconSize: 28,
              // TODO implement add collection button
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
                  'Подборки',
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
      ],
    );
  }
}
