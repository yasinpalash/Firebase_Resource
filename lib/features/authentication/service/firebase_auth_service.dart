// // ... (keep all existing code)
//
// // Add this new method to your FirebaseAuthService class
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// /// Fetches the Firestore document for the currently logged-in user.
// /// Returns null if no user is logged in or the document doesn't exist.
// Future<DocumentSnapshot?> getCurrentUserData() async {
//   // 1. Get the current authenticated user.
//   final user = _auth.currentUser;
//   if (user == null) {
//     // If no one is logged in, there's no data to fetch.
//     return null;
//   }
//
//   // 2. Use the user's UID to securely and uniquely identify their document.
//   // NOTE: This assumes you are saving documents with the phone number as the ID.
//   // A more robust approach is to use the UID as the document ID.
//   // For now, we'll stick to your current structure.
//
//   // Your current structure uses the phone number as the document ID.
//   if (user.phoneNumber == null) return null;
//
//   final doc = await _firestore.collection("users").doc(user.phoneNumber!).get();
//
//   if (doc.exists) {
//     return doc;
//   }
//   return null;
// }