// services/firebase_auth_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

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
    String formattedPhone = formatPhoneNumber(phone, countryCode: "880"); // Ensure consistency
    String hashedPin = hashPin(pin);
    await _firestore.collection("users").doc(formattedPhone).set({
      "phone": formattedPhone,
      "pin": hashedPin,
      "uid": _auth.currentUser!.uid,
    });
  }

  Future<bool> loginUser({required String phone, required String pin}) async {
    String formattedPhone = formatPhoneNumber(phone, countryCode: "880");
    print("Formatted login phone: $formattedPhone");

    final doc = await _firestore.collection("users").doc(formattedPhone).get();
    if (!doc.exists) {
      print("No user found");
      return false;
    }

    final hashedPin = hashPin(pin);
    print("Entered pin hash: $hashedPin");
    print("Stored pin hash: ${doc.data()!["pin"]}");

    return doc.data()!["pin"] == hashedPin;
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}




