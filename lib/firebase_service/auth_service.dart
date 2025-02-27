import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  
  static Future<String> createAccount(String email,String password)async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email,password:password);
      return "Account created";
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }
  }

  static Future<String> loginWithEmail(String email,String password)async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email:email,password:password);
      return "Login Sucessful";
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }
  }

  static Future logout()async{
        await FirebaseAuth.instance.signOut();
        return "Logout Sucessful";
  }

  //check
  static Future<bool> isLoggedIn()async{
    var user=FirebaseAuth.instance.currentUser;
    return user !=null;

  }

}