// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Vehicle {
  final String id;
  final String name;

  Vehicle({required this.id, required this.name});
}

class Ownervehicle extends StatefulWidget {
  final String nicNumber;

  const Ownervehicle({super.key, required this.nicNumber});

  @override
  State<Ownervehicle> createState() => _OwnervehicleState();
}

class _OwnervehicleState extends State<Ownervehicle> {
  String? _selectedVehicleId;
  bool _isCarVisible = false;
  bool _isVehiclesLoaded = false;
  List<Vehicle> _vehicleList = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isCarVisible = true;
      });
    });

    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    try {
      final Uri apiUrl = Uri.parse(
          'http://124.43.209.68:9000/api/v1/getuserbyid/${widget.nicNumber}');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        final List<Vehicle> vehicles =
            jsonResponse.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return Vehicle(
            id: '$index',
            name: (item['riskname']?.toString().trim() ?? 'Unknown'),
          );
        }).toList();

        setState(() {
          _vehicleList = vehicles;
          _isVehiclesLoaded = true;

          if (!_vehicleList
              .any((vehicle) => vehicle.id == _selectedVehicleId)) {
            _selectedVehicleId = null;
          }
        });
      } else {
        throw Exception(
            'Failed to load vehicles, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isVehiclesLoaded = false;
        _vehicleList = [];
        _selectedVehicleId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load vehicles. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isProceedEnabled = _isVehiclesLoaded &&
        (_selectedVehicleId != null && _selectedVehicleId!.isNotEmpty);

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
            title: Text(
              'My Vehicles',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromARGB(255, 0, 68, 124),
          ),
          body: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                left: _isCarVisible ? (screenWidth / 2) - 175 : screenWidth,
                top: (screenHeight / 2) - 400,
                child: Image.asset(
                  'assets/mycar.png',
                  height: 350,
                  width: 350,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 150),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Select Your Vehicle!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _isVehiclesLoaded
                          ? (_vehicleList.isNotEmpty
                              ? DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Select Vehicle No:',
                                    border: OutlineInputBorder(),
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                  ),
                                  value: _selectedVehicleId,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedVehicleId = value;

                                      final selectedVehicle =
                                          _vehicleList.firstWhere(
                                              (vehicle) => vehicle.id == value);
                                      GlobalData.setRiskName(
                                          selectedVehicle.name);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a vehicle';
                                    }
                                    return null;
                                  },
                                  items: _vehicleList.map((vehicle) {
                                    return DropdownMenuItem<String>(
                                      value: vehicle.id,
                                      child: Text(vehicle.name),
                                    );
                                  }).toList(),
                                )
                              : Text('No vehicles found.'))
                          : (_vehicleList.isEmpty
                              ? CircularProgressIndicator()
                              : Text('Loading vehicles...')),
                      SizedBox(height: 50),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: isProceedEnabled
                              ? Color.fromARGB(255, 51, 212, 37)
                              : Colors.grey,
                          elevation: 20,
                          shadowColor: const Color.fromARGB(255, 0, 0, 0),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: isProceedEnabled
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  '/Choises',
                                  arguments: widget.nicNumber,
                                );
                              }
                            : null,
                        child: Text(
                          'Let\'s Proceed',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Georgia',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
