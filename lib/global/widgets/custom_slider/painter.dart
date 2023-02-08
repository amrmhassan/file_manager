import 'package:flutter/material.dart';

import 'sub_range_model.dart';

class SliderPainter extends CustomPainter {
  //changing
  final double value;
  final List<SubRangeModel> subRanges;

  // constants
  final double thickness;
  final Color circleColor;
  final double circleRadius;
  final double activeThickness;
  final double inactiveThickness;
  final Color activeColor;
  final Color inactiveColor;

  const SliderPainter({
    required this.thickness,
    required this.circleColor,
    required this.value,
    required this.circleRadius,
    required this.activeThickness,
    required this.inactiveThickness,
    required this.activeColor,
    required this.inactiveColor,
    required this.subRanges,
  });

  void drawSubRange(
    Canvas canvas,
    Size size,
    SubRangeModel subRange,
    Paint paint,
  ) {
    double y = size.height / 2;
    paint.color = subRange.color;
    double x1 = subRange.start;
    double x2 = subRange.end;

    canvas.drawLine(
      Offset(x1, y),
      Offset(x2, y),
      paint,
    );

    if (x2 >= (size.width - paint.strokeWidth)) {
      // this mean that it reached the end and we need to keep the round part so the above line won't be till the end
      paint.strokeCap = StrokeCap.square;
      double x22 = x1 + (x2 - x1) / 2;
      canvas.drawLine(
        Offset(x1, y),
        Offset(x22, y),
        paint,
      );
    } else {
      // this means that it needs to cover the whole place
      paint.strokeCap = StrokeCap.square;
      canvas.drawLine(
        Offset(x1, y),
        Offset(x2, y),
        paint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    //? the inactive part
    paint.color = inactiveColor;
    paint.strokeWidth = inactiveThickness;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(value, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    //? for drawing sub ranges
    for (var subRange in subRanges) {
      drawSubRange(canvas, size, subRange, paint);
    }

    //? the active part
    paint.color = activeColor;
    paint.strokeWidth = activeThickness;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(value, size.height / 2),
      paint,
    );

    //? the circle
    paint.color = circleColor;
    Path circlePath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(value, size.height / 2),
          radius: circleRadius,
        ),
      );
    canvas.drawShadow(circlePath, Colors.grey, 2, true);
    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
