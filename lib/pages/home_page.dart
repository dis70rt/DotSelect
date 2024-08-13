import 'package:deci_dot/pages/user_popup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/user_model.dart';
import '../widgets/circle.dart';

class HomePage extends StatefulWidget {
  final String rollNumber;
  final String name;

  const HomePage({super.key, required this.rollNumber, required this.name});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Offset? offset;
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  late final Stream<DatabaseEvent> userStream;
  late Map<String, UserModel> users;
  bool isCountdownActive = false;
  String? selectedUserKey;
  final Duration countdownDuration = const Duration(seconds: 5);
  Timer? countdownTimer;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    users = {};
    userStream = database.child("Users").onValue;
    userStream.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        setState(() {
          users = data.map((key, value) {
            final userMap = value as Map<dynamic, dynamic>?;
            if (userMap != null) {
              return MapEntry(
                key as String,
                UserModel.fromMap(Map<dynamic, dynamic>.from(userMap)),
              );
            } else {
              return MapEntry(key as String, UserModel.empty());
            }
          });
        });
      } else {
        setState(() {
          users = {};
        });
      }
    });

    database.child("notifications").onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        final selectedUserKey = data["selectedUserKey"];
        if (selectedUserKey.isNotEmpty) {
          setState(() {
            this.selectedUserKey = selectedUserKey.toString();
          });
          showUserPopup();
        }
      }
    });
  }

  void updatePosition(Offset position) {
    database.child("Users").child(widget.rollNumber).update({
      "name": widget.name,
      "roll": widget.rollNumber,
      "dx": position.dx,
      "dy": position.dy,
    });
  }

  void startCountdown() {
    setState(() {
      isCountdownActive = true;
      remainingSeconds = countdownDuration.inSeconds;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isCountdownActive = false;
        });
        selectRandomUser();
      }
    });
  }

  void selectRandomUser() {
    final userKeys = users.keys.toList();
    if (userKeys.isNotEmpty) {
      final randomKey = (userKeys..shuffle()).first;
      setState(() {
        selectedUserKey = randomKey;
      });

      database.child("notifications").set({
        "selectedUserKey": selectedUserKey,
        "timestamp": DateTime.now().toIso8601String(),
      });
    }
  }

  void showUserPopup() {
    if (selectedUserKey != null && users.containsKey(selectedUserKey)) {
      final selectedUser = users[selectedUserKey]!;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserPopupScreen(
            userName: selectedUser.name,
            rollNumber: selectedUserKey!,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          "COPS Orientation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset = details.localPosition;
                updatePosition(offset!);
              });
            },
            onPanEnd: (details) {
              setState(() {
                offset = null;
                database.child("Users").child(widget.rollNumber).remove();
              });
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          if (offset != null)
            Positioned(
              left: offset!.dx - 25,
              top: offset!.dy - 25,
              child: Hero(tag: widget.rollNumber, child: circle(widget.name)),
            ),
          ...users.entries
              .where((entry) => entry.key != widget.rollNumber)
              .map((entry) {
            final user = entry.value;
            return Positioned(
              left: user.dx - 25,
              top: user.dy - 25,
              child: Hero(tag: entry.key, child: circle(user.name)),
            );
          }),
          if (isCountdownActive)
            Positioned(
              bottom: 20,
              left: 20,
              child: Text(
                "Countdown: $remainingSeconds",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          if (!isCountdownActive)
            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: startCountdown,
                child: const Text("Start Selection"),
              ),
            ),
        ],
      ),
    );
  }
}
