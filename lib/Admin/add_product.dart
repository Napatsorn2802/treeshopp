import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:treeshop/services/database.dart';
import 'package:treeshop/widget/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null && namecontroller.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var dowloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addProduct = {
        "Name": namecontroller.text,
        "Image": dowloadUrl,
        "Price": pricecontroller.text,
        "Detail": detailcontroller.text,
      };
      await DatabaseMethod().addProduct(addProduct, value!).then((value) {
        selectedImage = null;
        namecontroller.text = "";
        pricecontroller.text = "";
        detailcontroller.text = "";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Color(0xFF6B5444),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Product uploaded successfully!",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

  String? value;
  final List<String> categoryitem = [
    'Cantus',
    'Flower',
    'Tree',
    'Fruit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB89968),
      appBar: AppBar(
        backgroundColor: Color(0xFFB89968),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF3D2E1F)),
            )),
        title: Text("Add Product",
            style: TextStyle(
              color: Color(0xFF3D2E1F),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //อัพโหลดรูปสินค้า
                Text(
                  "Upload the Product Image",
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20),
                selectedImage == null
                    ? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF6B5444), width: 2.5),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(Icons.camera_alt_outlined,
                                color: Color(0xFF6B5444), size: 45),
                          ),
                        ),
                      )
                    : Center(
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF6B5444), width: 2.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(selectedImage!,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                SizedBox(height: 30),
                Text(
                  "Product Name", //ชื่อสินค้า
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF8B7355), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Product Price", //ราคาสินค้า
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF8B7355), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: pricecontroller,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Product Detail", //รายละเอียดสินค้า
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF8B7355), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    maxLines: 6, //เพิ่มขนาดช่อง
                    controller: detailcontroller,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Product Category", //หมวดหมู่สินค้า
                  style: AppWidget.lightTextFeildStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF8B7355), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    items: categoryitem
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiboldTextFeildStyle(),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    // เลือกหมวดหมู่
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF6B5444),
                    ),
                    value: value,
                  )),
                ),
                SizedBox(height: 40),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      uploadItem();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF6B5444),
                            Color(0xFF8B6F47),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6B5444).withOpacity(0.4),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        "Add Product",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}