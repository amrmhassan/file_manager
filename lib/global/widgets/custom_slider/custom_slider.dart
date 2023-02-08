// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';

// class MultiTrackSlider extends StatefulWidget {
//   const MultiTrackSlider({super.key});

//   @override
//   _MultiTrackSliderState createState() => _MultiTrackSliderState();
// }

// class _MultiTrackSliderState extends State<MultiTrackSlider> {
//   double _value = 0.5;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         setState(() {
//           _value = (details.localPosition.dx / (context.size?.width ?? 1));
//         });
//       },
//       child: CustomPaint(
//         size: Size(double.infinity, 100),
//         painter: MultiTrackPainter(_value),
//       ),
//     );
//   }
// }

// class MultiTrackPainter extends CustomPainter {
//   final double _value;

//   MultiTrackPainter(this._value);

//   @override
//   void paint(Canvas canvas, Size size) {
//     var primaryTrackPaint = Paint()
//       ..color = Colors.grey[300]!
//       ..style = PaintingStyle.fill;

//     var secondaryTrackPaint = Paint()
//       ..color = Colors.grey[500]!
//       ..style = PaintingStyle.fill;

//     var thumbPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.fill;

//     var primaryTrackRect = Rect.fromLTRB(0, 50, size.width, 60);
//     var secondaryTrackRect1 = Rect.fromLTRB(0, 40, _value * size.width, 50);
//     var secondaryTrackRect2 =
//         Rect.fromLTRB(_value * size.width, 60, size.width, 70);

//     canvas.drawRect(primaryTrackRect, primaryTrackPaint);
//     canvas.drawRect(secondaryTrackRect1, secondaryTrackPaint);
//     canvas.drawRect(secondaryTrackRect2, secondaryTrackPaint);

//     var thumbRect = Rect.fromLTRB(
//         _value * size.width - 10, 35, _value * size.width + 10, 65);
//     canvas.drawOval(thumbRect, thumbPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
