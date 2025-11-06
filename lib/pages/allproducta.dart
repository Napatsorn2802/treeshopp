import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/pages/product_detail.dart';
import 'package:treeshop/services/database.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool searching = false;
  String sortBy = "none"; // none, low_high, high_low

  var queryResultSet = [];
  var tempSearchStore = [];

  TextEditingController searchController = TextEditingController();

  // ฟังก์ชันค้นหา
  initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        searching = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      searching = true;
    });

    String searchValueLower = value.toLowerCase();

    DatabaseMethod().search(value).then((QuerySnapshot docs) {
      queryResultSet = [];
      for (var doc in docs.docs) {
        queryResultSet.add(doc.data() as Map<String, dynamic>);
      }

      tempSearchStore = [];
      queryResultSet.forEach((element) {
        String productName = element['Name']?.toString().toLowerCase() ?? "";
        if (productName.contains(searchValueLower)) {
          tempSearchStore.add(element);
        }
      });

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(168, 203, 153, 74),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(168, 197, 149, 72),
        elevation: 0,
        title: const Text(
          "All Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ช่องค้นหา
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  initiateSearch(value.toUpperCase());
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search products...",
                  hintStyle: const TextStyle(
                    color:const Color.fromARGB(168, 255, 255, 255),
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 112, 80, 49)),
                  suffixIcon: searching
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              searching = false;
                              queryResultSet = [];
                              tempSearchStore = [];
                              searchController.text = "";
                            });
                          },
                          child: const Icon(Icons.close,
                              color: Color.fromARGB(255, 112, 80, 49)))
                      : null,
                ),
              ),
            ),
          ),

          // ถ้ามีการค้นหา
          searching
              ? Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: tempSearchStore.map((element) {
                      return buildResultCard(element);
                    }).toList(),
                  ),
                )
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No products found"));
                      }

                      var products = snapshot.data!.docs.toList();

                      // เรียงราคา
                      if (sortBy == "low_high") {
                        products.sort((a, b) {
                          final priceA = double.tryParse(
                                  (a.data() as Map<String, dynamic>)["Price"]
                                          ?.toString() ??
                                      "0") ??
                              0;
                          final priceB = double.tryParse(
                                  (b.data() as Map<String, dynamic>)["Price"]
                                          ?.toString() ??
                                      "0") ??
                              0;
                          return priceA.compareTo(priceB);
                        });
                      } else if (sortBy == "high_low") {
                        products.sort((a, b) {
                          final priceA = double.tryParse(
                                  (a.data() as Map<String, dynamic>)["Price"]
                                          ?.toString() ??
                                      "0") ??
                              0;
                          final priceB = double.tryParse(
                                  (b.data() as Map<String, dynamic>)["Price"]
                                          ?.toString() ??
                                      "0") ??
                              0;
                          return priceB.compareTo(priceA);
                        });
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final data =
                                products[index].data() as Map<String, dynamic>;

                            final name = data["Name"] ?? "Unnamed";
                            final price = data["Price"]?.toString() ?? "0";
                            final image = data["Image"] ?? "";
                            final detail =
                                data["Detail"] ?? "No details available";

                            return GestureDetector(
                              onTap: () {
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
                                  color: Colors.white.withOpacity(0.9),
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
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 51, 38, 26),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "฿$price",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 112, 80, 49),
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
                ),
        ],
      ),
    );
  }

  // การ์ดแสดงผลลัพธ์การค้นหา
  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              detail: data["Detail"],
              image: data["Image"],
              name: data["Name"],
              price: data["Price"],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data["Image"],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                data["Name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 38, 26),
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Dialog ตัวกรองราคา (ธีมสีน้ำตาลทอง)
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 255, 248, 235),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "เรียงลำดับตามราคา",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromARGB(255, 94, 63, 32),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildFilterOption("none", "ไม่เรียง"),
                _buildFilterOption("low_high", "ราคาต่ำ → สูง"),
                _buildFilterOption("high_low", "ราคาสูง → ต่ำ"),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 197, 149, 72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "ปิด",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Radio<String>(
        activeColor: const Color.fromARGB(255, 197, 149, 72),
        value: value,
        groupValue: sortBy,
        onChanged: (val) {
          setState(() {
            sortBy = val!;
          });
          Navigator.pop(context);
        },
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 80, 57, 32),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        setState(() {
          sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }
}
