import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'payment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          // Continue with the upload
          final backendUrl = 'https://a1f0-2409-4071-209b-ec4b-c1cc-8782-181f-8a65.ngrok-free.app/upload';
          final response = await uploadFile(backendUrl, fileBytes);

          if (response.statusCode == 200) {
            // Parse the response body to extract the amount
            final Map<String, dynamic> responseBody = json.decode(response.body);

            if (responseBody.containsKey('cost')) {
              // Extract and set the amount
              final int cost = responseBody['cost'];
              print('Amount: ${cost}');
              // Navigate to the payment page with the amount, title, and file

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green[100],
        body: Center(
          child: Builder(
            builder: (context) => MaterialButton(
              onPressed: () {
                pickAndUploadFile(context);
              },
              child: Text(
                'Pick and send file to backend',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
