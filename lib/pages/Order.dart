import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
import 'package:treeshop/widget/support_widget.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;
  Stream? orderStream;

  getSharedPref() async {
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getOnTheLoad() async {
    await getSharedPref();
    orderStream = await DatabaseMethod().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No orders yet"));//ยังไม่มีคำสั่งซื้อ
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4E28).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ds["Image"], // ✅ ใช้ Image ที่ตรงกับ Firestore
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ds["Product"], // ✅ ใช้ Product เป็นชื่อสินค้า
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "฿${ds["Price"]}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 112, 80, 49),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Status : ${ds["Status"]}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 112, 80, 49),
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(168, 153, 115, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(168, 153, 115, 55),
        title: Center(
          child: Text(
            "Current Orders",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
