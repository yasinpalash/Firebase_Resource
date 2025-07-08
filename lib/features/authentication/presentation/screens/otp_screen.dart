// screens/otp_screen.dart
import 'package:firebase/features/authentication/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sing_up_controller.dart';

class OtpScreen extends StatelessWidget {
  final otpController = TextEditingController();
  final String verificationId;
  final String phone;
  final String pin;

  OtpScreen({
    required this.verificationId,
    required this.phone,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());

    return Scaffold(
      appBar: AppBar(title: Text("Enter OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: "Enter OTP"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                controller.verify(
                  verificationId,
                  otpController.text.trim(),
                  phone,
                  pin,
                );
              },
              child: const Text("Verify"),
            ),

          ],
        ),
      ),
    );
  }
}
