import 'package:customer_portal/Screens/addnewvehicle.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Digimenu extends StatefulWidget {
  const Digimenu({super.key});

  @override
  State<Digimenu> createState() => _DigimenuState();
}

class _DigimenuState extends State<Digimenu> {
  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async {
    launch(url);
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
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTile(
                      context,
                      imagePath: 'assets/Front Photo.png',
                      label: 'Register new vehicle',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Addnewvehicle(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTile(
                      context,
                      imagePath:
                          'assets/Quotation.png', // Make sure this asset exists
                      label: 'Quotation',
                      onTap: () {
                        _launchURL('https://ci.lk/getamotorquote/');
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTile(
                      context,
                      imagePath:
                          'assets/customer.png', // Make sure this asset exists
                      label: 'Customer Feed Back',
                      onTap: () {
                        _launchURL('https://ci.lk/complaint/ ');
                      },
                    ),
                  ],
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
