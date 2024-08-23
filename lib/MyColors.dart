import 'package:flutter/material.dart';

// Class that contains colors palette used inside our app
class Mycolors {
  Color yellow = Color.fromARGB(255,250, 255, 175);
  Color blue = Color.fromARGB(255,15, 103, 177);
  Color cyan = Color.fromARGB(255, 63, 162, 246);
  Color cyanLight = Color.fromARGB(255, 150, 201, 244);
  Color mainColor = Colors.green;

  // Turns main color into green
  void makeGreen(){
    mainColor = Colors.green; 
  }

  // Turns main color into red
  void makeRed(){
    mainColor = Colors.red; 
  }
}