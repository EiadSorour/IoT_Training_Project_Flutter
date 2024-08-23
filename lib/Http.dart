import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Class to create object from it that will help us in sending requests and receiving responses from our Node.js server
class MyHttp{

  // Node.js server base URL (Put your ip here instead)
  String url = Platform.isAndroid ? 'http://192.168.1.2:3001' : 'http://localhost:3001';

  // Login function that returns a "Promise"
  Future login(String username , String password) async{
    
    // Create new http client
    var client = http.Client();

    // Set url that we will post to it
    var uri = Uri.parse("$url/api/login");
    
    // Send "POST" request to the server and wait for response
    var response = await client.post(uri, body: {"username": username , "password": password});
    
    // Return response body after decoding it from string to json  
    return jsonDecode(response.body);
  }

  // Register function that returns a "Promise"
  Future register(String username , String password) async{
    // Create new http client
    var client = http.Client();

    // Set url that we will post to it
    var uri = Uri.parse("$url/api/register");

    // Send "POST" request to the server and wait for response
    var response = await client.post(uri, body: {"username": username , "password": password});

    // Return response body after decoding it from string to json 
    return jsonDecode(response.body);
  }
}