import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var docIDs = <String>[].obs;
  var isLoading = false.obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkUserRole();
  }

  /// Check current user's role
  Future<void> checkUserRole() async {
    try {
      isLoading.value = true;
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if (doc.exists) {
        final role = doc.data()!['role'] ?? 'user';
        isAdmin.value = role == 'admin';

        if (isAdmin.value) {
          fetchAllUserDocIds();
        } else {
          fetchCurrentUserDocId();
        }
      } else {
        Get.snackbar("Error", "User data not found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user role: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch All User Document IDs (Admin only)
  Future<void> fetchAllUserDocIds() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance.collection('user').get();
      docIDs.value = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Current User's Document ID
  Future<void> fetchCurrentUserDocId() async {
    try {
      isLoading.value = true;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      docIDs.value = [uid];
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
