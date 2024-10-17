// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Change Password',
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
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background2.png'),
                  fit: BoxFit.cover, // Ensures the image covers the whole page
                ),
              ),
            ),
            // Foreground content (the form)
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Display the change.jpg image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              75), // Make the border radius half the height for a circular shape
                          child: Image.asset(
                            'assets/change.jpg',
                            height: 150, // Adjust height as needed
                            width:
                                150, // Make sure the width and height are equal for a perfect circle
                            fit: BoxFit
                                .cover, // Ensures the image covers the circle properly
                          ),
                        ),
                        const SizedBox(height: 20),
                        // NIC Number input field
                        TextFormField(
                          controller: _nicController,
                          decoration: const InputDecoration(
                            labelText: 'NIC Number:',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your NIC number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // New Password input field
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'New Password:',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your new password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password input field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Passowrd:',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        // Error message
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        const SizedBox(height: 10),
                        // Confirm button
                        SizedBox(
                          width: 280,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null // Disable button when loading
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        // Perform password change logic based on NIC number
                                        _changePassword(_nicController.text,
                                            _newPasswordController.text);
                                      }
                                    },
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Confirm',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.green,
                                elevation: 10,
                                shadowColor: const Color.fromARGB(255, 6, 6, 6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(String nicNumber, String newPassword) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final url = 'http://116.12.80.92:9010/api/v3/getBynic/$nicNumber';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'password': newPassword,
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated the password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );

        // Navigate to the Login page and replace the current route
        Navigator.pushReplacementNamed(context, '/Login');
      } else {
        setState(() {
          _errorMessage =
              'Failed to change password. Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
