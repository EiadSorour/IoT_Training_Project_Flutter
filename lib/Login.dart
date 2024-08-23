import 'package:smart_home_app/HomeState.dart';
import 'package:smart_home_app/Http.dart';
import 'package:smart_home_app/MyColors.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  // Http object to make http calls to our Node.js server
  MyHttp myHttp = MyHttp();

  // Text controllers to hold the value of text fields
  final _username = TextEditingController();
  final _password = TextEditingController();

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
            SizedBox(height: 10,),
            // Login button
            ElevatedButton(
              child: Text("Login", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: () async {
                // Check if all input fields have a value
                if(_username.text.isNotEmpty && _password.text.isNotEmpty){
                  // Variable to store server response
                  var response = await myHttp.login(_username.text, _password.text);
                  
                  // Check if response successeded
                  if(response["status"] == "success"){
                    // Navigate to "Home State" page and send registered username as a parameter to this page
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeState(username: response["data"]["username"])  ) );
                  }else{
                    // Show dialog to user showing him the server error happened during login process
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
                }else{
                  // Show dialog to show user that each field is mandatory
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text("Username and password required"),
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
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New to our app?" , style: TextStyle(color: Mycolors().blue, fontWeight: FontWeight.bold),),
                TextButton(
                  // Navigate to "Register" page if user doesn't have an account
                  onPressed: (){Navigator.pushNamed(context,"/register");},
                  child: Text("Sign up"),
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