import 'package:flutter/material.dart';

Widget circle(String name) {
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
