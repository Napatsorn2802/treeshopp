import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:treeshop/pages/onboarding.dart';
import 'package:treeshop/services/auth.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/services/shared_pref.dart';
import 'package:treeshop/widget/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getthesharedpref()async{
    image= await SharedPreferenceHelper().getUserImage();
    name= await SharedPreferenceHelper().getUserName();
    email= await SharedPreferenceHelper().getUserEmail();
    setState(() {
      
    });
  }

  @override
  void initState(){
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }
  uploadItem() async {
    if (selectedImage != null ) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var dowloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(dowloadUrl);
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
               backgroundColor: Color.fromARGB(168, 153, 115, 55),//สีพื้นหลังหัวข้อ
        title: Center(
          child: Text("Profile",//คำสั่งซื้อปัจจุบัน
          style: AppWidget.boldTextFeildStyle(),)),),
      backgroundColor: Color.fromARGB(168, 153, 115, 55),//สีพื้นหลังแอพ
      body: name==null
      ? Center(child : CircularProgressIndicator())
      :Container(
        child: Column(
          children: [
          selectedImage!=null
          ?  GestureDetector(
            onTap: (){
              getImage();
            },
            child: Center(
                  child: ClipRRect(//ภาพเป็นวงกลม
                    child: Image.file(
                      selectedImage!, 
                      height: 90, 
                      width: 90, 
                      fit: BoxFit.cover,
                    ),
                  )
            ),
          )
            
            :GestureDetector(
              onTap: (){
                getImage();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),//ให้ภาพเป็นวงกลม
                child: Center(
                  child: ClipOval(
                    child: Image.network(
                      image!, 
                      height: 90, 
                      width: 90, 
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
             
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color:const Color.fromARGB(168, 255, 255, 255),borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Icon(Icons.person_outline, size: 35,),//ไอค่อนคน
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: AppWidget.lightTextFeildStyle(),),
                    Text(name!, style: AppWidget.semiboldTextFeildStyle(),)
                    ],//มีชื่ออยู่ในกรอบ
                )],),),
              ),
            
             SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                                                    //สีพื้นหลังปุ่ม
                decoration: BoxDecoration(color:const Color.fromARGB(168, 255, 255, 255),borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Icon(Icons.mail_outline, size: 35,),//ไอค่อนอีเมล
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email", style: AppWidget.lightTextFeildStyle(),),
                    Text(email!, style: AppWidget.semiboldTextFeildStyle(),)
                    ],//มีชื่ออยู่ในกรอบ
                )],),),
              ),
            
             SizedBox(height: 20,),
            GestureDetector(
              onTap: ()async{
                  await AuthMethods().SignOut().then((value)=>{
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context)=>Onboarding()))
                  });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color:const Color.fromARGB(168, 255, 255, 255),borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.logout_sharp, size: 35,),//ไอค่อนออก
                    SizedBox(width: 10,),
                      Text("LogOut", style: AppWidget.semiboldTextFeildStyle(),),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_outlined)
                    ],//มีชื่ออยู่ในกรอบ
                    )
                  )
                )
              ),

            SizedBox(height: 20,),
            GestureDetector(
              onTap: ()async{
                await AuthMethods().deleteuser().then((value){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Onboarding()));
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                  child: Container(
                    padding: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color:const Color.fromARGB(168, 255, 255, 255),borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Icon(Icons.delete_outline, size: 35,),//ไอค่อนออก
                    SizedBox(width: 10,),
                            //  ลบบัญชี
                      Text("Dellete Account", style: AppWidget.semiboldTextFeildStyle(),),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_outlined)
                    ],//มีชื่ออยู่ในกรอบ
                    )
                  )
                
              ),
            )
                  ],
                  ),),
              );
  }
}