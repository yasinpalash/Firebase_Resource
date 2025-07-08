
import 'package:get/get.dart';

import '../presentation/screens/home_screen.dart';
import '../service/firebase_service.dart';


class LoginController extends GetxController {
  final authService = FirebaseAuthService();

  Future<void> login(String phone, String pin) async {
    bool isValid = await authService.loginUser(phone: phone, pin: pin);
    if (isValid) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.snackbar("Login Failed", "Incorrect phone or PIN");
    }
  }
}
