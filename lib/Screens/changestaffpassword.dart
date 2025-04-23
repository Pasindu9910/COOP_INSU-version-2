// ignore_for_file: use_build_context_synchronously, prefer_const_declarations

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeStaffPasswordPage extends StatefulWidget {
  const ChangeStaffPasswordPage({super.key});

  @override
  State<ChangeStaffPasswordPage> createState() =>
      _ChangeStaffPasswordPageState();
}

class _ChangeStaffPasswordPageState extends State<ChangeStaffPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sfCodeController = TextEditingController();
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
            'Change Staff Password',
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
                        const SizedBox(height: 250),
                        TextFormField(
                          controller: _sfCodeController,
                          decoration: const InputDecoration(
                            labelText: 'SF Code:',
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
                              return 'Please enter your SF code';
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
                                      _checkStaffAndChangePassword(
                                          _sfCodeController.text,
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

  Future<void> _checkStaffAndChangePassword(
      String sfCode, String newPassword) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final getUrl = 'http://124.43.209.68:9010/api3/v1/getBySfCode/$sfCode';
    final updateUrl = 'http://124.43.209.68:9010/api3/v1/updatecustomer';
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(Uri.parse(getUrl));

      if (response.statusCode == 200) {
        final staffList = jsonDecode(response.body);

        if (staffList is List && staffList.isNotEmpty) {
          final staff = staffList[0];

          final updatedData = {
            "id": staff["id"],
            "sfc_code": staff["sfc_code"],
            "password": newPassword,
            "created_by": staff["created_by"],
            "created_date": staff["created_date"],
            "modified_by": staff["modified_by"],
            "modifieddate": staff["modifieddate"],
          };

          final updateResponse = await http.put(
            Uri.parse(updateUrl),
            headers: headers,
            body: jsonEncode(updatedData),
          );

          if (updateResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Staff password changed successfully!')),
            );
            Navigator.pushReplacementNamed(context, '/Login');
          } else {
            setState(() {
              _errorMessage = 'Failed to update password.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No staff found for the given SF code.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error fetching staff data.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
