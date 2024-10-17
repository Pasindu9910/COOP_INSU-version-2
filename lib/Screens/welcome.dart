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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
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
          child: Padding(
            padding: const EdgeInsets.only(top: 110.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    child: Image.asset(
                      'assets/Logo.png',
                      height: 180,
                      width: 180,
                    ),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: child,
                      );
                    },
                  ),
                  SizedBox(height: 30.0),
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
                  SizedBox(height: 100.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        minimumSize: Size(100, 50)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/decision');
                    },
                    child: Text(
                      'Let\'s get started',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
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
      ),
    );
  }
}
