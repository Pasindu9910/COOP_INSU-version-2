// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccidentReport extends StatefulWidget {
  const AccidentReport({super.key});

  @override
  State<AccidentReport> createState() => _AccidentReportState();
}

class _AccidentReportState extends State<AccidentReport>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0.95, end: 1.05).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  String? _validateVehicleNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter the vehicle number';
    }
    if (!RegExp(r'^[A-Z]{1,2}\s?[A-Z]{2,3}\s?-?\s?\d{4}$').hasMatch(value)) {
      return 'Please enter a valid vehicle number (e.g., NW CBB-1226 or CBB 1226)';
    }
    return null;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    launchUrl(phoneUri);
  }

  Future<void> _verifyOtpAndNavigate() async {
    // Validate the entered vehicle number
    String? vehicleError =
        _validateVehicleNumber(_vehicleNumberController.text);

    if (_otpController.text.isEmpty) {
      _showErrorDialog('Please enter the OTP code.');
      return;
    }

    if (vehicleError != null) {
      _showErrorDialog(vehicleError);
      return;
    }

    // Fetch and normalize the stored risk name from GlobalData
    final String? storedRiskName =
        GlobalData.getRiskName()?.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Normalize the entered vehicle number
    final String enteredVehicleNumber =
        _vehicleNumberController.text.replaceAll(RegExp(r'\s+'), ' ').trim();

    if (storedRiskName == null || storedRiskName != enteredVehicleNumber) {
      _showErrorDialog(
          'The entered vehicle number does not match the selected vehicle. Please try again.');
      return;
    }

    final String otpnumber = _otpController.text;
    final String jobName = Uri.encodeComponent('Onsite Inspection');

    // Construct the URL dynamically with parameters
    final Uri apiUrl = Uri.parse(
        'http://124.43.209.68:9000/api/v1/getJobDetails/$jobName/$otpnumber');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final response = await http.get(apiUrl, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          GlobalData.setVehicleNumber(_vehicleNumberController.text);
          GlobalData.setOTPNumber(_otpController.text);

          Navigator.pop(context);
          Navigator.pushNamed(context, '/onsite');
        } else {
          Navigator.pop(context);
          _showErrorDialog('Invalid OTP. Please try again.');
        }
      } else {
        print('Error: API response status code ${response.statusCode}.');
        Navigator.pop(context);
        _showErrorDialog('Failed to validate OTP. Please try again later.');
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog('Network error. Please check your connection.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Missing Informations'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Accident Report',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 0, 68, 124),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                      child: Text(
                        'Click to get connected with call center',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _animation,
                          child: InkWell(
                            onTap: () => _makePhoneCall('0117440033'),
                            child: Image.asset(
                              'assets/callus.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        const Text(
                          '0117440033',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _animation,
                          child: InkWell(
                            onTap: () => _makePhoneCall('0112440033'),
                            child: Image.asset(
                              'assets/callus.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          '0112440033',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP Code',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        labelText: 'Enter Vehicle Number',
                        hintText: 'E.g. NW CBB-1226 or CBB 1226',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.green,
                          elevation: 10,
                          shadowColor: Colors.grey,
                        ),
                        onPressed: _verifyOtpAndNavigate,
                        child: const Text(
                          'Onsite Inspections',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
