import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/Admin/home_admin.dart';
import 'package:treeshop/pages/login.dart';
import 'package:treeshop/widget/support_widget.dart';

class AdminLogin extends StatefulWidget{
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
} 

class _AdminLoginState extends State<AdminLogin>{
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

bool _obscurePassword = true;
@override
  Widget build(BuildContext content){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 215, 196),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top:40,left: 20,right: 20,bottom: 20),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [    
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("images/admin.jpg"),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("Admin Panel",//แผงผู้ดูแลระบบ
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B5444),
                  )),
                ),               
                SizedBox(height: 10,),
                Text("UserName",
                style:AppWidget.semiboldTextFeildStyle()),//ส่วนชื่อ
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left:20 ),
                  decoration: BoxDecoration(
                    color:Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE8DED2), width: 1.5),
                  ),
                  child: TextFormField(
                    
                    controller: usernamecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "User Name",//ชื่อในช่อง
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
               SizedBox(height: 10,),
                Text("Password",style:AppWidget.semiboldTextFeildStyle()),//ส่วนรหัสผ่าน
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 10), // เพิ่ม right padding
                    decoration: BoxDecoration(
                      color:Color(0xFFF4F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE8DED2), width: 1.5),
                    ),
                    child: TextFormField(
                      obscureText: _obscurePassword, // เปลี่ยนจาก true เป็น _obscurePassword
                      controller: userpasswordcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",//รหัสผ่านในช่อง
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        suffixIcon: IconButton( // เพิ่มปุ่มเปิด/ปิด
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                 SizedBox(height: 30,),
                 GestureDetector(
                  onTap: (){
                    loginAdmin();
                  },
                   child: Center(
                     child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color:Color(0xFF6B5444),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Color(0xFF6B5444).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                        child: Center(
                          child: Text("LOGIN",style:TextStyle(
                            color:Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                        ),
                     ),),
                 ),
                 SizedBox(height: 10,),
                 // 🔹 ลิงก์ Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: AppWidget.lightTextFeildStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color.fromARGB(255, 83, 35, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }

  loginAdmin(){
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
        snapshot.docs.forEach( (result){
          if(result.data()['username']!=usernamecontroller.text.trim()){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         backgroundColor:Colors.redAccent ,
                        //ไอดีของคุณไม่ถูกต้อง
         content: Text("Your id is not correct", style: TextStyle(fontSize: 20),
         )));
              } else if (result.data()['password'] !=
              userpasswordcontroller.text.trim()){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor:Colors.redAccent ,
                              //รหัสผ่านของคุณไม่ถูกต้อง
              content: Text("Your password is not correct",
              style: TextStyle(fontSize: 20),
              )));
              }
           else
          {
            Navigator.push(context,MaterialPageRoute(builder: (context)=> HomeAdmin() ));
        }
        });
    });
  }
  }