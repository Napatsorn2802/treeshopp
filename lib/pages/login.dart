
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:treeshop/pages/bottomnav.dart';
import 'package:treeshop/pages/signup.dart';
import 'package:treeshop/widget/support_widget.dart';

class LogIn extends StatefulWidget{
const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn>{
String email="", password="";

TextEditingController mailcontroller = new TextEditingController();
TextEditingController passwordcontroller = new TextEditingController();

final _formkey= GlobalKey<FormState>();

userLogin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  
    Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav() ));//เส้นทางพาท
  }on FirebaseAuthException catch(e){
    if(e.code=='user-not-found'){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor:Colors.redAccent,
                      //ไม่พบผู้ใช้สำหรับอีเมลนั้น
      content: Text("No User Found for that Email",style: TextStyle(fontSize: 20),),));
    }                //รหัสผ่านผิด
    else if(e.code=="wrong-password"){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor:Colors.redAccent,
                      //ผู้ใช้ให้รหัสผ่านไม่ถูกต้อง
      content: Text("Wrong Password Provided by User",style: TextStyle(fontSize: 20),),));
    }
  }
}
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 215, 196),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
            margin: EdgeInsets.only(top:40,left: 20,right: 20,bottom: 20),
            child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
          
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("images/รูป.jpg"),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("Sign In",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B5444),
                  )),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    "        Please enter the details below to \n                             contiune.",//กรุณากรอกรายละเอียดด้านล่างเพื่อดำเนินการต่อ  \nขึ้นบรรทัดใหม่
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Email",style:AppWidget.semiboldTextFeildStyle()),//ส่วนอีเมล
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left:20 ),
                  decoration: BoxDecoration(
                    color:Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE8DED2), width: 1.5),
                  ),
                  child: TextFormField(
                     validator: (value){
                        if(value==null||value.isEmpty){
                                  //กรุณากรอกอีเมล์ของคุณ
                          return 'Please Enter your Email';
                        }
                        else
                        return null;
                    },
                    controller: mailcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",//อีเมลในช่อง
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
               SizedBox(height: 40,),
                Text("Password",style:AppWidget.semiboldTextFeildStyle()),//ส่วนรหัสผ่าน
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left:20 ),
                  decoration: BoxDecoration(
                    color:Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE8DED2), width: 1.5),
                  ),
                  child: TextFormField(
                    controller: passwordcontroller,
                     validator: (value){
                        if(value==null||value.isEmpty){
                                  //กรุณากรอกรหัสของคุณ
                          return 'Please Enter your Password';
                        }
                        else
                        return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",//รหัสผ่านในช่อง
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Text("Forgot Passwored?",//ลืมรหัสผ่าน
                     style:TextStyle(color:Color.fromARGB(255, 231, 150, 37),fontSize: 18,fontWeight: FontWeight.w500)),
                   ],
                 ),
                 SizedBox(height: 30,),
                 GestureDetector(
                  onTap:(){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        email=mailcontroller.text;
                        password=passwordcontroller.text;
                      });
                    }
                    userLogin();
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
                   SizedBox(height: 20,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?  ",//ไม่มีบัญชีใช่ไหม?
                    style: AppWidget.lightTextFeildStyle(),),
                    GestureDetector(
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));//เส้นทางพาทคลิกไปหน้าสมัครสมาชิก
                      },
                      child: Text("Sign Up",//สมัครสมาชิก
                      style:TextStyle(color:Color.fromARGB(255, 231, 150, 37),fontSize: 18,fontWeight: FontWeight.w500)),
                    ),
                 ],)
              ],
            ),
          ),
        ),
      )
    );
  }
}