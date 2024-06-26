import 'package:flutter/material.dart';

class ThemeConstants {
  static const BoxDecoration onlineModeDecoration = BoxDecoration(
    color:  Color.fromRGBO(255,255,255, 10),
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(97, 231, 96, 0.3), // Pure white (100% opacity)
        Color.fromRGBO(255, 255, 255, 0.7), // White with 70% opacity
        Color.fromRGBO(255, 255, 255, 0.3), // White with 30% opacity
        Color.fromRGBO(255, 255, 255, 1.0), // Pure white (100% opacity)
      ],
      stops: [0.0, 0.33, 0.67, 1.0], // Color stops
      begin: Alignment.topRight, // Start from top-right
      end: Alignment.bottomLeft, // End at bottom-left
    ),
  );
}