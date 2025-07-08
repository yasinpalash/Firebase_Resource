// screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sing_up_controller.dart';
import 'login.dart';


class SignUpScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone (+880...)"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: pinController,
              decoration: InputDecoration(labelText: "PIN (4+ digits)"),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text.trim();
                final pin = pinController.text.trim();

                if (phone.isEmpty || pin.isEmpty) {
                  Get.snackbar("Missing Info", "Phone and PIN cannot be empty");
                  return;
                }

                controller.submitPhone(phone, pin);
              },
              child: const Text("Continue"),
            ),

            SizedBox(height: 20),
            Text(" Login"),
            TextButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              child: const Text("Already have an account? Login"),
            ),

          ],
        ),
      ),
    );
  }
}
