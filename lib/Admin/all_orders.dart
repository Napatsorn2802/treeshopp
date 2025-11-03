import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/widget/support_widget.dart';

class AllOrders extends StatefulWidget{
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();

}

class _AllOrdersState extends State<AllOrders>{
  Stream? orderStream;

  getontheload()async{
    orderStream= await DatabaseMethod().allOrders();
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
                    color: Colors.white,//สีกรอบการสั่งซื้อ
                    borderRadius: BorderRadius.circular(10),//ความโค้งมนของกรอบ
                  ),
                    child: Row(
                    children: [ 
                      ClipOval(//ให้รูปภาพเป็นวงกลม
                        child: Image.network(
                          ds["Image"],//รูปภาพ
                          height: 80,//สูงของกรอบ
                          width: 80,//กว้างของกรอบ
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 15), //เว้นระยะระหว่างรูปกับข้อความ
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //จัดข้อความชิดซ้าย
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //รับค่าชื่อ
                            Text(
                              "Name :"+ds["Name"],
                              style: AppWidget.semiboldTextFeildStyle(),),
                            //รับค่าอีเมล
                            Container(
                              width: MediaQuery.of(context).size.width/2,
                            child: Text(
                              "Email :"+ds["Email"],
                              style: AppWidget.lightTextFeildStyle(),),//ทำให้สีฟอนจางลง
                            ),
                            //รับค่าสินค้าที่ซื้อ
                             Text(
                              ds["Product"],
                              style: AppWidget.semiboldTextFeildStyle(),),
                               //รับค่าราคาสินค้า
                               Text(
                              "฿" + ds["Price"],
                              style: TextStyle(
                                color: (const Color.fromARGB(255, 112, 80, 49)), //สีส้มเหมือนในรูป
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,)),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: ()async{
                                   await DatabaseMethod().updateStatus(ds.id);
                                   setState(() { });   
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    width: 150,
                                    decoration: BoxDecoration(color:  Color.fromARGB(255, 232, 43, 43),borderRadius: BorderRadius.circular(10)),//กรอบสีอดง มุมโค้งมน
                                    child: Center(child: 
                                    Text("Done", 
                                    style: AppWidget.semiboldTextFeildStyle(),)),
                                  ),
                                )
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
  @override
  Widget build(BuildContext constext){
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("All Orders",style: AppWidget.boldTextFeildStyle(),))),
      body:Container(
        margin: EdgeInsets.only(top:10, left:20 ,right:20 ),//บน ซ้าย ขวา ของออเดอร์
        child: Column(children: [
       Expanded(child: allOrders()),
      ],),) ,
    );
  }
}