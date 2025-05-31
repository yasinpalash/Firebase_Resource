import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  void resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Password reset link sent!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent[400],
        colorText: Colors.black,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.snackbar(
          "Error",
          "No user found for that email!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
