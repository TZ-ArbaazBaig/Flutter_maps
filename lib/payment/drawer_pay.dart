import 'package:currency_converter/payment/demo_p.dart';
import 'package:currency_converter/payment/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';  // Razorpay package (as an example)

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=publishKey;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentSidebar(),
    );
  }
}

class PaymentSidebar extends StatelessWidget {
  final Razorpay _razorpay = Razorpay();

  PaymentSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Sidebar'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Payment Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Stripe'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const DemoP()));
              },
            ),
            ListTile(
              title: const Text('Razorpay'),
              onTap: () {
                // _openRazorpay();
              },
            ),
            ListTile(
              title: const Text('PhonePe'),
              onTap: () {
                // Ad
              },
            ),
            ListTile(
              title: const Text('Amazon Pay'),
              onTap: () {
                // Add Amazon Pay integration code here
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Choose a Payment Option'),
      ),
    );
  }

  void _openRazorpay() {
    var options = {
      'key': 'your_key_here',
      'amount': 100,  // amount in paise
      'name': 'Flutter Payment',
      'description': 'Payment for services',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@example.com'
      }
    };

    _razorpay.open(options);
  }
}
