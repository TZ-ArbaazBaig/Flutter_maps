import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


void main() {
  runApp(MaterialApp(home: RazorpayExample()));
}


class RazorpayExample extends StatefulWidget {
  @override
  _RazorpayExampleState createState() => _RazorpayExampleState();
}

class _RazorpayExampleState extends State<RazorpayExample> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Set up event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all listeners to avoid memory leaks
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful! Payment ID: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed! Error: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_ABC123XYZ', // Replace with your test key ID
      'amount': 50000, // Amount in paise (₹500)
      'name': 'Test Merchant',
      'description': 'Test Transaction',
      'prefill': {
        'contact': '9876543210', // Pre-filled phone number
        'email': 'test@example.com', // Pre-filled email address
      },
      'theme': {
        'color': '#F37254', // Theme color for the payment screen
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razorpay Integration'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startPayment,
          child: Text('Pay ₹500'),
        ),
      ),
    );
  }
}

