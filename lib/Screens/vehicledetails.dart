// ignore_for_file: unused_field, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final _formKey = GlobalKey<FormState>();
  final vehicleNameController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerNICController = TextEditingController();
  final customerMobileNumberController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final vehicleModelController = TextEditingController();
  final vehicleYearController = TextEditingController();

  @override
  void dispose() {
    vehicleNameController.dispose();
    customerNameController.dispose();
    customerNICController.dispose();
    customerMobileNumberController.dispose();
    vehicleNumberController.dispose();
    vehicleModelController.dispose();
    vehicleYearController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicleDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final vehicleNumber = vehicleNumberController.text.trim();
      final Uri checkUri = Uri.parse(
          'http://124.43.209.68:9010/api/v2/getByVehiclenumber/$vehicleNumber');

      try {
        final checkResponse = await http.get(checkUri);

        if (checkResponse.statusCode == 200) {
          final decoded = jsonDecode(checkResponse.body);

          if (decoded != null && decoded.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('This vehicle is already registered.')),
            );
            return;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to check vehicle: ${checkResponse.statusCode}')),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error checking vehicle. Please try again.')),
        );
        return;
      }

      bool consent = await _requestUserConsent();

      if (!consent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You need to consent to proceed")),
        );
        return;
      }

      String riskName = "new " + vehicleNumberController.text;
      GlobalData.setRiskName(riskName);

      final Map<String, dynamic> inputData = {
        'vehicle_details': vehicleNameController.text,
        'customer_name': customerNameController.text,
        'customer_nic': customerNICController.text,
        'mobile_no': customerMobileNumberController.text,
        'vehicle_no': vehicleNumberController.text,
        'vehicle_model': vehicleModelController.text,
        'manufactured_year': vehicleYearController.text,
      };

      try {
        final Uri apiUrl =
            Uri.parse('http://124.43.209.68:9010/api/v2/saveuser');
        final response = await http.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(inputData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Vehicle details saved successfully!')),
          );
          Navigator.pushNamed(context, '/newphotosend');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Save vehicle details: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred, please try again later')),
        );
      }
    }
  }

  Future<bool> _requestUserConsent() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Data Collection Consent"),
          content: const Text(
              "We collect your vehicle and personal details to process your request. Your data is securely transmitted and not shared with third parties without your consent. Do you agree?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Enter New Vehicle details',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
                fontSize: screenWidth * 0.05,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 0, 68, 124),
          ),
          body: Stack(
            children: [
              Positioned(
                top: screenHeight * 0.2,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/mycar.png',
                    height: screenHeight * 0.35,
                    width: screenWidth,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField('Your Name',
                                  customerNameController, screenWidth),
                              _buildTextField('Your NIC', customerNICController,
                                  screenWidth,
                                  keyboardType: TextInputType.text,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9vV]')),
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  hintText: 'E.g. 536467829390 or 1367289407V',
                                  hintStyle: TextStyle(color: Colors.white54)),
                              _buildTextField('Your Mobile Number',
                                  customerMobileNumberController, screenWidth,
                                  keyboardType: TextInputType.phone,
                                  hintText: 'E.g. 0714563782',
                                  hintStyle: TextStyle(color: Colors.white54)),
                              _buildTextField('Vehicle Make',
                                  vehicleNameController, screenWidth,
                                  hintText: 'E.g. Toyota',
                                  hintStyle: TextStyle(color: Colors.white54)),
                              _buildTextField('Vehicle Number',
                                  vehicleNumberController, screenWidth,
                                  hintText: 'E.g. NW CBB-1226 or CBB 1226',
                                  hintStyle: TextStyle(color: Colors.white54)),
                              _buildTextField('Vehicle Model',
                                  vehicleModelController, screenWidth,
                                  hintText: 'E.g. Corolla',
                                  hintStyle: TextStyle(color: Colors.white54)),
                              _buildTextField('Vehicle Manufactured Year',
                                  vehicleYearController, screenWidth),
                              SizedBox(height: screenHeight * 0.03),

                              // Submit Button
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05,
                                    vertical: screenHeight * 0.01),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02,
                                        horizontal: screenWidth * 0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: Colors.green,
                                    elevation: 10,
                                  ),
                                  onPressed: _saveVehicleDetails,
                                  child: Text(
                                    'Proceed to Inspection',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.045,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, double screenWidth,
      {TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatter,
      String? hintText,
      TextStyle? hintStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText,
          hintStyle: hintStyle,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatter,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == 'Your NIC') {
            if (!RegExp(r'^\d{12}$').hasMatch(value) &&
                !RegExp(r'^\d{9}[vV]$').hasMatch(value)) {
              return 'Enter a valid NIC: 12-digit number or 9-digit number followed by V or v';
            }
          }
          if (label == 'Vehicle Number') {
            final patterns = [
              RegExp(r'^[A-Z]{2} [A-Z]{2} \d{4}$'), // NW CW 2345
              RegExp(r'^\d{2} \d{4}$'), // 23 2345
              RegExp(r'^[A-Z]{1,2} [A-Z]{2,3}-\d{4}$'), // NW CBB-1226
              RegExp(r'^[A-Z]{2,3} \d{4}$'), // CBB 1226
            ];

            final isValid = patterns.any((pattern) => pattern.hasMatch(value));
            if (!isValid) {
              return 'Invalid format. Use "NW CW 2345", "23 2345", "NW CBB-1226", or "CBB 1226"';
            }
          }

          if (label == 'Your Mobile Number') {
            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              return 'Please enter a valid mobile number (10 digits)';
            }
          }
          return null;
        },
        controller: controller,
      ),
    );
  }
}
