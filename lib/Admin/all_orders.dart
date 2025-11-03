import 'package:flutter/material.dart';
import 'package:treeshop/widget/support_widget.dart';

class AllOrders extends StatefulWidget{
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();

}

class _AllOrdersState extends State<AllOrders>{
  @override
  Widget build(BuildContext constext){
    return Scaffold(
      body:Container(child: Column(children: [
        Center(child: Text("All Orders",style: AppWidget.boldTextFeildStyle(),),)
      ],),) ,
    );
  }
}