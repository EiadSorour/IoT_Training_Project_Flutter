import 'package:smart_home_app/HomeControll.dart';
import 'package:smart_home_app/MQTT.dart';
import 'package:smart_home_app/MyColors.dart';
import 'package:flutter/material.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key , required this.username});

  final String username;

  @override
  State<HomeState> createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {

  // MQTT object connect,publish and subscribe to HiveMQ broker
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  
  // Colors variables used in this page to manipulate widgets colors
  Mycolors colorTemp = new Mycolors();
  Mycolors colorHum = new Mycolors();
  Mycolors colorGas = new Mycolors();
  Mycolors colorDoor = new Mycolors();
  Mycolors colorIn = new Mycolors();

  // Variables to hold house state
  // Thses variables are displayed on the screen to allow user monitoring the house through our app
  // These variables change whenever we got a message from the broker related to certain variables
  String houseTemp = "";
  String houseHumd = "";
  String houseGas = "";
  String doorState = "";
  String someoneIn = "";

  // List of topics we want to subscribe to it
  List<String> topics = ["ESP/temperature" , "ESP/humidity" , "ESP/gas" ,
                          "ESP/someoneIn" , "ESP/doorState"];

  @override
  void initState() {
    super.initState();

    // Perpare MQTT client and subscribe to the previous list of topics
    mqttClientWrapper.prepareMqttClient(topics);

    // Implement the callback function that will be excuted when we get a message from topics we subscribed to
    mqttClientWrapper.onMessageReceived = (message,topic){
      // Change state of variables according to recieved topic and message 
      setState(() {
        // Topic routing
        switch(topic){
          // Change temperature value state and its text color state
          case "ESP/temperature":
            // Temperature greater than 33C -> danger
            if(double.parse(message) >= 33){
              colorTemp.makeRed();
            }else{
              colorTemp.makeGreen();
            }
            houseTemp = message;
            break;
          // Change humidity value state and its text color state
          case "ESP/humidity":
            // Hmudity greater than 70% -> danger
            if(double.parse(message) >= 70){
              colorHum.makeRed();
            }else{
              colorHum.makeGreen();
            }
            houseHumd = message;
            break;
          // Change gas value state and its text color state
          case "ESP/gas":
            // Gas greater than 40% -> danger
            if(double.parse(message) >= 40){
              colorGas.makeRed();
            }else{
              colorGas.makeGreen();
            }
            houseGas = message;
            break;
          // Change someoneIn value state and its text color state
          case "ESP/someoneIn":
            // If someone inside the house -> danger
            if(message == "yes"){
              colorIn.makeRed();
            }else{
              colorIn.makeGreen();
            }
            someoneIn = message;
            break;
          // Change door value state and its text color state
          case "ESP/doorState":
            // If door is opened -> danger
            if(message == "open"){
              colorDoor.makeRed();
            }else{
              colorDoor.makeGreen();
            }
            doorState = message;
            break;
          default:
            break;
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home State 🏡", style: TextStyle(color: Mycolors().yellow, fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Mycolors().blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome, ${widget.username}" , style: TextStyle(
              background: Paint()
                ..color = Mycolors().blue
                ..strokeWidth = 50
                ..strokeJoin = StrokeJoin.round
                ..strokeCap = StrokeCap.round
                ..style = PaintingStyle.stroke,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Mycolors().yellow
              ),
            ),
            SizedBox(height: 65,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.door_front_door, size: 50),
                SizedBox(width: 5,),
                Text("Door State: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                Text(doorState , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: colorDoor.mainColor),)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 50),
                SizedBox(width: 5,),
                Text("Someone inside house: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                Text(someoneIn , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: colorIn.mainColor),)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_fire_department, size: 50, color: Colors.red),
                SizedBox(width: 5,),
                Text("Temperature: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                Text("${houseTemp} C" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: colorTemp.mainColor),)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 50, color: Colors.blue),
                SizedBox(width: 5,),
                Text("Humidity: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                Text("${houseHumd} %" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: colorHum.mainColor),)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_gas_station, size:  50, color: Colors.grey),
                SizedBox(width: 5,),
                Text("Gas: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                Text("${houseGas} %" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20 , color: colorGas.mainColor),)
              ],
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              child: Text("Home Control", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: () {
                // Naviaget to "Home Controll" page
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeController(username: widget.username)  ) );
              },
            ),
          ],
        )
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Mycolors().blue,
        onPressed: (){Navigator.pushNamed(context,"/home");}, 
        child: Text("🏡", style: TextStyle(fontSize: 30),),
      ),
      
    );
  }
}