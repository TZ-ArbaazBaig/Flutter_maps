import 'package:currency_converter/firebase/signup_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:currency_converter/demo_api/image_picker/upload_image.dart';


class SigninAuth extends StatefulWidget {
  const SigninAuth({ Key? key }) : super(key: key);

  @override

  _SignupAuthState createState() => _SignupAuthState();
}

class _SignupAuthState extends State<SigninAuth> {

  final _formKey=GlobalKey<FormState>();
  final _signup = TextEditingController();
  final _password = TextEditingController();


  Future<void> loginUser()async{
    try{
    var credentilas =await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_signup.text.trim(), password:_password.text.trim());
    print(credentilas);

    } on FirebaseAuthException catch(e) {
      print(e.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Signin"),

      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller:_signup ,
                decoration:const InputDecoration(
                  labelText: "Enter Your Email",
        
                ),
                validator: (value)=>value!.isEmpty?"email is required":null,
              ),
              TextFormField(
                controller:_password ,
                decoration:const InputDecoration(
                  labelText: "Enter Your Password",
        
                ),
                validator: (value)=>value!.isEmpty?"Password is required":null,
              ),
              ElevatedButton(onPressed: 
              ()async{await loginUser();
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const UploadImage()));
              }, child: const Text("submit")),
              TextButton(onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupAuth()));

              }, child:const Text("New User"))
            ],
          )
        ),
      ),
    );
  }
}