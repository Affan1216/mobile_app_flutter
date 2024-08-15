import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF44A064),
      body: SafeArea(
        child: child,
        ),
      );
  }
}