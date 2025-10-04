import 'package:flutter/cupertino.dart';

class CornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height); // Start at bottom-left
    path.lineTo(0, 0); // Move to top-left
    path.lineTo(size.width, 0); // Move to top-right (the corner we're keeping)
    path.lineTo(size.width, size.height * 0.2); // Go down a bit on the right side
    path.lineTo(size.width * 0.8, size.height); // Go left a bit on the bottom side
    path.close(); // Connect back to the start point (bottom-left)
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}