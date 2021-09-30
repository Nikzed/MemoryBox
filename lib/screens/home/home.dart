import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
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
      body: Stack(
        children: <Widget>[
          Container(
            width: 500,
            height: 500,
            child: CustomPaint(
              painter: CirclePainter(),
            ),
          ),
          Positioned(
            left: 17,
            top: 10,
            child: Text('Подборки',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: 'Consolas')),
          ),
          Positioned(
            top: 4,
            right: 10,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Открыть всё',
                style: TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'Consolas'),
              ),
              style: ButtonStyle(),
            ),
          ),
          Positioned(
            top: 78,
            left: 16,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {},
              child: Container(
                width: 183,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xcc71A59F),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                ),
              ),
            ),
          )
        ],
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
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Color(0xff8c84e2);

    var path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.5,
        size.width * 1.0, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
