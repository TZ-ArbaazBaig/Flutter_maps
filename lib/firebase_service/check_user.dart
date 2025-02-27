import 'package:currency_converter/firebase_service/auth_service.dart';
import 'package:flutter/material.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({ Key? key }) : super(key: key);

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService.isLoggedIn().then((value){
      if(value){
       Navigator.pushReplacementNamed(context, "/home");
      }
      else{
        Navigator.pushReplacementNamed(context,"login");
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child:CircularProgressIndicator(),),
    );
  }
}