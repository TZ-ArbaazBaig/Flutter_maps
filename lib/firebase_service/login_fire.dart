import 'package:currency_converter/firebase_options.dart';
import 'package:currency_converter/firebase_service/check_user.dart';
import 'package:currency_converter/firebase_service/home_fire.dart';
import 'package:currency_converter/firebase_service/singup_fire.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    
    MaterialApp(
      routes: {
        "/":(context)=>const CheckUser(),
        "login":(context)=>const LoginFire(),
        "/signup":(context)=>const SingupFire(),
        "/home":(context)=> const HomeFire()
      },
    )
  );
}


class LoginFire extends StatefulWidget {
  const LoginFire({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFireState createState() => _LoginFireState();
}

class _LoginFireState extends State<LoginFire> {
  final _email=TextEditingController();
  final _password=TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Login_Fire")
      ),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                  controller: _email,
                  decoration:const InputDecoration(
                    label: Text("Email")
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: _password,
                  decoration:const InputDecoration(
                    label: Text("Password")
                  ),
                ),
                const SizedBox(height:10),
                ElevatedButton(onPressed: (){

                }, child: const Text("Submit")),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("No Account"),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, "/signup");
                    }, child:const Text("register"))
                  ],)
            ],
          )
          ),
      )
    );
  }
}