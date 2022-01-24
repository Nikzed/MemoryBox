import 'package:flutter/material.dart';

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
