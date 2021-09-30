import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: CustomPaint(
              size: Size(20, 0),
              painter: MyPainter(),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: Color(0xff8c84e2),
        elevation: 0.0,
        // leading: IconButton(
        //   icon: Text('hiii'),
        //   onPressed: () => null,
        // ),
        actions: <Widget>[
          // TextButton.icon(onPressed: () {}, icon: icon, label: label)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Аудиосказки'))
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, -6), Offset(20, -6), paint);
    canvas.drawLine(Offset(0, 0), Offset(20, 0), paint);
    canvas.drawLine(Offset(0, 6), Offset(20, 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    throw UnimplementedError();
  }
}
