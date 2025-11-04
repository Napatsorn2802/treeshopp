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

 getthesharedpref()async{
  email= await SharedPreferenceHelper().getUserEmail();
  setState(() {
  });
}


  Stream? orderStream;

  getontheload()async{
    await getthesharedpref();
    orderStream= await DatabaseMethod().getOrders(email!);
    setState(() {
    });
  }

  @override
  void initState(){
    getontheload();
    super.initState();
  }

  Widget allOrders(){
  return StreamBuilder(
  stream: orderStream, 
  builder: (context,AsyncSnapshot snapshot){
    return snapshot.hasData? 
    ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: snapshot.data.docs.length, 
      itemBuilder: (context, index){
        DocumentSnapshot ds= snapshot.data.docs[index];

        return Container(
          margin: EdgeInsets.only(bottom:20 ),//ช่องว่างระหว่างกรอบ
          child: Material(
                elevation: 4,//แสงเงาด้านล่างกรอบ
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 20,top:10,bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                   color: Color(0xFF6B4E28).withOpacity(0.3),//สีกรอบการสั่งซื้อ
                    borderRadius: BorderRadius.circular(10),//ความโค้งมนของกรอบ
                  ),
                    child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        ds["ProductImage"],//รูปภาพ
                        height: 110,//สูงของกรอบ
                        width: 110,//กว้างของกรอบ
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 15), //เว้นระยะระหว่างรูปกับข้อความ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, //จัดข้อความชิดซ้าย
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ds["Product"],
                          style: AppWidget.semiboldTextFeildStyle(),),
                        SizedBox(height: 5),
                        Text(
                          "฿" + ds["Price"],
                          style: TextStyle(
                            color: (const Color.fromARGB(255, 112, 80, 49)), //สีส้มเหมือนในรูป
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,)),
                        SizedBox(height: 5),
                        Text(
                          "Status : " + ds["Status"],
                          style: TextStyle(
                            color: (const Color.fromARGB(255, 112, 80, 49)), //สีดำสำหรับ Status
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,)),
                    ],)
                  )
                ],
              ),
                ),
              ),
        );
      })
      :Container();
  });
  }
  @override //สินค้าที่สั่่งซื้อ
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color.fromARGB(168, 153, 115, 55),//สีพื้นหลัง
      appBar: AppBar(
               backgroundColor: Color.fromARGB(168, 153, 115, 55),//สีพื้นหลังหัวข้อ
        title: Center(
          child: Text("Current Orders",//คำสั่งซื้อปัจจุบัน
          style: AppWidget.boldTextFeildStyle(),)),),
      body: Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            Expanded(child: allOrders())
      ],
      ),
      )
    );
  }
}