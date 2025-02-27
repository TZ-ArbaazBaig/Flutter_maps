import 'package:currency_converter/demo_api/api_service.dart';
import 'package:currency_converter/demo_api/home_screen.dart';
import 'package:currency_converter/demo_api/login_model.dart';
import 'package:currency_converter/navigation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


void main(){
  runApp(
    const MaterialApp(
      home: Login(),
    )
  );
}


class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController login=TextEditingController();
  TextEditingController password=TextEditingController();

  LoginM model=LoginM();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text("login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text("Login"),
            TextField(
              controller:login,
              decoration: const  InputDecoration(
                hintText: "Enter your email"
              ),
            ),
            TextField(
              controller:password ,
              decoration: const InputDecoration(
                hintText: "Enter your Passwrod"
              ),
            ),
            const SizedBox(height: 13,),
            ElevatedButton(onPressed: (){
              getlogin();           
              
            }, child:const  Text("Login"))
          
          ],
        ),
      ),
    );
  }
  
  void getlogin() async{
     var user = await ApiService(client: http.Client()).getTokec(login.text, password.text);
     setState(() {
       model=user!;
       Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(
        token: user.token.toString(),
        
       )));
     });
  }
}