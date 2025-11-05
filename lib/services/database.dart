import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treeshop/services/shared_pref.dart';

class DatabaseMethod{

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id)async{
    return await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .set(userInfoMap);
  }
  //ค้นหา
   Future addAllProducts(Map<String, dynamic> userInfoMap,)async{
    return await FirebaseFirestore.instance
      .collection("Products")
      .add(userInfoMap);
  }
  
  Future addProduct(Map<String, dynamic> userInfoMap, String categoryname)async{
    return await FirebaseFirestore.instance
      .collection(categoryname)
      .add(userInfoMap);
  }

      // เพิ่มสินค้าลงตะกร้า
    Future addToCart(Map<String, dynamic> cartItem) async {
      return await FirebaseFirestore.instance
          .collection("cart")
          .add(cartItem);
    }

    // ดึงตะกร้าของผู้ใช้
    Future<Stream<QuerySnapshot>> getUserCart(String email) async {
     return FirebaseFirestore.instance
      .collection("cart")
      .where("UserEmail", isEqualTo: email)
      .snapshots();
      }



    // ลบสินค้าจากตะกร้า
    Future deleteCartItem(String id) async {
      return await FirebaseFirestore.instance
          .collection("cart")
          .doc(id)
          .delete();
    }

   updateStatus(
    String id)async{
    return await FirebaseFirestore.instance
      .collection("Orders")
      .doc(id)
      .update({"Status":"Delivered"});
  }


  Future<Stream<QuerySnapshot>> getProducts(String category)async{
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  
  Future<Stream<QuerySnapshot>> allOrders()async{
    return await FirebaseFirestore.instance
    .collection("Orders")
    .where("Status",isEqualTo: "On the way")
    .snapshots();
  }


  Future<Stream<QuerySnapshot>> getOrders(String email)async{
    return await FirebaseFirestore.instance
    .collection("Orders")
    .where("Email",isEqualTo:email )
    .snapshots();
  }

  Future orderDetails(Map<String, dynamic> userInfoMap)async{
    return await FirebaseFirestore.instance
      .collection("Orders")
      .add(userInfoMap);
  }

  Future<QuerySnapshot> search(String updatedname) async {
  return await FirebaseFirestore.instance
    .collection("Products")
    .where("SearchKey", isEqualTo: updatedname
    .substring(0,1)
    .toUpperCase())
    .get();
}
  // ✅ เพิ่มฟังก์ชันอัปเดตชื่อ
  Future updateUserName(String newName) async {
    String? userId = await SharedPreferenceHelper().getUserId();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"name": newName});
  }
}