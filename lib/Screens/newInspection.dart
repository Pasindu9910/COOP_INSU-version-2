// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'dart:io';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class newvehicleInspec extends StatefulWidget {
  final String policyNumber;
  final String branchNumber;
  final String vehicleNumber;
  final String policyType;

  const newvehicleInspec({
    super.key,
    required this.policyNumber,
    required this.branchNumber,
    required this.vehicleNumber,
    required this.policyType,
  });
  @override
  State<newvehicleInspec> createState() => _newvehicleInspecState();
}

class _newvehicleInspecState extends State<newvehicleInspec> {
  static const double buttonWidth = 150;
  static const double buttonHeight = 100;
  static const double fontSize = 14;
  static const double spacing = 30;

  final ImagePicker _picker = ImagePicker();
  final Map<String, List<File>> _capturedPhotos = {};
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
    'Proposal Form Front',
    'Proposal From Back',
    'Valuation Report Front',
    'Valuation Report Back',
    'Inspection Report Front',
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    for (var label in _allButtonLabels) {
      _buttonColors[label] = Colors.white;
      _capturedPhotos[label] = [];
    }
  }

  bool get allImagesCaptured =>
      _buttonColors.values.every((color) => color != Colors.red);

  bool get isAtLeastOnePhotoTaken =>
      _capturedPhotos.values.any((photos) => photos.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Vehicle Inspection',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 0, 68, 124),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text(
                        'Register Your Vehicle',
                        style: TextStyle(
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            )
                          ],
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Georgia',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildColumnWithButtons(
                            [
                              'Front Photo',
                              'Left side\nPhoto',
                              'Left Front\nCorner',
                              'Left Back\nCorner',
                              'Meter Reader',
                              'Front NIC Photo',
                              'License Photo',
                              'Deletion Letter',
                              'Proposal Form Front',
                              'Valuation Report Front',
                              'Inspection Report Front',
                            ],
                            [
                              () => _openCamera('Front Photo'),
                              () => _openCamera('Left side\nPhoto'),
                              () => _openCamera('Left Front\nCorner'),
                              () => _openCamera('Left Back\nCorner'),
                              () => _openCamera('Meter Reader'),
                              () => _openCamera('Front NIC Photo'),
                              () => _openCamera('License Photo'),
                              () => _openCamera('Deletion Letter'),
                              () => _openCamera('Proposal Form Front'),
                              () => _openCamera('Valuation Report Front'),
                              () => _openCamera('Inspection Report Front'),
                            ],
                          ),
                          _buildColumnWithButtons(
                            [
                              'Back Photo',
                              'Right side\nPhoto',
                              'Right Front\nCorner',
                              'Right Back\nCorner',
                              'Chassi Number',
                              'Wind Screen\nLabel',
                              'Back NIC Photo',
                              'Vehicle Book\nPhoto',
                              'Proposal Form Back',
                              'Valuation Report Back',
                              'Inspection Report Back'
                            ],
                            [
                              () => _openCamera('Back Photo'),
                              () => _openCamera('Right side\nPhoto'),
                              () => _openCamera('Right Front\nCorner'),
                              () => _openCamera('Right Back\nCorner'),
                              () => _openCamera('Chassi Number'),
                              () => _openCamera('Wind Screen\nLabel'),
                              () => _openCamera('Back NIC Photo'),
                              () => _openCamera('Vehicle Book\nPhoto'),
                              () => _openCamera('Proposal Form Back'),
                              () => _openCamera('Valuation Report Back'),
                              () => _openCamera('Inspection Report Back'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: isAtLeastOnePhotoTaken ? _sendImages : null,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      backgroundColor:
                          isAtLeastOnePhotoTaken ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
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
                const Center(
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
        buttonsWithSpacing.add(const SizedBox(height: spacing));
      }
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: buttonsWithSpacing);
  }

  ElevatedButton _buildElevatedButton(String text, VoidCallback onPressed) {
    final Map<String, String> buttonImages = {
      'Front Photo': 'assets/Front Photo.png',
      'Left side\nPhoto': 'assets/Left Side Photo.png',
      'Front NIC Photo': 'assets/Front NIC.png',
      'License Photo': 'assets/License.png',
      'Back Photo': 'assets/Back Photo.png',
      'Right side\nPhoto': 'assets/Right Side Photo.png',
      'Back NIC Photo': 'assets/Back NIC.png',
      'Vehicle Book\nPhoto': 'assets/Vehicle Book.png',
      'Deletion Letter': 'assets/Deletion Letter.png',
      'Chassi Number': 'assets/chassi1.png',
      'Meter Reader': 'assets/Meter Reader.png',
      'Wind Screen\nLabel': 'assets/Wind Screen.png',
      'Left Back\nCorner': 'assets/Left Back.png',
      'Right Back\nCorner': 'assets/Right Back.png',
      'Right Front\nCorner': 'assets/Right Front.png',
      'Left Front\nCorner': 'assets/Left Front.png',
      'Proposal Form Front': 'assets/Formback.png',
      'Proposal Form Back': 'assets/Formfront.png',
      'Valuation Report Front': 'assets/Valuationreport.png',
      'Valuation Report Back': 'assets/Valuationreport.png',
      'Inspection Report Front': 'assets/Inspectionreport.png',
      'Inspection Report Back': 'assets/Inspectionreport.png',
    };

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(buttonWidth, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 3, color: Colors.black),
        ),
        backgroundColor: _buttonColors[text] ?? Colors.white,
        elevation: 10,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonImages.containsKey(text))
            Image.asset(
              buttonImages[text]!,
              height: 40,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 3),
          Text(
            text,
            style: const TextStyle(
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
    await _captureNewImage(buttonText);

    if (_capturedPhotos[buttonText]!.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Image Preview'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _capturedPhotos[buttonText]!.map((file) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.file(
                        file,
                        fit: BoxFit.contain,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Capture Another'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _openCamera(buttonText);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _captureNewImage(String buttonText) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() {
          _buttonColors[buttonText] = Colors.green;
          _capturedPhotos[buttonText]!.add(imageFile);
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
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
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
          title: const Text("Success"),
          content: const Text("Images sent successfully!"),
          actions: [
            TextButton(
              child: const Text("OK"),
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
    String? sfccode = GlobalData.getLogUser();
    _showProgressPopup(context);

    setState(() {
      _isLoading = true;
    });

    List<String> failedUploads = [];

    try {
      for (var entry in _capturedPhotos.entries) {
        final buttonName = entry.key;
        final images = entry.value;

        for (var file in images) {
          String timestamp =
              DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
          String modifiedFileName =
              '${buttonName.replaceAll("\n", "_")}_$timestamp.jpg';

          final request = http.MultipartRequest(
            'POST',
            Uri.parse('http://124.43.209.68:9000/api/v1/uploadunderwritting'),
          );

          request.files.add(
            await http.MultipartFile.fromPath(
              'files',
              file.path,
              filename: modifiedFileName,
            ),
          );

          request.fields['branchcode'] = widget.branchNumber;
          request.fields['riskid'] = widget.vehicleNumber;
          request.fields['jobtype'] = widget.policyType;
          request.fields['sfccode'] = sfccode ?? '';
          request.fields['polorprono'] = widget.policyNumber;

          final response = await request.send();

          if (response.statusCode != 200) {
            failedUploads.add(buttonName);
          }
        }
      }

      Navigator.of(context).pop();

      if (failedUploads.isEmpty) {
        _showSuccessDialog();
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
}
