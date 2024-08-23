import 'package:smart_home_app/MyColors.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Home 🏡", style: TextStyle(color: Mycolors().yellow, fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Mycolors().blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome sentence
            Text("Welcome to our app ✌️" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
            // Navigate to "Login" page
            ElevatedButton(
              child: Text("Login", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: (){Navigator.pushNamed(context,"/login");}
            ),
            // Gap between widgets
            SizedBox(height: 5,),
            // Navigate to "Register" page
            ElevatedButton(
              child: Text("Register", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: (){Navigator.pushNamed(context,"/register");}
            ),
          ],
        ),
      ),
    );
  }
}