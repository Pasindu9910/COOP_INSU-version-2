// ignore_for_file: use_build_context_synchronously, prefer_const_declarations

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
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Use FutureBuilder to handle the image loading asynchronously
                        const SizedBox(height: 250),
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
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password:',
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
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 280,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _checkCustomerAndChangePassword(
                                          _nicController.text,
                                          _newPasswordController.text);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.green,
                              elevation: 10,
                              shadowColor: const Color.fromARGB(255, 6, 6, 6),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontFamily: 'Georgia',
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

  Future<void> _checkCustomerAndChangePassword(
      String nicNumber, String newPassword) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final customerCheckUrl =
        'http://124.43.209.68:9010/api/v3/getBynic/$nicNumber';
    final passwordResetUrl = 'http://124.43.209.68:9010/api/v3/updatecustomer';
    final headers = {'Content-Type': 'application/json'};

    try {
      final customerResponse = await http.get(Uri.parse(customerCheckUrl));

      if (customerResponse.statusCode == 200) {
        final customerData = jsonDecode(customerResponse.body);

        if (customerData is List && customerData.isNotEmpty) {
          final customer = customerData[0];

          if (customer != null && customer['id'] != null) {
            final updatedCustomer = {
              "id": customer["id"],
              "title": customer["title"],
              "user_name": customer["user_name"],
              "first_name": customer["first_name"],
              "last_name": customer["last_name"],
              "nic": customer["nic"],
              "mobile_no": customer["mobile_no"],
              "email": customer["email"],
              "password": newPassword
            };

            final passwordResponse = await http.put(
              Uri.parse(passwordResetUrl),
              headers: headers,
              body: jsonEncode(updatedCustomer),
            );

            if (passwordResponse.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!')),
              );
              Navigator.pushReplacementNamed(context, '/Login');
            } else {
              setState(() {
                _errorMessage = 'Failed to change password.';
              });
            }
          } else {
            setState(() {
              _errorMessage = 'Invalid customer data received';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No customer found for the given NIC';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Customer not found.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
