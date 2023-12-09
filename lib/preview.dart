import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:frontend/payment.dart';

class PDFPreviewScreen extends StatelessWidget {
  final String pdfPath; // Path of the selected PDF file
  final int cost;

  PDFPreviewScreen({required this.pdfPath, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: PDFView(
                filePath: pdfPath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageSnap: true,
                pageFling: false,
                onRender: (pages) {
                  // PDF document is rendered successfully
                },
                onError: (error) {
                  // Handle error during PDF rendering
                  print(error.toString());
                },
                onPageError: (page, error) {
                  // Handle error during specific page rendering
                  print('Error on page $page: ${error.toString()}');
                },
                onViewCreated: (PDFViewController controller) {
                  // Do something with the controller if needed
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    color: Colors.blue.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cost: ₹$cost',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(width: 200)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                        )
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Payment(
                              title: 'Zebra Print',
                              initialAmount: cost,
                              filepath: pdfPath
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pay',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

