import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:file_picker/file_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zebra Print - Razorpay',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(
        title: 'Zebra Print',
        initialAmount: 0,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.initialAmount,
  }) : super(key: key);

  final String title;
  final int initialAmount;
  ///////////////////////////////////////////////////////

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    launchPayment();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void launchPayment() async {
    var options = {
      'key': 'rzp_test_u2BdyK2fSZ8VSh',
      'amount': widget.initialAmount * 100,
      'name': 'Zebra Print.',
      'description': 'Test Payment for Zebra Printer App',
      'prefill': {'contact': '', 'email': ''},
      'external': {'wallets': []}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Error' +
          response.code.toString() +
          ' ' +
          response.message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Success' + response.paymentId.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    _createPdf();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'Success' + response.walletName.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

    void _createPdf() async {
      final doc = pw.Document();

      // ... (PDF content creation code)

      // Print the document using the iOS or Android print service:
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());

      // ... (Share the document to other applications or save with path_provider)
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Demo to make payment inside flutter app'),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () {
                launchPayment();
              },
              child: const Text('PAY NOW'),
            )
          ],
        ),
      ),
    );
  }
}
