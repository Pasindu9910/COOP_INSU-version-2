import 'package:customer_portal/Screens/stafflogin.dart';
import 'package:flutter/material.dart';

class Decision extends StatefulWidget {
  const Decision({super.key});

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background with main content
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Are you an existing customers?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Georgia',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + _animationController.value * 0.1,
                                child: SizedBox(
                                  width: 110,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 51, 212, 37),
                                      elevation: 10,
                                      shadowColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/Login');
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontFamily: 'Georgia',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 1, 34, 61),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1 + _animationController.value * 0.1,
                                child: SizedBox(
                                  width: 110,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 203, 47, 47),
                                      elevation: 10,
                                      shadowColor: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/VehicleDetails');
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        fontFamily: 'Georgia',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 1, 34, 61),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Buttons at the bottom front of background
            Positioned(
              bottom: 30,
              right: -40,
              child: Container(
                width: 200,
                height: 50,
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 63, 224),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaffLoginPage(),
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment(0.6, 0),
                    child: const Text(
                      'Staff Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
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
}
