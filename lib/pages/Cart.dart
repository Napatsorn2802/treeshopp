import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:treeshop/services/constant.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? email;
  Stream? cartStream;
  double totalPrice = 0.0;
  bool isLoading = false;
  Map<String, dynamic>? paymentIntent;

  getSharedPref() async {
    email = await SharedPreferenceHelper().getUserEmail();
    if (email != null) {
      cartStream = await DatabaseMethod().getUserCart(email!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  // 🧾 คำนวณราคารวม
  void calculateTotal(AsyncSnapshot snapshot) {
    double total = 0;
    for (var doc in snapshot.data.docs) {
      total += double.tryParse(doc["Price"].toString()) ?? 0;
    }
    totalPrice = total;
  }

  // 💳 สร้าง PaymentIntent
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(), // แปลงเป็นสตางค์
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey', // ใช้ secret key จาก constant.dart
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('เกิดข้อผิดพลาด: ${err.toString()}');
    }
  }

  // 🧾 ฟังก์ชันชำระเงินจริง
  Future<void> makePayment() async {
    if (email == null) return;

    try {
      setState(() => isLoading = true);

      final cartSnapshot = await FirebaseFirestore.instance
          .collection("cart")
          .where("UserEmail", isEqualTo: email)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ยังไม่มีสินค้าในตะกร้า 😅")),
        );
        setState(() => isLoading = false);
        return;
      }

      // ✅ เรียก Stripe Payment Sheet
      paymentIntent = await createPaymentIntent(totalPrice.toInt().toString(), 'THB');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Treeshop',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // ✅ ชำระสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ชำระเงินสำเร็จ ✅")),
      );

      // 🧾 บันทึกคำสั่งซื้อทั้งหมด
      for (var doc in cartSnapshot.docs) {
        await DatabaseMethod().orderDetails({
          "Product": doc["Product"],
          "Price": doc["Price"],
          "Image": doc["Image"],
          "Email": email,
          "Status": "On the way",
          "Timestamp": DateTime.now(),
        });
      }

      // ❌ ลบตะกร้าออกหลังชำระเงิน
      for (var doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      paymentIntent = null;
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EE),
      appBar: AppBar(
        title: const Text("🛒 ตะกร้าสินค้า"),
        backgroundColor: const Color(0xFF6B4E28),
      ),
      body: cartStream == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: cartStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data.docs.isEmpty) {
                  return const Center(child: Text("ยังไม่มีสินค้าในตะกร้า 😢"));
                } else {
                  calculateTotal(snapshot);

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              color: const Color(0xFFEDE3F3),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(ds["Product"]),
                                subtitle: Text("฿${ds["Price"]}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    await DatabaseMethod()
                                        .deleteCartItem(ds.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // ปุ่มชำระเงิน
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "ราคารวมทั้งหมด:",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "฿${totalPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6B4E28),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6B4E28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed:
                                    isLoading ? null : () async => await makePayment(),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "ชำระเงิน",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
