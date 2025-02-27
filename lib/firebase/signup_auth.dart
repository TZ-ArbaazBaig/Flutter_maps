import 'package:currency_converter/demo_api/image_picker/upload_image.dart';
import 'package:currency_converter/firebase/signin_auth.dart';
import 'package:currency_converter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( MaterialApp(
    home: StreamBuilder(
      stream:FirebaseAuth.instance.authStateChanges() ,
      builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting)
      {
        return const Center(child:CircularProgressIndicator());
      }
      if(snapshot.data!=null)
      {
        return const UploadImage();
      }
      return const SignupAuth();
      } 
      )
      ));
        
}
class SignupAuth extends StatefulWidget {
  const SignupAuth({ Key? key }) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _SignupAuthState createState() => _SignupAuthState();
}

class _SignupAuthState extends State<SignupAuth> {

  final _formKey=GlobalKey<FormState>();
  final _signup = TextEditingController();
  final _password = TextEditingController();


  Future<void> createUser()async{
    try{
    var credentilas =await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_signup.text.trim(), password:_password.text.trim());
     if (kDebugMode) {
       print(credentilas);
     }

    } on FirebaseAuthException catch(e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Signup"),
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
              ()async{await createUser();
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              }, child: const Text("submit")),             
              TextButton(onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SigninAuth()));
              }, child:const Text("Signin"))
            ],
          )
        ),
      ),
    );
  }
}