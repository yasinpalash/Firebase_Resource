import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var docIDs = <String>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUserDocIds();
    super.onInit();
  }

  void fetchUserDocIds() async {
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
}
