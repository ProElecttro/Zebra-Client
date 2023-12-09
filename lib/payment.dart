import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:io';

Map data = {};

class Payment extends StatefulWidget {
  const Payment({
    Key? key,
    required this.title,
    required this.initialAmount,
    required this.filepath
  }) : super(key: key);

  final String title;
  final int initialAmount;
  final String filepath;

  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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

  void _printExistingPdf(String filePath) async {
    File file = File(filePath);

    if (await file.exists()) {
      Uint8List fileBytes = await File(filePath).readAsBytes();

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => fileBytes);
      print('Print Successful');
    } else {
      print("File does not exist");
    }
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
    print('payment successfully done');
    // Navigator.pushReplacementNamed(context, '/print');
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
                _printExistingPdf(widget.filepath);
              },
              child: const Text('Print'),
            )
          ],
        ),
      ),
    );
  }
}
