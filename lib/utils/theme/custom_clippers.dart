

import 'package:flutter/material.dart';

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start at the top-left corner
    path.lineTo(0, size.height * 0.8); // Extend further down for the vertical section
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height, // Control point for bottom curve
      size.width,
      size.height * 0.8, // End point of the curve
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
