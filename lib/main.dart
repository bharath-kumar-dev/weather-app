import 'package:flutter/material.dart';
// import 'package:weather_api_get/chennai.dart';

import 'package:weather_api_get/splashscreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      
      duration: 2000,
      splash:Icon(Icons.cloud,color:  Colors.white, size: 200,) ,
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize:100 ,
      backgroundColor: Colors.lightBlueAccent,
      nextScreen: MyWidget(),
    );
  }
}