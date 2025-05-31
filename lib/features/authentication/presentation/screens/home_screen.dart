import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = [
    'All',
    'Men',
    'Women',
    'Kids',
    'Shoes',
    'Electronics',
  ];

  final List<Map<String, dynamic>> products = [
    {'name': 'T-Shirt', 'price': '\$20', 'image': Icons.checkroom},
    {'name': 'Sneakers', 'price': '\$50', 'image': Icons.directions_run},
    {'name': 'Laptop', 'price': '\$500', 'image': Icons.laptop},
    {'name': 'Watch', 'price': '\$80', 'image': Icons.watch},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Shop"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
              Get.snackbar(
                "Logged Out",
                "You have been logged out successfully.",
                backgroundColor: Colors.tealAccent,
                colorText: Colors.black,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            tooltip: "Logout",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(
                      label: Text(categories[index]),
                      backgroundColor:
                      index == 0 ? Colors.teal : Colors.grey[200],
                      labelStyle: TextStyle(
                        color: index == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (_, index) {
                  final product = products[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(product['image'], size: 60, color: Colors.teal),
                          Text(product['name'], style: TextStyle(fontSize: 16)),
                          Text(product['price'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Add to Cart"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
