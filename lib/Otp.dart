import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goldfriend/Url.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_button/timer_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Verified.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  Url url = Url();
  late String Phone,UserId,Name,_pin;
  var currentValue;

  @override
  void initState() {
    sendOtp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var textEditingController;
    var errorController;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Send OTP',style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('image/logo.png',width: 200,),
                  const SizedBox(height: 60,),
                  const Text("Verify Code",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                  const Text('Please check Your message and enter the verification code we just sent You',style: TextStyle(fontSize: 18,),textAlign:TextAlign.center),
                  const SizedBox(height: 20,),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.black,
                      activeColor: Colors.black,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    controller: textEditingController,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    keyboardType: TextInputType.number,
                    backgroundColor: Colors.white,
                    onCompleted: (v) {
                      print("Completed");
                      _pin = currentValue;
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentValue = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      return false;
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Divider(height: 5,color: Colors.black,),
                  TimerButton(
                    label: "Send OTP Again",
                    timeOutInSeconds: 30,
                    onPressed: () {
                      ReSendOtp();
                    },
                    disabledColor: Colors.white70,
                    buttonType: ButtonType.TextButton,
                    color: Colors.white70,
                    disabledTextStyle: const TextStyle(fontSize: 10.0,color: Colors.black),
                    activeTextStyle: const TextStyle(fontSize: 10.0, color: Colors.black),
                  ),
                  MaterialButton(onPressed: (){
                    ValidateOtp();
                  },
                  minWidth: double.maxFinite,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('VERIFY',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),),
                  ),
                  color: Colors.blue,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendOtp() async {
    final prefs = await SharedPreferences.getInstance();
    Phone = (prefs.getString('phone'))!;
    UserId = (prefs.getString('userid'))!;
    Name = (prefs.getString('name'))!;
    final response = await http.post(Uri.parse(url.getOtp()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain"
        },
        body: jsonEncode({
          "UserId" : UserId,
          "Name" : Name,
          "PhNo" : Phone
        }
        ));
    final body = json.decode(response.body);
    print(body);
    if(body['Status'] == 'Success'){

    }
    else{
      Fluttertoast.showToast(msg: body['Message']);
    }
  }

  void ReSendOtp() async {
    final response = await http.post(Uri.parse(url.getResendOtp()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain"
        },
        body: jsonEncode({
          "UserId" : UserId,
          "Name" : Name,
          "PhNo" : Phone
        }
        ));
    final body = json.decode(response.body);
    if(body['Status'] == 'Success'){
      print(body);
    }
  }

  void ValidateOtp() async {
    final response = await http.post(Uri.parse(url.getValidateOtp()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain"
        },
        body: jsonEncode({
          "UserId" : UserId,
          "Name" : Name,
          "PhNo" : Phone,
          "OTPCode" : _pin
        }
        ));
    final body = json.decode(response.body);
    if(body['Status'] == 'Success'){
      print(body);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Verified()));
    }else if(body['Status'] == 'Error'){
      print(body);
      Fluttertoast.showToast(msg: body['Message']);
    }
  }


  void launchprivacy() async {
    final prefs = await SharedPreferences.getInstance();
    var _url = "https://"+prefs.getString('privacypolicy')!;
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  void launchtermsodservices() async {
    final prefs = await SharedPreferences.getInstance();
    var _url = "https://"+prefs.getString('termsofservice')!;
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}
