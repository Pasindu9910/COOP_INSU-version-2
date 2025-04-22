import 'dart:convert';
import 'package:customer_portal/Screens/taskmenu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:customer_portal/global_data.dart';

class Digitalinsuarance extends StatefulWidget {
  const Digitalinsuarance({super.key});

  @override
  State<Digitalinsuarance> createState() => _DigitalinsuaranceState();
}

class _DigitalinsuaranceState extends State<Digitalinsuarance> {
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
        userCode = sfccode;
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
            'Task Menu',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10), // Space after the app bar
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
            const SizedBox(
                height: 20), // Space between user name and menu items
            Expanded(
              child: Center(
                child: _buildTile(
                  context,
                  imagePath: 'assets/Digital.png',
                  label: 'Digital Insurance',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskMenu(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
        height: 150,
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
              width: 70,
              height: 70,
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
