import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  /// User Registration
  Future<void> registerUser() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Create user with email & password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Add additional user details to Firestore
      await addUserDetails(userCredential.user!.uid);

      Get.snackbar(
        "Success",
        "Registration successful",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to Home Screen
      await Get.offNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unexpected error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Add User Details to Firestore
  Future<void> addUserDetails(String uid) async {
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      'first name': firstNameController.text.trim(),
      'last name': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'age': ageController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Dispose Controllers
  @override
  void onClose() {
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
