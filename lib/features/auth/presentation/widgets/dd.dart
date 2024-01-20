// import 'package:flutter/material.dart';

// class DirectionSignPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;

//     Path path = Path();

//     // Define the points for the road sign arrow
//     path.moveTo(0, size.height * 0.5); // Middle left
//     path.lineTo(
//         size.width * 0.3, size.height * 0.5); // Go to the right on the middle
//     path.lineTo(size.width * 0.3, 0); // Top right corner
//     path.lineTo(
//         size.width, size.height * 0.5); // Middle, all the way to the right
//     path.lineTo(size.width * 0.3, size.height); // Bottom right corner
//     path.lineTo(size.width * 0.3, size.height * 0.5); // Back to middle right
//     path.close(); // Closes the path to form a shape

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
