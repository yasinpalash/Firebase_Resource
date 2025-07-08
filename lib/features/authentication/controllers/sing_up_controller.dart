
import 'package:get/get.dart';

import '../presentation/screens/otp_screen.dart';
import '../service/firebase_service.dart';


class SignUpController extends GetxController {
  final authService = FirebaseAuthService();

  void submitPhone(String phone, String pin) {
    authService.sendOTP(
      phone: phone,
      onCodeSent: (verificationId) {
        Get.to(() => OtpScreen(
          verificationId: verificationId,
          phone: phone,
          pin: pin,
        ));
      },
      onError: (error) {
        Get.snackbar("Error", error);
      },
    );
  }
}