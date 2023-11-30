import 'dart:io';
import 'dart:typed_data'; // Import the 'dart:typed_data' library
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> uploadFile(String url, List<int> bytes) async {
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
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        // Handle the response from the backend if needed
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading file: $error');
    }
  }

  void pickAndUploadFile() async {
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
          final backendUrl = 'https://2687-2401-4900-26ad-d62d-416-6df2-f0cb-eb04.ngrok-free.app/upload';
          uploadFile(backendUrl, fileBytes);
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
          child: MaterialButton(
            onPressed: () {
              pickAndUploadFile();
            },
            child: Text(
              'Pick and send file to backend',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
