import 'package:flutter/material.dart';





class SingupFire extends StatefulWidget {
  const SingupFire({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginFireState createState() => _LoginFireState();
}

class _LoginFireState extends State<SingupFire> {
  final _email=TextEditingController();
  final _password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Singup_Fire")
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

                }, child: const Text("Sign up")),
                const SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Already have an account"),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child:const Text("login"))
                  ],)
            ],
          )
          ),
      )
    );
  }
}