import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  void loginUser() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    isLoading.value = true;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await  Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred.";
      switch (e.code) {
        case 'user-not-found':
          message = "User not found.";
          break;
        case 'wrong-password':
          message = "Wrong password.";
          break;
        case 'invalid-credential':
          message = "Invalid email or password.";
          break;
        case 'invalid-email':
          message = "Email format is invalid.";
          break;
        case 'user-disabled':
          message = "This user has been disabled.";
          break;
        default:
          message = e.message ?? message;
      }
      Get.snackbar(
        "Login Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
