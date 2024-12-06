// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class OnsiteInspection extends StatefulWidget {
  const OnsiteInspection({super.key});

  @override
  State<OnsiteInspection> createState() => _OnsiteInspectionState();
}

class _OnsiteInspectionState extends State<OnsiteInspection> {
  String? riskName = GlobalData.getRiskName();

  String? oTPnumber = GlobalData.getOTPNumber();
  static const double buttonWidth = 150;
  static const double buttonHeight = 100;
  static const double fontSize = 14;
  static const double spacing = 30;

  final ImagePicker _picker = ImagePicker();
  final Map<String, List<File>> _capturedPhotos = {};
  final Map<String, Color> _buttonColors = {};
  final List<String> _allButtonLabels = [
    'Accident Photos',
    'Front NIC Photo',
    'License Photo Front',
    'License Photo Back',
    'Meter Reader',
    'Back NIC Photo',
    'Chassi Number',
    'Wind Screen\nLabel',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var label in _allButtonLabels) {
      _buttonColors[label] = Colors.white;
      _capturedPhotos[label] = []; // Initialize with empty lists
    }
  }

  bool get allImagesCaptured =>
      _capturedPhotos.values.every((files) => files.isNotEmpty) &&
      _buttonColors.values.every((color) => color != Colors.red);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Onsite Vehicle Inspection',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),
            backgroundColor: Color.fromARGB(255, 0, 68, 124),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        'Inspect Your Vehicle',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColumnWithButtons(
                            [
                              'Accident Photos',
                              'Front NIC Photo',
                              'License Photo Front',
                              'Meter Reader',
                            ],
                            [
                              () => _openCamera('Accident Photos'),
                              () => _openCamera('Front NIC Photo'),
                              () => _openCamera('License Photo Front'),
                              () => _openCamera('Meter Reader'),
                            ],
                          ),
                          _buildColumnWithButtons(
                            [
                              'Chassi Number',
                              'Back NIC Photo',
                              'License Photo Back',
                              'Wind Screen\nLabel',
                            ],
                            [
                              () => _openCamera('Chassi Number'),
                              () => _openCamera('Back NIC Photo'),
                              () => _openCamera('License Photo Back'),
                              () => _openCamera('Wind Screen\nLabel'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: allImagesCaptured ? _sendImages : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor:
                          allImagesCaptured ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildColumnWithButtons(
      List<String> buttonTexts, List<VoidCallback> onPressedFunctions) {
    List<Widget> buttonsWithSpacing = [];
    for (int i = 0; i < buttonTexts.length; i++) {
      buttonsWithSpacing.add(
        _buildElevatedButton(buttonTexts[i], onPressedFunctions[i]),
      );
      if (i < buttonTexts.length - 1) {
        buttonsWithSpacing.add(SizedBox(height: spacing));
      }
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: buttonsWithSpacing);
  }

  ElevatedButton _buildElevatedButton(String text, VoidCallback onPressed) {
    final Map<String, String> buttonImages = {
      'Accident Photos': 'assets/front1.png',
      'Front NIC Photo': 'assets/ID.png',
      'License Photo Front': 'assets/lis.png',
      'License Photo Back': 'assets/lis.png',
      'Back NIC Photo': 'assets/IDback.png',
      'Chassi Number': 'assets/chassi.png',
      'Meter Reader': 'assets/meter.png',
      'Wind Screen\nLabel': 'assets/wind.png',
    };

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(buttonWidth, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 3, color: Colors.black),
        ),
        backgroundColor: _buttonColors[text] ?? Colors.white,
        elevation: 10,
        shadowColor: Color.fromARGB(255, 0, 0, 0),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonImages.containsKey(text))
            Image.asset(
              buttonImages[text]!,
              height: 50,
              fit: BoxFit.cover,
            ),
          SizedBox(height: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera(String buttonText) async {
    if (buttonText == 'Accident Photos') {
      // Allow multiple images for 'Accident Photos'
      bool keepAdding = true;

      while (keepAdding) {
        await _captureNewImage(buttonText);

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Image Preview'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          children: _capturedPhotos[buttonText]!.map((file) {
                            return Image.file(
                              file,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Do you want to add more photos?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Add More'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    keepAdding = true;
                  },
                ),
                TextButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    keepAdding = false;

                    setState(() {
                      _buttonColors[buttonText] = Colors.green;
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      await _captureNewImage(buttonText);

      setState(() {
        _buttonColors[buttonText] = Colors.green;
      });
    }
  }

  Future<void> _captureNewImage(String buttonText) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        setState(() {
          _capturedPhotos[buttonText]!.add(imageFile);
        });
      }
    } finally {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendImages() async {
    String? riskName = GlobalData.getRiskName();
    String? jobId = GlobalData.getOTPNumber();

    if (riskName == null || jobId == null) {
      _showErrorDialog('Risk Name or Job ID is missing.');
      return;
    }

    // Show progress dialog
    _showProgressPopup(context);

    setState(() {
      _isLoading = true;
    });

    bool isUploaded = false;

    try {
      await _uploadAllImages(riskName, jobId).then((_) {
        isUploaded = true;
      });

      Navigator.of(context).pop();

      if (isUploaded) {
        _showSuccessDialog();
        GlobalData.setRiskName('');
        GlobalData.setOTPNumber('');
        _resetState();
      } else {
        _showErrorDialog('Failed to send images.');
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('Images failed to send.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadAllImages(String riskName, String jobId) async {
    for (var entry in _capturedPhotos.entries) {
      final files = entry.value;

      for (var file in files) {
        final url = Uri.parse('http://124.43.209.68:9000/api/v1/uploadaccident')
            .replace(queryParameters: {
          'riskid': riskName,
          'jobId': jobId,
        });

        final request = http.MultipartRequest('POST', url);
        request.files
            .add(await http.MultipartFile.fromPath('files', file.path));

        final response = await request.send();

        if (response.statusCode != 200) {
          throw Exception('Failed to send images.');
        }
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("All images have been successfully uploaded."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetState() {
    setState(() {
      for (var label in _allButtonLabels) {
        _buttonColors[label] = Colors.white;
        _capturedPhotos[label] = [];
      }
    });
  }

  void _showProgressPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Sending...'),
              ],
            ),
          ),
        );
      },
    );
  }
}
