import 'package:flutter/material.dart';
import 'package:treeshop/Admin/add_product.dart';
import 'package:treeshop/Admin/all_orders.dart';
import 'package:treeshop/Admin/all_products.dart';
import 'package:treeshop/pages/login.dart';
import 'package:treeshop/widget/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xA8BF9551),
      appBar: AppBar(
        backgroundColor: const Color(0xA8BF9551),
        title: Center(
          child: Text("Home Admin", style: AppWidget.boldTextFeildStyle()),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildButton(
              icon: Icons.add,
              text: "Add Product",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProduct()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.shopping_bag,
              text: "All Orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllOrders()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildButton(
              icon: Icons.list,
              text: "All Products",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProducts()),
                );
              },
            ),
            
            const SizedBox(height: 450),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?  ",
                  style: AppWidget.semiboldTextFeildStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    );
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 214, 150, 13),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(225, 185, 133, 82),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(width: 15),
              Text(text, style: AppWidget.boldTextFeildStyle()),
            ],
          ),
        ),
      ),
    );
  }
}
