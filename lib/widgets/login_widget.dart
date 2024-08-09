import 'package:flutter/material.dart';

class Login {

  Widget name(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: const Text("Name"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
      ),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return "Enter your name";
        } return null;
      },
      keyboardType: TextInputType.name,
    );
  }

  Widget rollNumber(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: const Text("Roll Number"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))
      ),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return "Enter your Institute Roll No.";
        } else if (value.length != 8) {
          return "Invalid Institude Roll No.";
        } return null;
      },
      keyboardType: TextInputType.number,
    );
  }
}