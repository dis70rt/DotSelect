import 'package:deci_dot/widgets/circle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserPopupScreen extends StatelessWidget {
  final String userName;
  final String rollNumber;

  const UserPopupScreen({
    super.key,
    required this.userName,
    required this.rollNumber,
  });

  @override
  Widget build(BuildContext context) {
    final DatabaseReference database = FirebaseDatabase.instance.ref("notifications");

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 2)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Selected User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Hero(
                tag: rollNumber,
                child: circle(userName),
              ),
              const SizedBox(height: 20),
              Text(
                "Name: $userName",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                "Roll Number: $rollNumber",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  database.update({
                    "selectedUserKey": "0"
                  });
                  Navigator.of(context).pop();},
                child: const Text("OK", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
