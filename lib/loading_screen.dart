import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: false);

    // Navigate to the login screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1A39DB), // Background color for loading screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Asset Image
            Image.asset(
              'assets/logo.png',
              width: 80, // Adjust based on your asset size
              height: 80,
            ),
            const SizedBox(
                height: 30), // Space between the asset and the progress bar
            // Animated Progress Bar
            SizedBox(
              width: 200,
              height: 5,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                    value: _controller.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
