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
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    launchUrl(phoneUri);
  }

  Future<void> _verifyOtpAndNavigate() async {
    if (_otpController.text.isEmpty) {
      _showErrorDialog('Please enter the OTP code.');
      return;
    }

    final String enteredOtp = _otpController.text;

    final Uri apiUrl = Uri.parse('http://124.43.209.68:8085/job/appLogin');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'otp': int.tryParse(enteredOtp) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final String apiOtp = responseData['jobNumber'] ?? '';

        if (enteredOtp == apiOtp) {
          GlobalData.setOTPNumber(_otpController.text);

          Navigator.pop(context);
          Navigator.pushNamed(context, '/onsite');
        } else {
          // OTP does not match
          Navigator.pop(context);
          _showErrorDialog('The entered OTP is incorrect. Please try again.');
        }
      } else {
        print('Error: API response status code ${response.statusCode}.');
        print('API Error Body: ${response.body}');
        Navigator.pop(context);
        _showErrorDialog('Failed to validate OTP. Please try again later.');
      }
    } catch (e) {
      print('Exception occurred: $e');
      Navigator.pop(context);
      _showErrorDialog('Network error. Please check your connection.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Something went wrong!'),
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Enter OTP Code',
                        labelStyle: TextStyle(
                          color: Colors.white, // Set label text color to white
                        ),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 20),
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
