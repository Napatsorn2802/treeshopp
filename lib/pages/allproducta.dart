import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/pages/product_detail.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(168, 203, 153, 74),//สีพื้นหลังแอบ
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(168, 197, 149, 72),//สีพื้นหลังแอพบา
        elevation: 0,
        title: const Text(
          "All Products",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),//สีของไอค่อนกับ
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final data = products[index].data() as Map<String, dynamic>;

                // ป้องกัน error ถ้าข้อมูลใน Firestore มีบาง field หาย
                final name = data["Name"] ?? "Unnamed";
                final price = data["Price"]?.toString() ?? "0";
                final image = data["Image"] ?? "";
                final detail = data["Detail"] ?? "No details available";

                return GestureDetector(
                  onTap: () {
                    // ➡️ เปิดหน้า ProductDetail (ที่มี Add to Cart + Buy Now)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          detail: detail,
                          image: image,
                          name: name,
                          price: price,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปสินค้า
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: image.isNotEmpty
                              ? Image.network(
                                  image,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        // ชื่อสินค้า
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 51, 38, 26),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // ราคา
                        Text(
                          "฿$price",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 112, 80, 49),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
