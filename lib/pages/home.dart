import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/pages/allproducta.dart';
import 'package:treeshop/pages/category_products.dart';
import 'package:treeshop/pages/product_detail.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
import 'package:treeshop/widget/support_widget.dart';

class Home extends StatefulWidget{
  const Home ({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
bool search=false;  
List categories=[//ภาพหมวดหมู่
  "images/icons8-cactus-50.png",
  "images/icons8-flower-50.png",
  "images/icons8-tree-50.png",
  "images/icons8-fruit-50.png"
];

List Categoryname=[
 "Cantus",
 "Flower",
 "Tree",
 "Fruit"
];

//ค้นหา
  var queryResultSet=[];
  var tempSearchStore=[];
  TextEditingController searchcontroller= new TextEditingController();

initiateSearch(value){
  // จัดการค่าว่าง (RangeError fix)
  if(value.isEmpty){
    setState(() {
      search = false;
      queryResultSet=[];
      tempSearchStore=[];
    });
    return;
  }
  
  setState(() {
    search=true;
  });

  // เตรียมค่าค้นหาสำหรับ Local Filtering 
  String searchValueLower = value.toLowerCase();

  // เรียกค้นข้อมูลจาก Firestore เสมอ DatabaseMethod().search(value) จะส่งค่า 'value' ไปจำกัด Query ใน Firestore
  DatabaseMethod().search(value).then((QuerySnapshot docs){
    // บันทึกผลลัพธ์จาก Firestore
    queryResultSet = []; 
    for(var doc in docs.docs){
      queryResultSet.add(doc.data() as Map<String, dynamic>);
    }
    
    //กรองผลลัพธ์ทั้งหมดที่ดึงมาในเครื่อง (Local Filtering)
    tempSearchStore = [];
    queryResultSet.forEach((element) {
      String productName = element['Name']?.toString().toLowerCase() ?? "";
      
      // ใช้ .contains() เพื่อค้นหาข้อความย่อยที่ตรงกัน 
      if(productName.contains(searchValueLower)){
        tempSearchStore.add(element);
      }
    });

    setState(() {}); // อัปเดต UI
  });

}




String? name, image;

getthesharedpref()async{
  name= await SharedPreferenceHelper().getUserName();
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
  ontheload();
  super.initState();
}

  @override
  Widget build (BuildContext context){ // เปลี่ยน constext เป็น context
    return Scaffold(
       backgroundColor: Color.fromARGB(168, 153, 115, 55),
      body: name== null? Center(child: CircularProgressIndicator()): Container(
        margin: const EdgeInsets.only(top: 50,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ส่วน Header และรูปภาพ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "Hey:" +name!,
                  style: AppWidget.boldTextFeildStyle(),
                    ),
                    Text("Welcome to the tree shop.",//ยินดีต้อนรับสู่ร้านต้นไม้
                    style: AppWidget.lightTextFeildStyle().copyWith(
                     fontSize: 18,
                    ),
                    )
                ],
              ),
                ClipRRect( 
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    image!,
                  height: 75,
                  width: 75, 
                  fit: BoxFit.cover,)
                  ),
            ],
          ),
          
