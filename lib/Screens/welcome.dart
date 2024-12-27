import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 10.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.06;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Adjusted to start for top alignment
              children: [
                // Move everything a little bit down by adding a SizedBox
                SizedBox(height: 300), // Added this for space from the top

                // Stack for glow and logo isolation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulsating Glow
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 200, // Size of glow area
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.6),
                                blurRadius: _glowAnimation.value,
                                spreadRadius: _glowAnimation.value / 2,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // Logo Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/Logo.png',
                        height: 180,
                        width: 180,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Text(
                  'For the people by the people',
                  style: GoogleFonts.playfairDisplay(
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: const Color.fromARGB(255, 138, 137, 137),
                        offset: Offset(2, 2),
                      ),
                    ],
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 50.0), // Increased space between text and button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    minimumSize: const Size(100, 50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/decision');
                  },
                  child: const Text(
                    'Let\'s get started',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Georgia',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
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
