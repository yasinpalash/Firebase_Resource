import 'package:firebase/features/authentication/presentation/screens/user_details_screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../controllers/user_details_controller.dart';

class HomeScreen extends StatelessWidget {
  final UserController controller = Get.put(UserController());
  final userEmail = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("User Email :  ${userEmail.email}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
              Get.snackbar(
                "Logged Out",
                "You have been logged out successfully.",
                backgroundColor: Colors.tealAccent,
                colorText: Colors.black,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.docIDs.isEmpty) {
          return const Center(
            child: Text(
              "No users found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.docIDs.length,
          itemBuilder: (context, index) {
            return UserDetailsScreens(docId: controller.docIDs[index]);
          },
        );
      }),
    );
  }
}
