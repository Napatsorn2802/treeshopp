import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/pages/product_detail.dart';

import 'package:treeshop/services/database.dart';

class CategoryProduct extends StatefulWidget {
  String category;
  CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getontheload()async{
    CategoryStream= await DatabaseMethod().getProducts(widget.category);
    setState(() {
      
    });
  }

  @override 
  void initState(){
    getontheload();
    super.initState();
  }

Widget allProducts(){
  return StreamBuilder(stream: CategoryStream, builder: (context,AsyncSnapshot snapshot){
    return snapshot.hasData? GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62, 
        mainAxisSpacing: 15.0,
        crossAxisSpacing: 15.0
      ),
      itemCount: snapshot.data.docs.length, 
      itemBuilder: (context, index){
        DocumentSnapshot ds= snapshot.data.docs[index];

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(189, 236, 229, 213),//สีของกรอบสินค้า
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ds["Image"],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36,
                    child: Text(
                      ds["Name"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "฿"+ds["Price"],//แอดราคา
                        style: TextStyle(
                          color: (const Color.fromARGB(255, 112, 80, 49)),//สี
                          fontSize: 18,//ขนาด
                          fontWeight: FontWeight.bold,//ความหนา
                        ),
                      ),
                      //ส่วนของไอค่อนแอดสินค้า
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (
                            context) => ProductDetail(
                              detail: ds["Detail"], 
                              image: ds["Image"], 
                              name: ds["Name"], 
                              price: ds["Price"])));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),//ขนาดปุ่ม
                          decoration: BoxDecoration(//ตกแต่งปุ่ม
                            color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                            borderRadius: BorderRadius.circular(8),//ความโค้งมน
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }):Container();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(146, 196, 165, 115),//สีพื้นหลัง
      appBar: AppBar(backgroundColor: Color.fromARGB(146, 196, 165, 115),),//สีพื้นหลังของหน้าย้อนกลับ
      body: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
        child: Column(
          children: [
            Expanded(child: allProducts())
          ],
        ),
      ),
    );
  }
}