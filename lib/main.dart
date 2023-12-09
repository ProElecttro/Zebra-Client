import 'package:flutter/material.dart';
import 'package:frontend/payment.dart';
import 'package:frontend/preview.dart';
import 'package:frontend/print.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/' : (context) => Home(),
        // '/print' : (context) => Print(),
        // '/preview' : (context) => PreviewScreen(doc: ),
      }
    );
  }
}
