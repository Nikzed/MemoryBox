import 'package:flutter/material.dart';

//
// class CustomSliderPlayer extends SliderComponentShape {
//   final thumbRadius = 5.0;
//   double sliderPosition;
//
//   CustomSliderPlayer(this.sliderPosition);
//
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(5);
//   }
//
//   @override
//   void paint(PaintingContext context, Offset center,
//       {required Animation<double> activationAnimation,
//       required Animation<double> enableAnimation,
//       required bool isDiscrete,
//       required TextPainter labelPainter,
//       required RenderBox parentBox,
//       required SliderThemeData sliderTheme,
//       required TextDirection textDirection,
//       required double value,
//       required double textScaleFactor,
//       required Size sizeWithOverflow}) {
//     final Canvas canvas = context.canvas;
//
//     final paint = Paint()
//       ..color = Color(0xff3A3A55)
//       ..style = PaintingStyle.fill;
//
//     Path path = Path();
//
//     void doubleQuad(double x, double y, double w, double h) {
//       path.moveTo(x - w, y);
//       path.quadraticBezierTo(x, y - h, x + w+2, y);
//       path.moveTo(x - w, y);
//       path.quadraticBezierTo(x, y + h, x + w, y);
//     }
//
//     void drawSlider(double x, double y) {
//       doubleQuad(x, y, 15, 12);
//     }
//
//     drawSlider(25 + sliderPosition * 325, 25);
//     canvas.drawPath(path, paint);
//   }
// }

class CustomSliderPlayer extends SliderComponentShape {
  final double thumbRadius;

  const CustomSliderPlayer({required this.thumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(center.dx - 10, center.dy + 5),
        Offset(center.dx + 10, center.dy - 5),
      ),
      Radius.circular(thumbRadius + 2),
    );

    canvas.drawRRect(rect, paint);
  }
}
