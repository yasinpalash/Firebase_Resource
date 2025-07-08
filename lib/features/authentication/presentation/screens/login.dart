// screens/login_screen.dart
import 'package:firebase/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sing_up_controller.dart';

class LoginScreen extends StatelessWidget {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
              decoration: InputDecoration(labelText: "PIN"),
              keyboardType: TextInputType.phone,
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final phone = phoneController.text.trim();
                final pin = pinController.text.trim();

                if (phone.isEmpty || pin.isEmpty) {
                  Get.snackbar("Missing Field", "Phone and PIN are required");
                  return;
                }

                controller.login(phone, pin);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
