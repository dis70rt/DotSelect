import 'package:deci_dot/pages/home_page.dart';
import 'package:deci_dot/widgets/login_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final Login login = Login();

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "assets/images/COPS_LOGO.png",
                          fit: BoxFit.cover,
                          width: 150,
                          height: 95,
                        )),
                    const SizedBox(height: 20),
                    login.name(nameController),
                    const SizedBox(height: 15),
                    login.rollNumber(rollController),
                    const SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                            colors: [Colors.white, Colors.white70]),
                      ),
                      child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              database
                                  .child("Users/${rollController.text}")
                                  .set({
                                "name": nameController.text,
                              });

                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            rollNumber: rollController.text,
                                            name: nameController.text,
                                          )));
                            }
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Club of Programmers",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
