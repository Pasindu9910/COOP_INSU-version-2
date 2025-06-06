// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:customer_portal/Screens/changestaffpassword.dart';
import 'package:customer_portal/Screens/digitalinsuarance.dart';
import 'package:customer_portal/Screens/staffregistration.dart';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StaffLoginPage extends StatefulWidget {
  const StaffLoginPage({super.key});

  @override
  State<StaffLoginPage> createState() => _StaffLoginPageState();
}

class _StaffLoginPageState extends State<StaffLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );

  static const _labelStyle =
      TextStyle(color: Color.fromARGB(255, 255, 255, 255));
  static const _inputDecoration = InputDecoration(
    labelStyle: _labelStyle,
    border: _inputBorder,
    focusedBorder: _inputBorder,
    enabledBorder: _inputBorder,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                  minHeight: size.height * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Staff Login",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                        fontSize: 50.0,
                        fontFamily: 'Georgia',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _userNameController,
                            labelText: 'User Name:',
                            hintText: 'EPF/Code',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter User Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _passwordController,
                            labelText: 'Password:',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: 280,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.green,
                                elevation: 10,
                                shadowColor: const Color.fromARGB(255, 6, 6, 6),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await _loginUser();
                                }
                              },
                              child: const Text(
                                'Login Now',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontFamily: 'Georgia',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeStaffPasswordPage()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color.fromARGB(255, 226, 232, 38),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Forgot password? ',
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'click here',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(255, 226,
                                          232, 38), // yellow underline
                                      decorationThickness: 1.5,
                                      color: Color.fromARGB(255, 226, 232, 38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StaffRegisterPage()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Color.fromARGB(255, 226, 232, 38),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Not Registered Yet? ',
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Register From here',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(255, 226,
                                          232, 38), // yellow underline
                                      decorationThickness: 1.5,
                                      color: Color.fromARGB(255, 226, 232, 38),
                                    ),
                                  ),
                                ],
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: _inputDecoration.copyWith(
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      ),
    );
  }

  Future<void> _loginUser() async {
    String username = _userNameController.text.trim();
    String password = _passwordController.text.trim();

    bool isActive = await _checkUserStatus(username);
    if (!isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not an active user')),
      );
      return;
    }

    final response = await http.get(
        Uri.parse('http://124.43.209.68:9010/api3/v1/getBySfCode/$username'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        var user = data[0];
        if (user['password'] == password) {
          GlobalData.setLogUser(username);
          _logRiskData(username);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Digitalinsuarance()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching user data')),
      );
    }
  }
}

Future<void> _logRiskData(String nicSfc) async {
  const url = 'http://124.43.209.68:9010/risklogdata/v1/savelogdata';
  final body = jsonEncode({'nic_sfc': nicSfc});

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      print('Risk log failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Risk log error: $e');
  }
}

Future<bool> _checkUserStatus(String username) async {
  final url =
      Uri.parse('http://124.43.209.68:9000/api2/v1/getSfcStatus/$username');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty && data[0]['sfc_active'] == "Y") {
        return true;
      }
    }
  } catch (e) {
    print("Error checking user status: $e");
  }
  return false;
}
