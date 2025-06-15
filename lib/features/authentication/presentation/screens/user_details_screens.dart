import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsScreens extends StatelessWidget {
  final String docId;

  const UserDetailsScreens({super.key, required this.docId});

  void _showUpdateDialog(BuildContext context, Map<String, dynamic> data) {
    final TextEditingController firstNameController =
    TextEditingController(text: data['first name']);
    final TextEditingController emailController =
    TextEditingController(text: data['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text("Update User", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "First Name",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('user').doc(docId).update({
                'first name': firstNameController.text.trim(),
                'email': emailController.text.trim(),
              });
              Get.back();
              Get.snackbar("Updated", "User details updated.",
                  backgroundColor: Colors.tealAccent, colorText: Colors.black);
            },
            child: const Text("Update", style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text("Delete User", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to delete this user?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('user').doc(docId).delete();
              Get.back();
              Get.snackbar("Deleted", "User deleted successfully.",
                  backgroundColor: Colors.redAccent, colorText: Colors.white);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(docId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: Text(
              "First Name: ${data['first name']}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Email: ${data['email'] ?? 'N/A'}",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'update') {
                  _showUpdateDialog(context, data);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'update', child: Text("Update")),
                const PopupMenuItem(value: 'delete', child: Text("Delete")),
              ],
            ),
          ),
        );
      },
    );
  }
}
