import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/aurora_logo.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }
}
