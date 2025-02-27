// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// class Phonepe extends StatefulWidget {
//   const Phonepe({ Key? key }) : super(key: key);

//   @override
//   _PhonepeState createState() => _PhonepeState();
// }

// class _PhonepeState extends State<Phonepe> {
//    String environment="UAT-SIM";
//     String appId="";
//     String merchantId="PGTESTPAYUAT86";
//     bool enableLogging=true;
    
//     String checkSum="";
//     String saltKey="96434309-7796-489d-8924-ab56988a6076";
//     String saltIndex="1";

//     String callbackUrl="https://dashboard.stripe.com/dashboard";
    
//     String body="";
//     String apiEndPoint="/pg/v1/pay";
//     Object? result;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     phonepeInit();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
  
//   void phonepeInit() {
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//               setState(() {
//                 result = 'PhonePe SDK Initialized - $val';
//               })
//             })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
  
// void startPgTransaction() async {
//   try {
//     var response = await PhonePePaymentSdk.invokeMethod(
//         body, callbackUrl, checkSum, {}, apiEndPoint, "");
//     setState(() {
//       result = response;
//     });
//   } catch (error) {
//     handleError(error);
//   }
// }


  
//   void handleError(error) {
//     setState(() {
//       result={"error":error};
//     });
//   }
// }


