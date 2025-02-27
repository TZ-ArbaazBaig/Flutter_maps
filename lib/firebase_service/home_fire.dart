import 'package:flutter/material.dart';

class HomeFire extends StatefulWidget {
  const HomeFire({ Key? key }) : super(key: key);

  @override
  _HomeFireState createState() => _HomeFireState();
}

class _HomeFireState extends State<HomeFire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("home"),
        actions: [
          IconButton(onPressed: (){

          }, icon:const Icon(Icons.logout),)
        ],
      ),
    );
  }
}