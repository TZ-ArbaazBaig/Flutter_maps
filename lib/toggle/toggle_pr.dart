import 'package:currency_converter/toggle/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child:const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Autocomplete',
      // theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home:const TogglePr(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}


class TogglePr extends StatefulWidget {
  const TogglePr({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TogglePrState createState() => _TogglePrState();
}
// bool _isSelect=true;

class _TogglePrState extends State<TogglePr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon:const Icon(Icons.more_vert)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:10),
            child: Consumer<ThemeProvider>(
              builder:(context,themeProvider,child){
                return Switch(value: themeProvider.isSelect,
              thumbIcon: MaterialStatePropertyAll(
                themeProvider.isSelect?const Icon(Icons.nights_stay):const Icon(Icons.sunny)
              ),
               onChanged: (value){
               themeProvider.toggle();
              
              });
              } ,
           
            ),
          )
        ],
      ),
      body:Container(
        padding:const EdgeInsets.all(10),
        child:Center(
          child:  Column(
            children:[
              const Text("Abubi",style: TextStyle(fontSize: 30),),
              Consumer<ThemeProvider>(
                builder:(context,themeProvider,child){
                  return Icon(
                    themeProvider.isSelect?Icons.nights_stay:
                    Icons.sunny,color: themeProvider.isSelect?Colors.white:Colors.orange,size:100);
                } ,
   ),
              const SizedBox(height: 10,),
              const Text("20 c",style: TextStyle(fontSize:30,fontWeight:FontWeight.bold)),
              const SizedBox(height: 10,),
              const Text("Good Morning",style: TextStyle(fontSize:20,fontWeight:FontWeight.bold))
            ]
          ),
        ),
      )
    );
  }
}