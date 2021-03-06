import 'package:flutter/cupertino.dart';

class CirclePainter extends CustomPainter {

  final color;

  const CirclePainter({this.color = const Color(0xff8c84e2)});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;

    Path path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.8, size.width * 1,
        size.height * 0.71);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
