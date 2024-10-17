// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChoicesPage extends StatefulWidget {
  final String nicNumber;

  const ChoicesPage({super.key, required this.nicNumber});

  @override
  State<ChoicesPage> createState() => _ChoicesPageState();
}

class _ChoicesPageState extends State<ChoicesPage> {
  void _launchURL(String url) async {
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 68, 124),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: const TabBar(
                labelColor: Colors.white,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 5.0,
                    color: Color.fromARGB(255, 244, 212, 33),
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 1.0),
                ),
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: 'Services'),
                  Tab(text: 'About Us'),
                ],
              ),
              title: Center(
                child: Transform.translate(
                  offset: const Offset(-30, 0), // Move text 10px to the left
                  child: const Text(
                    'Main Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Georgia',
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding: EdgeInsets.all(20),
                      childAspectRatio: 1.5,
                      children: [
                        _buildButton(
                          context,
                          'Policy Information',
                          '/Policyinfo',
                          imagePath: 'assets/policy.png',
                          nicNumber: widget.nicNumber,
                        ),
                        _buildButton(
                          context,
                          'Vehicle Inspection',
                          '/Inspection',
                          imagePath: 'assets/protection.png',
                        ),
                        _buildButton(
                          context,
                          'ARI',
                          imagePath: 'assets/insurance.png',
                          null,
                        ),
                        _buildButton(
                          context,
                          'Accident Report',
                          '/Accident',
                          imagePath: 'assets/crash.png',
                        ),
                        _buildButton(
                          context,
                          'Third Party renewal',
                          null,
                          imagePath: 'assets/renewal.png',
                          url: 'https://online.ci.lk/third_party/',
                        ),
                        _buildButton(
                          context,
                          'Premium payment',
                          null,
                          imagePath: 'assets/pay.png',
                          url: 'https://online.ci.lk/general/',
                        ),
                        _buildButton(
                          context,
                          'Quotation',
                          null,
                          imagePath: 'assets/pay.png',
                          url: 'https://ci.lk/getamotorquote/',
                        ),
                        _buildButton(
                          context,
                          'Customer feedback',
                          null,
                          imagePath: 'assets/customer.png',
                          url: 'https://ci.lk/complaint/ ',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "About Us",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Georgia',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildTile(
                              title: "Co-operative Insurance Company PLC",
                              content:
                                  "Incorporated in Sri Lanka in 1999. Licensed as a company authorized to carry out insurance business under the Control of Insurance Act No. 25 of 1962 as amended by Act No. 42 of 1986 (presently replaced by Regulation of Insurance Industry Act No. 43 of 2000). We are one of the leading insurers who provide innovative insurance solutions across all lines of business, with the third-largest network in Sri Lanka.",
                            ),
                            _buildTile(
                              title: "History",
                              content:
                                  "In 1999, Co-operative Insurance Company PLC (CICPLC) was established by the co-operative movement with great prospects. More than 2 decades and numerous challenges later, CICPLC is one of the largest and fastest-growing companies in Sri Lanka.\n\nAs a customer-centric and people-driven organization, we inspire our stakeholders to be proactive and innovative. Our utmost convenient solutions set us apart from other orthodox entities in the industry.",
                            ),
                            _buildTile(
                              title: "Vision",
                              content:
                                  "“To be an organization that will stand 'united' with its customers to the very end.”",
                            ),
                            _buildTile(
                              title: "Mission",
                              content:
                                  "“To be ever mindful of the needs of our customers and thereby make 'true protection' via the provision of innovative, yet affordable insurance solutions which conform to the highest ethical and moral standards.”",
                            ),
                            _buildTile(
                              title: "Values",
                              content:
                                  "R - Respect - Respectful when REACT\nE - Ethical - Ethical when REACT\nA - Accountable - Accountable when REACT\nC - Commitment - Committed when REACT\nT - Trust - Trustworthy when REACT",
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildSocialButton('assets/youtube.png', () async {
                              launch(
                                  'https://www.youtube.com/channel/UC6-Ex5c_AFfBi7mJxP6dsIw');
                            }),
                            SizedBox(height: 16),
                            _buildSocialButton(
                              'assets/linkedin.png',
                              () async {
                                launch(
                                    'https://www.linkedin.com/company/co-operative-insurance/');
                              },
                            ),
                            SizedBox(height: 16),
                            _buildSocialButton(
                              'assets/facebook.png',
                              () async {
                                launch(
                                    'https://www.facebook.com/Coperativeinsurance/');
                              },
                            ),
                          ],
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
    );
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      shape: CircleBorder(),
      elevation: 5,
      child: Image.asset(
        iconPath,
        fit: BoxFit.contain,
        width: 30,
        height: 30,
      ),
    );
  }

  Widget _buildTile({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.8),
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 68, 124),
              ),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Georgia',
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String? route,
      {String? imagePath, String? nicNumber, String? url}) {
    return SizedBox(
      width: 150,
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 15,
          shadowColor: Colors.black,
        ),
        onPressed: () {
          if (url != null) {
            _launchURL(url);
          } else if (route != null) {
            Navigator.pushNamed(
              context,
              route,
              arguments: nicNumber,
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath,
                height: 60,
                width: 60,
              ),
            SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Georgia',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
