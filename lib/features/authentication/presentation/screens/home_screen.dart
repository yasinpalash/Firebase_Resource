// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to Home!"),
      ),
    );
  }
}
