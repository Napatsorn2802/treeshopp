import 'package:flutter/material.dart';
import 'package:treeshop/Admin/add_product.dart';
import 'package:treeshop/Admin/all_orders.dart';
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
      backgroundColor: Color(0xA8BF9551),//สีพื้นหลังหัวข้อ
       appBar: AppBar(
      backgroundColor: Color(0xA8BF9551),//สีพื้นหลังหัวข้อ  
        title: Center(
          child: Text("Home Admin",
          style: AppWidget.boldTextFeildStyle(),)),),
      body:Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProduct()));
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color:(const Color.fromARGB(225, 185, 133, 82)),borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size:50),
                      SizedBox(width: 20,),
                      Text("Add Product",style: AppWidget.boldTextFeildStyle(),)
                    ],),
                ),
              ),
            ),
             SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AllOrders()));
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color:(const Color.fromARGB(225, 185, 133, 82)),borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, size:50),
                      SizedBox(width: 20,),
                      Text("All Orders",style: AppWidget.boldTextFeildStyle(),)
                    ],),
                ),
              ),
            )
          ],
        ),
      )
    
    );
  }
}