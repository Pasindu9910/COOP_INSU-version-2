import 'package:customer_portal/Screens/newInspection.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For simulating API delay

class PolicySearchPage extends StatefulWidget {
  const PolicySearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PolicySearchPageState createState() => _PolicySearchPageState();
}

class _PolicySearchPageState extends State<PolicySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, String>? _policyData; // To store search results
  bool _isLoading = false;

  // Simulated API call
  Future<void> _searchPolicy(String policyNumber) async {
    setState(() {
      _isLoading = true;
      _policyData = null;
    });

    // Simulating API delay
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data (Replace with real API response)
    if (policyNumber == "12345") {
      setState(() {
        _policyData = {
          "customerName": "John Doe",
          "customerNIC": "987654321V",
          "vehicleNo": "ABC-1234",
        };
      });
    } else {
      setState(() {
        _policyData = null;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background2.png'), // Same as login page
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Policy Search',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _policyData != null
                      ? _buildPolicyTile(context)
                      : const Text(
                          "Enter a valid policy number to search",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Enter Policy Number",
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _searchPolicy(_searchController.text);
            }
          },
        ),
      ),
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, color: Colors.black),
    );
  }

  Widget _buildPolicyTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => newvehicleInspec(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Customer Name:", _policyData!["customerName"]!),
            _infoRow("Customer NIC:", _policyData!["customerNIC"]!),
            _infoRow("Vehicle No:", _policyData!["vehicleNo"]!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label $value",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Dummy policy details page
class PolicyDetailsPage extends StatelessWidget {
  final Map<String, String> policyData;
  const PolicyDetailsPage({super.key, required this.policyData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Policy Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer Name: ${policyData["customerName"]}",
                style: const TextStyle(fontSize: 18)),
            Text("Customer NIC: ${policyData["customerNIC"]}",
                style: const TextStyle(fontSize: 18)),
            Text("Vehicle No: ${policyData["vehicleNo"]}",
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
