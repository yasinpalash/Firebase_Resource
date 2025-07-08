import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presentation/screens/login.dart';
import '../service/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseAuthService authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = true.obs;
  var userPhone = ''.obs;
  var userUid = ''.obs;
  var userData = Rxn<Map<String, dynamic>>();
  var userSpecificData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      // // Get current user info from SharedPreferences
      // Map<String, String?> currentUser = await authService.getCurrentUser();
      // userPhone.value = currentUser['phone'] ?? '';
      // userUid.value = currentUser['uid'] ?? '';
      //
      // // Load user data from Firestore
      // userData.value = await authService.getUserData();
      //
      // // Load user-specific data (example: user's posts, orders, etc.)
      // userSpecificData.value = await authService.getUserSpecificData('user_posts');

    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSampleData() async {
    try {
      // Add sample data for demonstration
      await _firestore.collection('user_posts').add({
        'userId': userUid.value,
        'title': 'Sample Post ${DateTime.now().millisecondsSinceEpoch}',
        'description': 'This is a sample post created by the user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Reload data
      await loadUserData();
      Get.snackbar('Success', 'Sample data added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add sample data: $e');
    }
  }

  String getFormattedDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }

    return 'N/A';
  }

  Future<void> logout() async {
    try {
      await authService.logout();
      Get.offAll(() => LoginScreen());
      Get.snackbar('Success', 'Logged out successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: $e');
    }
  }
}
