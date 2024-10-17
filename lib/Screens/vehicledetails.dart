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
          Navigator.pushNamed(context, '/Inspection');
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
            if (!RegExp(r'^[A-Z]{1,2}\s?[A-Z]{2,3}\s?-?\s?\d{4}$')
                .hasMatch(value)) {
              return 'Please enter a valid vehicle number (e.g., NW CBB-1226 or CBB 1226)';
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
