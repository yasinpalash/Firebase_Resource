// import 'package:firebase/features/authentication/presentation/screens/singup.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_screen.dart';
//
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   String? phone;
//
//   @override
//   void initState() {
//     super.initState();
//     checkAuthStatus();
//   }
//
//   Future<void> checkAuthStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     phone = prefs.getString('phone');
//
//     // Wait 2 seconds for splash effect
//     await Future.delayed(const Duration(seconds: 2));
//
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && phone != null) {
//       Get.offAll(() => HomeScreen(phone: phone!));
//     } else {
//       Get.offAll(() =>  SignUpScreen());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
