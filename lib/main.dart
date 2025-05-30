import 'package:firebase/firebase_options.dart';
import 'package:firebase/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:firebase/features/authentication/presentation/screens/home_screen.dart';
import 'package:firebase/features/authentication/presentation/screens/login.dart';
import 'package:firebase/features/authentication/presentation/screens/singup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/forgot', page: () => ForgotPasswordScreen()),
      ],
    ),
  );
}
