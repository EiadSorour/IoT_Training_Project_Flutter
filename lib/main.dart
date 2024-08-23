import 'package:flutter/material.dart';
import 'package:smart_home_app/Home.dart';
import 'package:smart_home_app/Login.dart';
import 'package:smart_home_app/Register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      // App pages routing
      routes: {
        "/home": (context)=>MyHomePage(),
        "/login": (context)=>Login(),
        "/register": (context)=>Register()
      },
    );
  }
}