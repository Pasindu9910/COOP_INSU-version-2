import 'dart:convert';
import 'package:customer_portal/Screens/policysearch.dart';
import 'package:customer_portal/global_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PolicyTypeSelectionPage extends StatefulWidget {
  const PolicyTypeSelectionPage({super.key});

  @override
  State<PolicyTypeSelectionPage> createState() =>
      _PolicyTypeSelectionPageState();
}

class _PolicyTypeSelectionPageState extends State<PolicyTypeSelectionPage> {
  String? userName;
  String? userCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    String? sfccode = GlobalData.getLogUser();
    if (sfccode == null || sfccode.isEmpty) {
      setState(() {
        userName = "Unknown User";
        userCode = "";
        isLoading = false;
      });
      return;
    }

    final apiUrl = 'http://124.43.209.68:9000/api2/v1/getSfcStatus/$sfccode';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            userName = data[0]['sfc_first_name'];
            userCode = sfccode;
            isLoading = false;
          });
        } else {
          setState(() {
            userName = "User Not Found";
            userCode = "";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          userName = "Error Fetching User";
          userCode = "";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userName = "Network Error";
        userCode = "";
        isLoading = false;
      });
    }
  }

  void _onTileTap(BuildContext context, String policyType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolicySearchPage(policyType: policyType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: const Text(
            'Policy Type Selection',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Current User: $userName ($userCode)",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              const SizedBox(height: 20),
              _buildTile(
                context,
                imagePath: 'assets/Policy Information.png',
                label: 'New Policy',
                onTap: () => _onTileTap(context, 'New Policy'),
              ),
              const SizedBox(height: 20),
              _buildTile(
                context,
                imagePath: 'assets/Vehicle Book.png',
                label: 'Renewal',
                onTap: () => _onTileTap(context, 'Renewal'),
              ),
              const SizedBox(height: 20),
              _buildTile(
                context,
                imagePath: 'assets/cancellation.png',
                label: 'Reset Policy Cancellation',
                onTap: () => _onTileTap(context, 'Policy Cancellation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required String label,
      required VoidCallback onTap,
      required String imagePath}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
