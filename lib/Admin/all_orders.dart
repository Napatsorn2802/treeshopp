import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/widget/support_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethod().allOrders();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No orders found."));
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
                      ClipOval(
                        child: Image.network(
                          ds["Image"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ✅ แสดงชื่อสินค้า
                            Text(
                              ds["Product"],
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),

                            // ✅ แสดงอีเมลผู้สั่ง
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "Email: ${ds["Email"]}",
                                style: AppWidget.lightTextFeildStyle(),
                              ),
                            ),

                            // ✅ แสดงราคา
                            Text(
                              "฿${ds["Price"]}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 112, 80, 49),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ✅ ปุ่มอัปเดตสถานะออเดอร์
                            GestureDetector(
                              onTap: () async {
                                await DatabaseMethod().updateStatus(ds.id);
                                setState(() {});
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                width: 150,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 232, 43, 43),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Done",
                                    style:
                                        AppWidget.semiboldTextFeildStyle(),
                                  ),
                                ),
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
      backgroundColor: const Color(0xA8BF9551),
      appBar: AppBar(
        backgroundColor: const Color(0xA8BF9551),
        title: Center(
          child: Text(
            "All Orders",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
