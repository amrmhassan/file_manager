import 'package:flutter/material.dart';
import './custom_circle.dart';

import 'sub_range_model.dart';

class SliderPainter extends CustomPainter {
  //changing
  final double value;
  final List<SubRangeModel> subRanges;

  // constants
  final double thickness;
  final double activeThickness;
  final double inactiveThickness;
  final Color activeColor;
  final Color inactiveColor;
  final List<CustomCircle> thumbs;

  const SliderPainter({
    required this.thickness,
    required this.value,
    required this.activeThickness,
    required this.inactiveThickness,
    required this.activeColor,
    required this.inactiveColor,
    required this.subRanges,
    required this.thumbs,
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

    // this is the base line (round stroke)
    // this takes the full line width
    // x1 is the start of the line, x2 is the end
    canvas.drawLine(
      Offset(x1, y),
      Offset(x2, y),
      paint,
    );

    if (x2 >= (size.width - (paint.strokeWidth / 2))) {
      // this mean that it reached the end and we need to keep the round part so the above line won't be till the end
      paint.strokeCap = StrokeCap.square;
      // x22 is that we need to make it starts from the center of the line, not the start of the line
      // it is the middle of the full line if the line is from 12 to 16, x22 is 14
      double x22 = x1 + (x2 - x1) / 2;
      // it is the point of the start of the line
      double x11 = x1 < paint.strokeWidth / 2 ? x22 : x1;
      canvas.drawLine(
        Offset(x11, y),
        Offset(x22, y),
        paint,
      );
    } else {
      // this means that it needs to cover the whole place
      paint.strokeCap = StrokeCap.square;
      // x22 is the same like in the previous case but it won't be used
      double x22 = x1 + (x2 - x1) / 2;
      double x11 = x1 < paint.strokeWidth / 2 ? x22 : x1;
      canvas.drawLine(
        Offset(x11, y),
        Offset(x2, y),
        paint,
      );
    }
  }

  void drawThumbs(Canvas canvas, Size size, Paint paint) {
    for (var thumb in thumbs) {
      paint.color = thumb.color;
      Path circlePath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(value, size.height / 2),
            radius: thumb.radius,
          ),
        );
      canvas.drawShadow(circlePath, Colors.black, 2, true);
      canvas.drawPath(circlePath, paint);
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
    drawThumbs(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
