import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth,
              ),
              Container(
                height: screenHeight * 0.55,
                width: screenWidth * 0.80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF90caf9),
                    width: 1.5,
                  ),
                ),
                child: _image == null
                    ? Center(
                        child: Text(
                          'No image selected or taken',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            fontFamily: 'Inter',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : Image.file(_image!),
              ),
              SizedBox(
                height: screenHeight * 0.02,
                width: screenWidth * 0.6,
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _image = File(image.path);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.6,
                      36), // 36 is the default height of ElevatedButton
                ),
                child: Text('Select Image',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontFamily: 'Inter',
                    )),
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() {
                      _image = File(image.path);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.6,
                      36), // 36 is the default height of ElevatedButton
                ),
                child: Text(
                  'Take Picture',
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Center(
                  child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Press the buttons above to select an image or take a picture',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontFamily: 'Inter',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )),
              SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '© 2024 | Laurente',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              )
            ],
          )),
        ));
  }
}
