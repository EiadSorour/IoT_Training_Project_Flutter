import 'package:smart_home_app/HomeState.dart';
import 'package:smart_home_app/Http.dart';
import 'package:smart_home_app/MyColors.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Http object to make http calls to our Node.js server
  MyHttp myHttp = MyHttp();

  // Text controllers to hold the value of text fields
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text("Smart Home 🏡", style: TextStyle(color: Mycolors ().yellow, fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Mycolors().blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username text field
            SizedBox(
              width: 350, 
              child: TextField(
                controller: _username,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: "Username",
                  labelStyle: TextStyle(color: Mycolors().cyan),
                ),
              ),
            ),
            // Gap between widgets
            SizedBox(height: 20,),
            // Password text field
            SizedBox(
              width: 350, 
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Mycolors().cyan),
                ),
              ),
            ),
            // Gap between widgets
            SizedBox(height: 20,),
            // Confirm password text field
            SizedBox(
              width: 350, 
              child: TextField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Mycolors().cyan),
                ),
              ),
            ),
            // Gap between widgets
            SizedBox(height: 10,),
            // Register button
            ElevatedButton(
              child: Text("Register", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: () async {
                // Check if any field is empty 
                if(_username.text.isEmpty || _password.text.isEmpty || _confirmPassword.text.isEmpty){
                  // Show dialog to show user that each field is mandatory
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text("Username,Password and confirm password are required"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                }else if(_password.text != _confirmPassword.text){  // Check if password and its confirmation don't match
                  // Show dialog to user informing him to recheck his password
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text("Passwords doesn't match"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                }else{   // Register details are vaild so let's make post request to the Node.js server
                  
                  // Variable to store server response
                  var response = await myHttp.register(_username.text, _password.text);
                  
                  // Check if response successeded
                  if(response["status"] == "success"){
                    // Navigate to "Home State" page and send registered username as a parameter to this page
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeState(username: response["data"]["username"])  ) );
                  }else{
                    // Show dialog to user showing him the server error happened during registeration process
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Server Error'),
                          content: Text(response["message"]),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Have an account?" , style: TextStyle(color: Mycolors().blue, fontWeight: FontWeight.bold),),
                TextButton(
                  // Navigate to "Login" page if user has an account already
                  onPressed: (){Navigator.pushNamed(context,"/login");},
                  child: Text("Sign in"),
                )
              ],
            )
          ],
        ),
      ),

      // Button to logout and return to "Home page"
      floatingActionButton: FloatingActionButton(
        backgroundColor: Mycolors().blue,
        onPressed: (){Navigator.pushNamed(context,"/home");}, 
        child: Text("🏡", style: TextStyle(fontSize: 30),),
      ),
    );
  }
}