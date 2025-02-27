import 'dart:convert';
import 'package:currency_converter/payment/keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=publishKey;
  await Stripe.instance.applySettings();
  runApp(
    const MaterialApp(
      home: DemoP(),
    )
  );
}

class DemoP extends StatefulWidget {
  const DemoP({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DemoPState createState() => _DemoPState();
}

class _DemoPState extends State<DemoP> {
  double amount=200.9;
   Map<String,dynamic>? intentpay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("pay me"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("The Amount is $amount"),
            ElevatedButton(onPressed: 
            ()async{
              payment(
                amount.round().toString(),
                "INR");
            }, child: const Text("Click to pay"))
          ],
        ),
      ),
    );
  }
  
   payment( amount, String currency) async{
    try{
      intentpay=await makeIntentpayment(amount, currency);

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: intentpay!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Slayer",


      )).then((val){
        print(val);
      });

      showPaymentSheet();
    }catch(e){
      if (kDebugMode) {
        print("Error: $e");
      } 
    }

  }
  
  makeIntentpayment( amount,  currency)async{
    try{
     Map<String,dynamic> paymentInfo={
        // "amount": (int.parse(amount )*100).toString(),
        "amount": (int.parse(amount) * 100).toString(),
        "currency": currency,
        // "payemnt_method_types[]":"card"
        "payment_method_types[]": "card"

     };
     var response=await http.post(
      // Uri.parse(" https://api.stripe.com/v1/payment_intents "),
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: paymentInfo,
      headers: { 
      "Authorization":"Bearer $secretKey",
      "Content-Type":"application/x-www-form-urlencoded"
        
      }
      );
        return json.decode(response.body);
    }
    catch(e){
      print(e);
    }

  }
  
   
   
   showPaymentSheet() async{
    try{
        await Stripe.instance.presentPaymentSheet().then((val){
          intentpay=null;
        }).onError((error,sTrace){
          print(error.toString()+sTrace.toString());
        });
    }
    on StripeException catch(e)
    {
      if (kDebugMode) {
        print(e);
      }
      showDialog(
        // ignore: use_build_context_synchronously
        context: 
      context, builder: (BuildContext context) =>

       const AlertDialog(
        content:Text("cancelled")

       )
      ); 
        
    }  
      // builder: (BuildContext context) {

      // }

    catch(e){
      print(e);
    }
   
   }}