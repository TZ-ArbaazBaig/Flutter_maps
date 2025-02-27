import 'package:currency_converter/demo_api/api_service.dart';
import 'package:currency_converter/demo_api/display_model.dart';
import 'package:currency_converter/demo_api/multi_data_model.dart';
import 'package:currency_converter/demo_api/post_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
void main(){
  runApp(const MaterialApp(
    home:Display()
  ));
}


class Display extends StatefulWidget {
  const Display({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {

   DisplayModel displayModel=DisplayModel();
 _getPost() async {
  var service= await ApiService(client: http.Client()).displayModel();
   setState((){
   displayModel=service!;
   });
 }

 List<Postmodel> posts=[];

 _getPosts() async {
  var service= await ApiService(client: http.Client()).getPosts();
  setState((){
     posts=service!;
  });
 }
 
 MultiData multiData=MultiData();
 bool isdata=true;

 _getMultiData() async {
  var service= await ApiService(client: http.Client()).getMulti();
  setState(() {
    multiData=service!;
    isdata=false;
  });
 }

 @override
  void initState() {
   
    super.initState();
    _getPost();
    _getPosts();
    _getMultiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("display"),
        centerTitle: true,
      ),
      body: 
      Column(
        children: [
          isdata?const CircularProgressIndicator():  Text("Pages:${multiData.total}"),
          Expanded(
            child: ListView.builder(
            itemCount: multiData.data!.length,
            itemBuilder:(context,index){
              return Card(
                child: ListTile(
                  title: Text(multiData.data![index].name.toString()),
                  subtitle: Text(multiData.data![index].color.toString()),
                )
              );
            } 
          ))
        ],
      )
      // Expanded(
      //   child: ListView.builder(
      //     // shrinkWrap: true,
      //     // physics: NeverScrollableScrollPhysics(),
      //     itemCount: posts.length,
      //     itemBuilder: (context,index){
      //       return Card(
      //         child:ListTile(
      //           leading: Text(posts[index].id.toString()),
      //           title: Text("title: ${posts[index].title} "),
      //           subtitle: Text(posts[index].body.toString()),
                
      //         )
      //       );
      //   }),
      // ),
    );
  }
}