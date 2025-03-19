import 'dart:async';

import 'package:flutter/material.dart';
import 'package:galaxy_planet/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'Home_Page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.2),
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, double scale, _) {
              return AnimatedOpacity(
                opacity: _opacity,
                duration: Duration(seconds: 2),
                child: Transform.scale(
                  scale: scale,
                  child: Center(
                    child: Image.asset("assets/images/galaxy.png"),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 50),
          Text(
            "Galaxy Planet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
