import 'package:smart_home_app/HomeState.dart';
import 'package:smart_home_app/MQTT.dart';
import 'package:smart_home_app/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key , required this.username});

  final String username;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  // MQTT object connect,publish and subscribe to HiveMQ broker
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  // Colors variables used in this page to manipulate widgets colors
  Mycolors colorLights = new Mycolors();
  Mycolors colorAlarm = new Mycolors();
  Mycolors colorDoor = new Mycolors();

  // Variables to hold house state
  // Thses variables are displayed on the screen to allow user monitoring the house through our app
  // These variables change whenever we got a message from the broker related to certain variables
  String lightsText = "";
  String alarmText = "";
  String doorText = "";

  // List of topics we want to subscribe to it
  List<String> topics = ["ESP/doorState" , "ESP/alarm" , "ESP/ledState"];

  // Variables to hold "current lcd message" and "current lights color"
  final _screen = TextEditingController();
  Color _currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    
    // Perpare MQTT client and subscribe to the previous list of topics
    mqttClientWrapper.prepareMqttClient(topics);

    // Implement the callback function that will be excuted when we get a message from topics we subscribed to
    mqttClientWrapper.onMessageReceived = (message,topic){
      // Change state of variables according to recieved topic and message 
      setState(() {
        switch(topic){
          // Door state
          case "ESP/doorState":
            if(message == "open"){
              colorDoor.makeGreen();
              doorText = "close";
            }else{
              colorDoor.makeRed();
              doorText = "open";
            }
            break;
          // Alarm state
          case "ESP/alarm":
            if(message == "activate"){
              colorAlarm.makeGreen();
              alarmText = "deactivate";
            }else{
              colorAlarm.makeRed();
              alarmText = "activate";
            }
            break;
          // LED State
          case "ESP/ledState":
            if(message == "on"){
              colorLights.makeRed();
              lightsText = "off";
            }else{
              colorLights.makeGreen();
              lightsText = "on";
            }
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
        title: Text("Home Control 🏡", style: TextStyle(color: Mycolors().yellow, fontSize: 30, fontWeight: FontWeight.bold),),
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
                Icon(Icons.monitor, size: 50, color: Mycolors().cyan),
                SizedBox(width: 5,),
                Text("Screen Text: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                SizedBox(
                  width: 140, 
                  child: TextField(
                    controller: _screen,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  child: Text("Set", style: TextStyle(color: Mycolors().yellow),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Mycolors().cyan,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Check if input field contains a sentence more than 16 character
                    if(_screen.text.length > 16){
                      // Show user that LCD message can't exceed 16 characters
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Screen Text Error'),
                          content: Text("Screen text can't be longer than 16 characters"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                    }else{
                      // Publish new LCD message to HiveMQ broker
                      mqttClientWrapper.publishMessage("Flutter/screen", _screen.text);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, size: 50, color: Mycolors().cyan),
                SizedBox(width: 5,),
                Text("Lights: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                ElevatedButton(
                  child: Text(lightsText, style: TextStyle(color: Mycolors().yellow),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorLights.mainColor,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Publish on/off lights in house to HiveMQ broker
                    mqttClientWrapper.publishMessage("Flutter/ledState", lightsText);
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette, size: 50, color: Mycolors().cyan),
                SizedBox(width: 5,),
                Text("Lights Color: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                ElevatedButton(
                  child: Text("Pick Color", style: TextStyle(color: Mycolors().yellow),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Mycolors().cyan,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Show color pick window for the user to pick (R,G,B) values for lights color
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Pick a color'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: _currentColor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  // Changed current lights color to the selected user color
                                  _currentColor = color;
                                });
                              },
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Select'),
                              onPressed: () {

                                // Publish each color from (R,G,B) to its topics on HiveMQ broker
                                mqttClientWrapper.publishMessage("Flutter/ledColor/red", _currentColor.red.toString());
                                mqttClientWrapper.publishMessage("Flutter/ledColor/green", _currentColor.green.toString());
                                mqttClientWrapper.publishMessage("Flutter/ledColor/blue", _currentColor.blue.toString());
                                
                                // Close dialog
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_alarm, size: 50, color: Mycolors().cyan),
                SizedBox(width: 5,),
                Text("Alarm: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                ElevatedButton(
                  child: Text(alarmText, style: TextStyle(color: Mycolors().yellow),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAlarm.mainColor,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Publish activate/deactivate alarm in house to HiveMQ broker
                    mqttClientWrapper.publishMessage("Flutter/alarm", alarmText);
                  },
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.door_front_door, size: 50, color: Mycolors().cyan),
                SizedBox(width: 5,),
                Text("Door: " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),),
                SizedBox(width: 5,),
                ElevatedButton(
                  child: Text(doorText, style: TextStyle(color: Mycolors().yellow),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorDoor.mainColor,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Publish opne/close door in house to HiveMQ broker
                    mqttClientWrapper.publishMessage("Flutter/doorState", doorText);
                  },
                ),
              ],
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              child: Text("Home State", style: TextStyle(color: Mycolors().yellow),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors().cyan,
                elevation: 0,
              ),
              onPressed: () {
                // Naviagte to "Home State" page
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeState(username: widget.username)  ) );
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