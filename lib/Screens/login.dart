// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:customer_portal/Screens/changepassword.dart';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:customer_portal/Screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  );

  static const _labelStyle = TextStyle(color: Colors.white);
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
                      "Login",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                        fontSize: 80.0,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter User Name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _idNumberController,
                            labelText: 'National ID Number:',
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9vV]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter National ID Number';
                              }
                              if (!RegExp(r'^\d{12}$').hasMatch(value) &&
                                  !RegExp(r'^\d{9}[vV]$').hasMatch(value)) {
                                return 'Enter a 12-digit number or a 9-digit number followed by V or v';
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
                                  await _requestUserConsent();
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
                                        const ChangePassword()),
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
                                    builder: (context) => const Registerpage()),
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

  Future<void> _requestUserConsent() async {
    bool consent = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Data Collection Consent"),
          content: const Text(
              "We collect your username and National ID to log you into the system. Your data is securely transmitted and not shared with any third parties without your consent. Do you agree?"),
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

    if (!consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You need to consent to data collection")),
      );
    } else {
      await _loginUser();
    }
  }

  Future<void> _loginUser() async {
    final String username = _userNameController.text;
    final String idNumber = _idNumberController.text;
    final String password = _passwordController.text;

    final Uri apiUrl =
        Uri.parse('http://124.43.209.68:9010/api/v3/getBynic/$idNumber');

    try {
      final response =
          await http.get(apiUrl).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          final List<dynamic> userDataList = decodedData;

          if (userDataList.isNotEmpty &&
              userDataList[0] is Map<String, dynamic>) {
            final Map<String, dynamic> userData = userDataList[0];

            if (userData['user_name'] == username &&
                userData['password'] == password) {
              GlobalData.setLoggedInUserName(username);
              GlobalData.setnICnumber(idNumber);
              Navigator.pushReplacementNamed(
                context,
                '/Ownervehicle',
                arguments: idNumber,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid username or password')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No user data found')),
            );
          }
        } else if (decodedData is Map<String, dynamic>) {
          final Map<String, dynamic> userData = decodedData;

          if (userData['user_name'] == username &&
              userData['password'] == password) {
            GlobalData.setLoggedInUserName(username);
            GlobalData.setnICnumber(idNumber);
            Navigator.pushReplacementNamed(
              context,
              '/Ownervehicle',
              arguments: idNumber,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid username or password')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error fetching user data: ${response.statusCode}')),
        );
      }
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred, please try again later')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred, please try again later')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration.copyWith(labelText: labelText),
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }
}
