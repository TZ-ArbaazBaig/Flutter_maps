import 'package:currency_converter/multiselect/mutil_controller.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MaterialApp(
    home: MultiView(),
  ));
}

class MultiView extends StatefulWidget {
  const MultiView({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MultiViewState createState() => _MultiViewState();
}


List<String> ab=[];
MutilController cd=MutilController();

class _MultiViewState extends State<MultiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cd.lst.length,
        itemBuilder: (context,index){
          final task=cd.lst[index];
          return ListTile(
            title: Text(task.hobbies),
          );
   
      })
      );
    
  }
}