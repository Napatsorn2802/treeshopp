import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:treeshop/services/constant.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
// ignore: unused_import
import 'package:treeshop/widget/support_widget.dart';
import 'package:http/http.dart'as http;
// ignore: must_be_immutable
class ProductDetail extends StatefulWidget {
  String image, name, detail, price;
  // ignore: use_key_in_widget_constructors
  ProductDetail(
      {required this.detail,
      required this.image,
      required this.name,
      required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
//ออเดอร์
String? name, mail, image;

getthesharedpref()async{
  name= await SharedPreferenceHelper().getUserName();
  mail= await SharedPreferenceHelper().getUserEmail();
  image= await SharedPreferenceHelper().getUserImage();
  setState(() {
  });
} 

ontheload()async{
  await getthesharedpref();
  setState(() {
  });
}

@override
void initState(){
  super.initState();
  ontheload();
}

Map<String, dynamic>? paymentIntent;//ชำระเงิน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(146, 113, 94, 64),//สีพื้นหลังของทุกกรอบ
      body: Column(
        children: [
          // ส่วนรูปภาพและปุ่มย้อนกลับ
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:  Color.fromARGB(146, 121, 102, 73),//สีพื้นหลังของช่องภาพ
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30), // ทำให้รูปภาพมีความโค้งมน
                      child: Image.network(
                        widget.image,
                        height: 340,
                        width: 340,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ส่วนข้อมูลสินค้า
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(243, 255, 255, 255),//สีพื้นหลังของช่วงล่างลงมา
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.black,//เปลี่ยนสีของข้อความ
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 221, 195, 153),//สีของกรอบรอบราคา (ทำให้จางลง)
                          borderRadius: BorderRadius.circular(25), // เพิ่มความโค้งมนของกรอบราคา
                        ),
                        child: Text(
                          "฿" + widget.price,
                          style: TextStyle(
                            color: (const Color.fromARGB(255, 112, 80, 49)),//สีของเลขราคา
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  //กรอกรสยละเอียดสินค้า
                  Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.detail, //รายระเอียดสินค้า
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ปุ่ม Buy now ติดด้านล่าง
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                makePayment(widget.price);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Color(0xFF6B4E28),//สีของกรอบชำละเงิน
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6B4E28).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Buy now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> makePayment(String amoun)async{
    try{
paymentIntent= await createPaymentIntent(amoun,'THB');
await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
  paymentIntentClientSecret: paymentIntent?['client_secret'],
  style: ThemeMode.dark,merchantDisplayName: 'Adnan'
)).then((value) {});

displayPaymentSheet();
    }catch(e, s){
      print('exception:$e$s');
    }
  }

  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        //ออเดอร์
        Map<String, dynamic> orderInfoMap={
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email":mail,
          "Image":image,
          "ProductImage":widget.image,
          "Status": "On the way"
        };
        await DatabaseMethod().orderDetails(orderInfoMap);
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (_)=> AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min,
          children: [Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green,),
              Text("Payment Successfull")//ชำระเงินสำเร็จ
            ],
            )],
            ),
        ));
        paymentIntent=null;
      }).onError((error, stackTrace){
          print("Error is :---> $error $stackTrace");
      });
    } on StripeException catch(e){
      print("Error is:---> $e");
      showDialog(context: context, 
      builder: (_) => AlertDialog(
        content: Text("Cancelled"),
      ));
    }catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amoun,String currency)async{
    try{
      Map<String, dynamic>body = {
        'amount': calculateAmount(amoun),//จำนวน
        'currency':currency,//สกุลเงิน
        'payment_method_types[]':'card'//ประเภทวิธีการชำระเงิน
      };

      var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),//apiของstripe
                  //การอนุญาต
      headers: {
        'Authorization': 'Bearer $secretkey', //การอนุญาต
        'Content-Type': 'application/x-www-form-urlencoded',//ประเภทเนื้อหา
        },body: body,
        );
        return jsonDecode(response.body);
    }catch (err) {
        //การเรียกเก็บเงินผู้ใช้ผิดพลาด
    print('err charging user: ${err.toString()}');
  }
  }

  calculateAmount(String amoun){
    final calculateAmount = (int.parse(amoun) * 100);
    return calculateAmount.toString();
  }
} 
