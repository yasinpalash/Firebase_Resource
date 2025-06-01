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

  Future<void> registerUser() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await addUserDetails();

      Get.snackbar(
        "Success",
        "Registration successful",
        snackPosition: SnackPosition.BOTTOM,
      );

      await Get.offNamed('/home');
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";
      if (e.code == 'weak-password') {
        message = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future addUserDetails() async {
    await FirebaseFirestore.instance.collection('user').add(
      {
        'first name':firstNameController.text.trim(),
        'last name':lastNameController.text.trim(),
        'email':emailController.text.trim(),
        'age':ageController.text.trim(),
      }
    );
  }

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
