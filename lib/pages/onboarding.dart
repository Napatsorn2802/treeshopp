// Onboarding.dart - Brown Theme
import 'package:flutter/material.dart';
import 'package:treeshop/pages/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              //สีพื้นหลัง2สีไรเฉด
              Color(0xFF8B6F47),
              Color(0xFFD4C4B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // รูปภาพส่วนบน
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "images/12.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // ส่วนข้อความและปุ่ม
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ไอคอนตกแต่ง
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Color(0xFF8B6F47).withOpacity(0.2),//กรอบสีไอค่อนดอกไม้
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_florist,
                          color: Color(0xFF6B5444),//สีไอค่อนดอกไม้
                          size: 28,
                        ),
                      ),
                      
                      SizedBox(height: 24.0),
                      
                      // ข้อความหลัก
                      Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Color(0xFF8B6F47),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "Our Plant Shop",
                        style: TextStyle(
                          color: Color(0xFF6B5444),
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      
                      SizedBox(height: 16.0),
                      
                      // คำบรรยาย
                      Text(
                        "ค้นพบต้นไม้และพืชพรรณนาๆชนิดที่แสนสวยงามเพื่อตกแต่งบ้านและสวนของคุณ 🌿",
                        style: TextStyle(
                          color: Color.fromARGB(255, 120, 98, 72),
                          fontSize: 20.0,
                          height: 1.5,
                        ),
                      ),
                      
                      SizedBox(height: 40.0),
                      
                      // ปุ่มเริ่มต้น
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (
                          ) {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  //สีปุ่มnext 2สี
                                  Color(0xFF6B5444),
                                  Color(0xFF8B6F47),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Color(0xFF8B6F47).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}