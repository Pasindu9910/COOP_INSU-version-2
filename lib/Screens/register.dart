// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final username = TextEditingController();
  final nationalID = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    firstname.dispose();
    lastname.dispose();
    username.dispose();
    nationalID.dispose();
    mobile.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Column(
                        children: [
                          Text(
                            "Register",
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
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 500,
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Title',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  value: _title,
                                  onChanged: (value) =>
                                      setState(() => _title = value),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a title';
                                    }
                                    return null;
                                  },
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'Mr.',
                                      child: Text('Mr.'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Mrs.',
                                      child: Text('Mrs.'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'First Name:',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter First Name';
                                    }
                                    return null;
                                  },
                                  controller: firstname,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name:',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Last Name';
                                    }
                                    return null;
                                  },
                                  controller: lastname,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'User Name:',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText: 'E.g. JohnDoe',
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter User Name';
                                    }
                                    if (value.length < 4) {
                                      return 'User name must be at least 4 characters long';
                                    }
                                    if (!RegExp(r'^[A-Z]').hasMatch(value)) {
                                      return 'First letter must be capital';
                                    }
                                    return null;
                                  },
                                  controller: username,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'National ID Number:',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText:
                                        'E.g. 536467829390 or 1367289407V',
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9vV]'))
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter National ID Number';
                                    }
                                    if (!RegExp(r'^\d{12}$').hasMatch(value) &&
                                        !RegExp(r'^\d{9}[vV]$')
                                            .hasMatch(value)) {
                                      return 'Enter a 12-digit number or a 9-digit number followed by V or v';
                                    }
                                    return null;
                                  },
                                  controller: nationalID,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile Number:',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    hintText: 'E.g. 0715647832',
                                    hintStyle: TextStyle(color: Colors.white54),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Mobile Number';
                                    }
                                    if (value.length != 10) {
                                      return 'Mobile number must be exactly 10 digits';
                                    }
                                    return null;
                                  },
                                  controller: mobile,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'E-Mail:',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter E-Mail';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  controller: email,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password:',
                                    labelStyle: TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    return null;
                                  },
                                  controller: password,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 500,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: Colors.green,
                                    elevation: 20,
                                    shadowColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final nic = nationalID.text;
                                      final Uri checkNicUrl = Uri.parse(
                                          'http://124.43.209.68:9010/api/v3/getBynic/$nic');

                                      try {
                                        final checkResponse =
                                            await http.get(checkNicUrl);

                                        if (checkResponse.statusCode == 200) {
                                          final responseData =
                                              jsonDecode(checkResponse.body);

                                          if (responseData != null &&
                                              responseData['data'] != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'A user with this NIC already exists.'),
                                              ),
                                            );
                                          } else {
                                            final Map<String, dynamic>
                                                inputData = {
                                              'title': _title,
                                              'first_name': firstname.text,
                                              'last_name': lastname.text,
                                              'user_name': username.text,
                                              'nic': nationalID.text,
                                              'mobile_no': mobile.text,
                                              'email': email.text,
                                              'password': password.text,
                                            };

                                            final Uri apiUrl = Uri.parse(
                                                'http://124.43.209.68:9010/api/v3/saveOldCustomer');
                                            final response = await http.post(
                                              apiUrl,
                                              headers: {
                                                'Content-Type':
                                                    'application/json'
                                              },
                                              body: jsonEncode(inputData),
                                            );

                                            if (response.statusCode == 200) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/Login');
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Registration successful!')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Registration failed: ${response.statusCode}')),
                                              );
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Error checking NIC. Please try again.')),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'An error occurred, please try again later')),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Register Me',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontFamily: 'Georgia',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
