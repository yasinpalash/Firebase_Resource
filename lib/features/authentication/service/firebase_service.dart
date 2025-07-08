// services/firebase_auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Format phone to E.164
  String formatPhoneNumber(String input, {required String countryCode}) {
    String cleaned = input.replaceAll(RegExp(r'\s+|-'), '');
    if (!cleaned.startsWith('+')) {
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      cleaned = '+$countryCode$cleaned';
    }
    return cleaned;
  }

  String hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> sendOTP({
    required String phone,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    String formattedPhone = formatPhoneNumber(phone, countryCode: "880");
    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException error) {
        onError(error.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }



  Future<void> saveUser({required String phone, required String pin}) async {
    String formattedPhone = formatPhoneNumber(phone, countryCode: "880");
    String hashedPin = hashPin(pin);

    await _firestore.collection("users").doc(formattedPhone).set({
      "phone": formattedPhone,
      "pin": hashedPin,
      "uid": _auth.currentUser!.uid,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', formattedPhone); // Save locally
  }

  Future<bool> loginUser({required String phone, required String pin}) async {
    String formattedPhone = formatPhoneNumber(phone, countryCode: "880");
    final doc = await _firestore.collection("users").doc(formattedPhone).get();

    if (!doc.exists) return false;

    final hashedPin = hashPin(pin);
    final isMatch = doc.data()!["pin"] == hashedPin;

    if (isMatch) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userPhone', formattedPhone); // Save locally
    }

    return isMatch;
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}




