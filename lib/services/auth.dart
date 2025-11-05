import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods{
  final FirebaseAuth auth= FirebaseAuth.instance;

  Future SignOut()async{
    await FirebaseAuth.instance.signOut();
  }

  Future deleteuser()async{
    User? user= await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}