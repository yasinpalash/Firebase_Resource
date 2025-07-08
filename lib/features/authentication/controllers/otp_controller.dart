
import 'package:get/get.dart';

import '../presentation/screens/home_screen.dart';
import '../service/firebase_service.dart';


class OtpController extends GetxController {
  final authService = FirebaseAuthService();

  Future<void> verify(String verificationId, String smsCode, String phone, String pin) async {
    bool success = await authService.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    if (success) {
      await authService.saveUser(phone: phone, pin: pin);
      Get.offAll(() => const HomeScreen());
    } else {
      Get.snackbar("Failed", "OTP verification failed");
    }
  }
}