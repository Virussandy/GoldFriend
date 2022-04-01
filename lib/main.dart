import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:goldfriend/FormData.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('image/logo.png'), context);
    return MaterialApp(
      title: 'GOLD FRIEND',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage( {Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // late AndroidDeviceInfo androidInfo;


  @override
  void initState() {
    // generateUserid();
    Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FormData()),));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Image(image: AssetImage('image/logo.png'),),
                  SizedBox(height: 20,),
                   Text('Gold And Silver Stay With You Forever',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 0.0),
              child: Text('Product by © CBPS Software Services Pvt. Ltd.',textAlign: TextAlign.center,),
            ),
          )
        ],
      ),);
  }

  // void generateUserid() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   androidInfo = await deviceInfo.androidInfo;
  //   prefs.setString('userid', androidInfo.androidId!);
  //   prefs.setString('deviceid', androidInfo.androidId!);
  // }
}