          // ช่องค้นหาสินค้า
          const SizedBox(height: 30,),
            Container(
              decoration:BoxDecoration(color:const Color.fromARGB(168, 255, 255, 255),
              borderRadius: BorderRadius.circular(20)) ,//ให้เป็นวงกลม
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: searchcontroller,
                onChanged: (value){
                  initiateSearch(value.toUpperCase());
                },
                decoration: InputDecoration(
                border:InputBorder.none,
                hintText: "Search products",
                hintStyle:AppWidget.lightTextFeildStyle(),
                prefixIcon: search? GestureDetector(
                  onTap: (){
                    search=false;
                    tempSearchStore=[];
                    queryResultSet=[];
                    searchcontroller.text="";
                    setState(() {
                      
                    });
                  },
                  child: Icon(Icons.close)): Icon(
                  Icons.search,
                color:Color.fromARGB(255, 112, 80, 49))),//ไอค่อนค้นห่
              ),
            ),
            
             SizedBox(height: 20,),//เว้นระยะห่าง
            
            // หมวดหมู่ (Categories) พร้อมการเรียกใช้ Custom Font ที่ถูกต้อง
           search? Expanded(
             child: ListView(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element){
                return buildResultCard(element);
              }).toList(),
             ),
           ): Padding(
            padding: const EdgeInsets.only(right: 20),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children:[ Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",//หมวดหมู่
                      style: AppWidget.semiboldTextFeildStyle()
                    ),
                    /*Text(
                      "See all",//ดูทั้งหมด
                      style: TextStyle(
                        color: (const Color.fromARGB(255, 112, 80, 49)),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,)
                    )*/
                  ],
                ),
               ]
             ),
           ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  height: 130,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color:Color.fromARGB(255, 115, 80, 47),
                    borderRadius: BorderRadius.circular(10)
                  ),           //All
                  child: Center(
                    child: Text(
                    "All", 
                    style: TextStyle(
                    color:Colors.white,
                    fontSize:20,
                    fontWeight:FontWeight.bold,)),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 140,
                    child:ListView.builder(
                      padding:EdgeInsets.zero ,
                      itemCount: categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                      return CategoryTile(image: categories[index],name: Categoryname[index],);  
                      }
                      ) ,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),//เว้นระยะห่าง
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Products",//สินค้าทั้งหมด
                  style: AppWidget.semiboldTextFeildStyle()
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> const AllProducts()),);
                  },
                  child: const Text(
                    "See all",//ดูทั้งหมด
                    style: TextStyle(
                      color: (const Color.fromARGB(255, 112, 80, 49)),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,)
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
           Container(
          height: 260,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              // Product 1
              Container(
                width: 160,
                height: 260,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(131, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปสินค้า
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/4.jpg",
                        height: 120,
                        width: 136,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                    // ข้อมูลสินค้า
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ชื่อสินค้า - กำหนดความสูงคงที่
                        Container(
                          height: 36,
                          child: Text(
                            "Mammillaria Plumosa",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // ราคาและปุ่ม
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "฿25",//ราคา
                              style: TextStyle(
                                color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                                fontSize: 18,//ขนาด
                                fontWeight: FontWeight.bold,//ความหนา
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),//ขนาดปุ่ม
                              decoration: BoxDecoration(//ตกแต่งปุ่ม
                                color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                                borderRadius: BorderRadius.circular(8),//ความโค้งมน
                              ),
                              child: Icon(//ไอคอนปุ่ม
                                Icons.shopping_cart_outlined,
                                color: Colors.white,//สี
                                size: 18,//ขนาด
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Product 2
              Container(
                width: 160,
                height: 260,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(131, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/2.jpg",
                        height: 120,
                        width: 136,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 36,
                          child: Text(
                            "Petrea volubilis",
                            style: TextStyle(
                              fontSize: 15,
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
                              "฿45",//ราคา
                              style: TextStyle(
                                color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                                fontSize: 18,//ขนาด
                                fontWeight: FontWeight.bold,//ความหนา
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),//ขนาดปุ่ม
                              decoration: BoxDecoration(//ตกแต่งปุ่ม
                                color: (const Color.fromARGB(255, 112, 80, 49)),//สี
                                borderRadius: BorderRadius.circular(8),//ความโค้งมน
                              ),
                              child: Icon(//ไอคอนปุ่ม
                                Icons.shopping_cart_outlined,
                                color: Colors.white,//สี
                                size: 18,//ขนาด
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Product 3
              Container(
                width: 160,
                height: 260,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(131, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/3.jpg",
                        height: 120,
                        width: 136,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 36,
                          child: Text(
                            "Tomato tree",
                            style: TextStyle(
                              fontSize: 15,
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
                              "฿35",//ราคา
                              style: TextStyle(
                                color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                                fontSize: 18,//ขนาด
                                fontWeight: FontWeight.bold,//ความหนา
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),//ขนาดปุ่ม
                              decoration: BoxDecoration(//ตกแต่งปุ่ม
                                color: (const Color.fromARGB(255, 112, 80, 49)),//สี
                                borderRadius: BorderRadius.circular(8),//ความโค้งมน
                              ),
                              child: Icon(//ไอคอนปุ่ม
                                Icons.shopping_cart_outlined,
                                color: Colors.white,//สี
                                size: 18,//ขนาด
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Product 4
              Container(
                width: 160,
                height: 260,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                 color: const Color.fromARGB(131, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "images/1.jpg",
                        height: 120,
                        width: 136,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 36,
                          child: Text(
                            "Passiflora edulis",
                            style: TextStyle(
                              fontSize: 15,
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
                              "฿45",//ราคา
                              style: TextStyle(
                                color: (const Color.fromARGB(255, 112, 80, 49)),//สี
                                fontSize: 18,//ขนาด
                                fontWeight: FontWeight.bold,//ความหนา
                              ),
                            ),
                            Container(
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]
          )
        )
          ]
        )
      )
    );
  }

  Widget _buildProductCard({required String imagePath, required String name, required String price}) {
    return Container(
      width: 160,
      height: 260,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(131, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // รูปสินค้า
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 120,
              width: 136,
              fit: BoxFit.cover,
            ),
          ),
          
          // ข้อมูลสินค้า
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อสินค้า - กำหนดความสูงคงที่
              Container(
                height: 36,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 12),
              
              // ราคาและปุ่ม
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,//ราคา
                    style: TextStyle(
                      color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                      fontSize: 18,//ขนาด
                      fontWeight: FontWeight.bold,//ความหนา
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),//ขนาดปุ่ม
                    decoration: BoxDecoration(//ตกแต่งปุ่ม
                      color:(const Color.fromARGB(255, 112, 80, 49)),//สี
                      borderRadius: BorderRadius.circular(8),//ความโค้งมน
                    ),
                    child: Icon(//ไอคอนปุ่ม
                      Icons.shopping_cart_outlined,
                      color: Colors.white,//สี
                      size: 18,//ขนาด
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  //เวลาค้นหาละภาพสินค้าชื่อจะอยู่ตรงส่วนนี้
   Widget buildResultCard(data){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(detail: data["Detail"], image: data["Image"], name: data["Name"], price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10),//ทางซ้ายของรูปภาพ
        margin: EdgeInsets.only(bottom: 10),//เพิ่มช่องว่างด้านล่าง
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromARGB(131, 255, 255, 255),//สีพื้นหลังของกรอบสินค้า
          borderRadius: BorderRadius.circular(10),//ความโค้งมนของภาพ
        ),
        height: 100,
        child: Row(children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(10),//ความโค้งมนของภาพ
          child:  Image.network(data["Image"], height: 80,width: 80,fit: BoxFit.cover,)),//การปรับขนาดของภาพ
          SizedBox(width: 20,),//ระยะความกว้าง
          Text(data["Name"],style: AppWidget.semiboldTextFeildStyle(),)
        ],),
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryTile extends StatelessWidget{
  String image,name;
  CategoryTile({required this.image,required this.name});

  @override
  Widget build (BuildContext constext){
    return GestureDetector(
      onTap: (){
        Navigator.push(constext, MaterialPageRoute(builder: (constext)=>CategoryProduct(category: name) ));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(131, 255, 255, 255),//สีพื้นหลังของไอค่อยตัวเลือก
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Image.asset(image, 
          height: 50,
          width: 50, 
          fit: BoxFit.cover,),
          Icon(Icons.arrow_forward,color:Color.fromARGB(255, 79, 55, 32),) //ไอค่อนชีไปทางขวา
          
        ],),
      ),
    );
  }
 
}