import 'package:flutter/material.dart';

Widget circle(String name, {bool isGlowing = false}) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black,
        width: 3,
        strokeAlign: BorderSide.strokeAlignCenter,
      ),
      boxShadow: isGlowing
          ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.8),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
            ]
          : [],
    ),
    child: Center(
      child: Text(
        name[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
  );
}
