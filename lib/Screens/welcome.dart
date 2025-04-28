import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Initialize video player
    _videoController = VideoPlayerController.asset('assets/LOGO.mp4')
      ..initialize().then((_) {
        setState(() {}); // Refresh UI when video is ready
        _videoController.setLooping(true);
        _videoController.play(); // Start playing video
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.06;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Full-screen Background Video
            _videoController.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Container(color: Colors.black), // Black screen while loading
            // Overlay UI elements
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 400.0),
                  Text(
                    'Co - Operative Insurance',
                    style: GoogleFonts.playfairDisplay(
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          offset: Offset(2, 2),
                        ),
                      ],
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'For the people by the people',
                    style: GoogleFonts.playfairDisplay(
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          offset: Offset(2, 2),
                        ),
                      ],
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black,
                      minimumSize: const Size(100, 50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/decision');
                    },
                    child: const Text(
                      'Let\'s get started',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
