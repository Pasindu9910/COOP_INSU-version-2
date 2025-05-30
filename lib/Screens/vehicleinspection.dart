// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VehicleInspec extends StatefulWidget {
  const VehicleInspec({super.key});

  @override
  State<VehicleInspec> createState() => _VehicleInspecState();
}

class _VehicleInspecState extends State<VehicleInspec> {
  String? riskName = GlobalData.getRiskName();
  static const double buttonWidth = 150;
  static const double buttonHeight = 100;
  static const double fontSize = 14;
  static const double spacing = 30;

  final ImagePicker _picker = ImagePicker();
  final Map<String, File?> _capturedPhotos = {};
  final Map<String, Color> _buttonColors = {};
  final List<String> _allButtonLabels = [
    'Front Photo',
    'Left side\nPhoto',
    'Front NIC Photo',
    'License Photo',
    'Deletion Letter',
    'Meter Reader',
    'Left Front\nCorner',
    'Left Back\nCorner',
    'Back Photo',
    'Right side\nPhoto',
    'Back NIC Photo',
    'Vehicle Book\nPhoto',
    'Chassi Number',
    'Right Front\nCorner',
    'Right Back\nCorner',
    'Wind Screen\nLabel',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var label in _allButtonLabels) {
      _buttonColors[label] = Colors.white;
      _capturedPhotos[label] = null;
    }
  }

  bool get allImagesCaptured =>
      _capturedPhotos.values.every((file) => file != null) &&
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
              'Vehicle Inspection',
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
                        'Register Your Vehicle',
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
                              'Front Photo',
                              'Left side\nPhoto',
                              'Front NIC Photo',
                              'License Photo',
                              'Deletion Letter',
                              'Meter Reader',
                              'Left Front\nCorner',
                              'Left Back\nCorner',
                            ],
                            [
                              () => _openCamera('Front Photo'),
                              () => _openCamera('Left side\nPhoto'),
                              () => _openCamera('Front NIC Photo'),
                              () => _openCamera('License Photo'),
                              () => _openCamera('Deletion Letter'),
                              () => _openCamera('Meter Reader'),
                              () => _openCamera('Left Front\nCorner'),
                              () => _openCamera('Left Back\nCorner'),
                            ],
                          ),
                          _buildColumnWithButtons(
                            [
                              'Back Photo',
                              'Right side\nPhoto',
                              'Back NIC Photo',
                              'Vehicle Book\nPhoto',
                              'Chassi Number',
                              'Right Front\nCorner',
                              'Right Back\nCorner',
                              'Wind Screen\nLabel',
                            ],
                            [
                              () => _openCamera('Back Photo'),
                              () => _openCamera('Right side\nPhoto'),
                              () => _openCamera('Back NIC Photo'),
                              () => _openCamera('Vehicle Book\nPhoto'),
                              () => _openCamera('Chassi Number'),
                              () => _openCamera('Right Front\nCorner'),
                              () => _openCamera('Right Back\nCorner'),
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
                      'Submit',
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
      'Front Photo': 'assets/Front Photo.png',
      'Left side\nPhoto': 'assets/left.png',
      'Front NIC Photo': 'assets/ID.png',
      'License Photo': 'assets/lis.png',
      'Back Photo': 'assets/back.png',
      'Right side\nPhoto': 'assets/right.png',
      'Back NIC Photo': 'assets/IDback.png',
      'Vehicle Book\nPhoto': 'assets/book.png',
      'Deletion Letter': 'assets/letter.png',
      'Chassi Number': 'assets/chassi.png',
      'Meter Reader': 'assets/meter.png',
      'Wind Screen\nLabel': 'assets/wind.png',
      'Left Back\nCorner': 'assets/back_Left.png',
      'Right Back\nCorner': 'assets/back_Right.png',
      'Right Front\nCorner': 'assets/front_Right.png',
      'Left Front\nCorner': 'assets/front_Left.png',
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
    if (_capturedPhotos[buttonText] != null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image Preview'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  _capturedPhotos[buttonText]!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text('Do you want to retake this photo?'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Use this photo'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Retake'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _captureNewImage(buttonText);
                },
              ),
            ],
          );
        },
      );
    } else {
      await _captureNewImage(buttonText);
    }
  }

  Future<void> _captureNewImage(String buttonText) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() {
          _buttonColors[buttonText] = Colors.green;
          _capturedPhotos[buttonText] = imageFile;
        });
      }
    } finally {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("Images sent successfully!"),
          actions: [
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

    // Show progress dialog
    _showProgressPopup(context);

    setState(() {
      _isLoading = true;
    });

    List<String> failedUploads = [];

    try {
      for (var entry in _capturedPhotos.entries) {
        final buttonName = entry.key;
        final file = entry.value;

        if (file != null) {
          print('Sending image for button: $buttonName');

          String modifiedFileName =
              '${buttonName.replaceAll("\n", "_")}_$riskName';

          final request = http.MultipartRequest(
            'POST',
            Uri.parse('http://124.43.209.68:9000/api/v1/uploadonsiteinf'),
          );

          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              file.path,
              filename: modifiedFileName,
            ),
          );

          request.fields['buttonName'] = buttonName;
          request.fields['riskid'] = riskName ?? '';

          final response = await request.send();

          if (response.statusCode == 200) {
          } else {
            failedUploads.add(buttonName);
          }
        }
      }

      Navigator.of(context).pop();

      if (failedUploads.isEmpty) {
        _showSuccessDialog();
        GlobalData.setRiskName('');
        _showRatingPopup(context);
        _resetState();
      } else {
        _showErrorDialog('Failed to send images: ${failedUploads.join(", ")}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('An error occurred while sending images.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetState() {
    setState(() {
      for (var label in _allButtonLabels) {
        _buttonColors[label] = Colors.white;
        _capturedPhotos[label] = null;
      }
    });
  }
}

void _showRatingPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int selectedRating = 0;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Rate Us"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "How would you rate your experience?",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: selectedRating > index
                            ? Colors.yellow
                            : Colors.grey,
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedRating > 0) {
                    await _sendRating(context, selectedRating);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select a rating."),
                      ),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _sendRating(BuildContext context, int rating) async {
  final String? nicNumber = GlobalData.getnICnumber();
  final String apiUrl = 'http://124.43.209.68:9010/api/v7/Saveallrates';

  if (nicNumber == null || nicNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("NIC number is missing. Cannot submit rating.")),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nic": nicNumber,
        "rate_value": rating,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for your feedback!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit rating. Please try again.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $e")),
    );
  }
}

void _showProgressPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Uploading images...'),
            ],
          ),
        ),
      );
    },
  );
}
