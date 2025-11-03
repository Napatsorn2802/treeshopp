import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:treeshop/pages/bottomnav.dart';
import 'package:treeshop/pages/login.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
import 'package:treeshop/widget/support_widget.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{
String? name, email, password;
TextEditingController namecontroller = new TextEditingController();
TextEditingController mailcontroller = new TextEditingController();
TextEditingController passwordcontroller = new TextEditingController();

final _formkey=GlobalKey<FormState>();

registration()async{
  if(password!=null && name!=null && email!=null){
    try{
      UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor:Color.fromARGB(255, 46, 155, 16),
                      //ลงทะเบียนเรียบร้อยแล้ว
      content: Text("Registered Successfully",style: TextStyle(fontSize: 20),),));
      String Id= randomAlphaNumeric(10);//ให้IDแบบสุ่ม
      await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
      await SharedPreferenceHelper().saveUserId(Id);
      await SharedPreferenceHelper().saveUserName(namecontroller.text);
      //ลิ้งภาพจากอินเทอร์เน็ต
      await SharedPreferenceHelper().saveUserImage("https://cms.dmpcdn.com/moviearticle/2023/10/19/63a71380-6e35-11ee-96a4-83202a4973b8_webp_original.webp");
      Map<String, dynamic> userInfoMap={
        "Name": namecontroller.text,
        "Email": mailcontroller.text,
        "Id": Id,
          "Image"://ลิ้งภาพจากอินเทอร์เน็ต
          "https://cms.dmpcdn.com/moviearticle/2023/10/19/63a71380-6e35-11ee-96a4-83202a4973b8_webp_original.webp"
      };
      await DatabaseMethod().addUserDetails(userInfoMap, Id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNav()));
    }on FirebaseException catch(e){
                  //รหัสผ่านที่อ่อนแอ
      if(e.code=='weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         backgroundColor:Color.fromARGB(255, 241, 228, 80) ,
                        //รหัสผ่านที่ให้มาไม่แข็งแรงพอ
         content: Text("Password Provided is too Weak", style: TextStyle(fontSize: 20),),));
      }                 //อีเมลที่ใช้งานแล้ว
      else if(e.code=="email-already-in-use"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         backgroundColor:Color.fromARGB(255, 241, 228, 80)  ,
                        //บัญชีมีอยู่แล้ว
         content: Text("Account Already exsists", style: TextStyle(fontSize: 20),),));
      }
    }
  }
}
bool _obscurePassword = true;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 215, 196),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top:40,left: 20,right: 20,bottom: 20),
          child: Form(
            key: _formkey,
            child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
                    
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("images/รูป.jpg"),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("Sign Up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B5444),
                  )),
                ),
                SizedBox(height: 5,),
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
                SizedBox(height: 10,),
                Text("Name",style:AppWidget.semiboldTextFeildStyle()),//ส่วนชื่อ
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
                                  //กรุณากรอกชื่อของคุณ
                          return 'Please Enter your Name';
                        }
                        else
                        return null;
                    },
                    controller: namecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "User Name",//อีเมลในช่อง
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                 SizedBox(height: 10,),
                Text("Email",style:AppWidget.semiboldTextFeildStyle()),//ส่วนอีเมล
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
               SizedBox(height: 10,),
                Text("Password", style: AppWidget.semiboldTextFeildStyle()), // ส่วนรหัสผ่าน
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE8DED2), width: 1.5),
                    ),
                    child: TextFormField(
                      obscureText: _obscurePassword, // เปลี่ยนจาก true เป็น _obscurePassword
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // กรุณากรอกรหัสของคุณ
                          return 'Please Enter your Password';
                        }
                        return null;
                      },
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password", // รหัสผ่านในช่อง
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        suffixIcon: IconButton(
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
                SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Text("Forgot Passwored?",//ลืมรหัสผ่าน
                     style:TextStyle(color:Color.fromARGB(255, 83, 35, 1),fontSize: 18,fontWeight: FontWeight.w500)),
                   ],
                 ),
                 SizedBox(height: 10,),
                 GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState(() {
                        name = namecontroller.text;
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                    }
                    registration();
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
                          child: Text("SIGN UP",style:TextStyle(
                            color:Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                        ),
                     ),),
                 ),
                   SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?  ",//มีบัญชีใช่ไหม?
                    style: AppWidget.lightTextFeildStyle(),),
                    GestureDetector(
                      onTap: (){ 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));//เส้นทางพาทคลิกไปหน้าเข้าสู่ระบบ
                      },
                      child: Text("Sign In",//สมัครสมาชิก
                      style:TextStyle(color:Color.fromARGB(255, 83, 35, 1),fontSize: 18,fontWeight: FontWeight.w900)),
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