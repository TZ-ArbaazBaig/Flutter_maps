import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String? token;
  const HomeScreen({ Key? key,required this.token }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("data")
      ),
      body:Center(
        child: Text("Token ${widget.token}",textScaleFactor: 2,),
      )
    );
  }
}