import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/payment.dart';
import 'package:frontend/preview.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontend/sidebar.dart';
import 'package:printing/printing.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class Files {
  String filename;
  String filepath;

  Files({required this.filename, required this.filepath});
}

class _HomeState extends State<Home> {

  // TextEditingController pdfInputController = TextEditingController();
  // Uint8List? displayedPdfBytes;

  List<Files> files = [];

  Future<http.Response> uploadFile(String url, List<int> bytes) async {
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..files.add(
        http.MultipartFile.fromBytes(
          'fileField',
          Uint8List.fromList(bytes),
          filename: 'filename.pdf',
        ),
      );

    try {
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (error) {
      print('Error uploading file: $error');
      return http.Response('Error uploading file: $error', 500);
    }
  }

  Future<void> pickAndUploadFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      print('File path: ${file.path}');
      print('File size: ${file.size}');

      try {
        // Read the file content as bytes
        Uint8List fileBytes = await File(file.path!).readAsBytes();

        print('File bytes: $fileBytes');

        if (fileBytes.isNotEmpty) {
          setState(() {
            files.insert(0, Files(filename: file.name, filepath: file.path!));
          });

          if(files.length > 10){
            files.removeLast();
          }

          const backendUrl = 'https://2e1a-2401-4900-4e68-f807-8087-322d-d8c0-24d9.ngrok-free.app/upload';
          final response = await uploadFile(backendUrl, fileBytes);

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseBody = json.decode(response.body);

            if (responseBody.containsKey('cost')) {
              // Extract and set the amount
              final int cost = responseBody['cost'];
              print('response bode: ${responseBody}');
              print('Amount: ${cost}');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFPreviewScreen(
                    pdfPath: file.path!,
                    cost: cost,
                  ),
                ),
              );

            } else {
              print('Response body does not contain the "cost" field.');
            }
          } else {
            print('Failed to upload file. Status code: ${response.statusCode}');
          }
        } else {
          print('File bytes are empty');
        }
      } catch (e) {
        print('Error reading file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Zebra',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Sidebar()
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[100]!, Colors.blue[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    )
                  )
                ),
                onPressed: (){
                  pickAndUploadFile(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone_android,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Select from Device',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Recent Files',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1
                ),
              ),
              const Divider(
                height: 24,
                color: Colors.black,
              ),
              Flexible(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              files[index].filename,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(files[index].filepath)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}