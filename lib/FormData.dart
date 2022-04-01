import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Otp.dart';
import 'TakePermission.dart';
import 'Url.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:url_launcher/url_launcher.dart';

class FormData extends StatefulWidget {
  const FormData({Key? key}) : super(key: key);

  @override
  State<FormData> createState() => _FormDataState();
}

class _FormDataState extends State<FormData> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();
  // TakePermission takepermission = TakePermission();
  Url url = Url();
  var ListOfStates = <states>[];
  var ListOfCities = <cities>[const cities(city_id: '0', city_name: 'Select City')];
  late TextEditingController controllerphone, controllername;
   String name = '', phone = '', stateid = '', cityid = '';
  late states selectedstate ;
  late cities selectedcity ;

  @override
  void initState() {
    // checkPermission();
    getTermsOfService();
    getprivacyandpolicy();
    WidgetsBinding.instance?.addObserver(this);
    controllername = TextEditingController();
    controllerphone = TextEditingController();
    getStates();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void reassemble() {
    // checkPermission();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){MoveToBackground.moveTaskToBack();},),
        actions: const [
          IconButton(icon: Icon(Icons.menu,color: Colors.black,),onPressed: null,)
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Sign Up',style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('image/logo.png',width: 200,),
                    const SizedBox(height: 60,),
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      controller: controllername,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        hintText: 'Enter Full Name',
                        label: Text('Name'),
                      ),
                    ),
                    const SizedBox(height: 15,),

                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Text is empty';
                        }
                        return null;
                      },
                      controller: controllerphone,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        hintText: 'Enter Mobile no',
                        label: Text('Phone'),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    DropdownButtonFormField(
                      autofocus: false,
                      validator: (String){
                        if(stateid == ''){
                          return 'Please select State';
                        }else{
                          return null;
                        }
                      },
                      items: ListOfStates
                          .map<DropdownMenuItem<states>>((states value) {
                        return DropdownMenuItem<states>(
                          value: value,
                          child: Text(value.state_name),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        label: Text("Select State"),
                          labelStyle: TextStyle(),
                          prefixIcon: Icon(Icons.place),
                          border: OutlineInputBorder()
                      ),
                      // hint: const Text('Select State'),
                      onChanged: (states? val) {
                        selectedstate = val!;
                        stateid = selectedstate.state_id;
                        getCity(selectedstate.state_id);
                      },),
                    const SizedBox(height: 15,),
                    DropdownButtonFormField(
                      autofocus: false,
                      validator: (String){
                        if(cityid == ''){
                          return 'Please select City';
                        }else{
                          return null;
                        }
                      },
                      items: ListOfCities
                          .map<DropdownMenuItem<cities>>((cities value) {
                        return DropdownMenuItem<cities>(
                          value: value,
                          child: Text(value.city_name),
                        );
                      }).toList(),
                      value: ListOfCities[0],
                      decoration: const InputDecoration(
                        // label: Text("Select City"),
                          labelStyle: TextStyle(),
                          prefixIcon: Icon(Icons.place),
                          border: OutlineInputBorder()
                      ),
                      // hint: const Text('Select city'),
                      onChanged: (cities? val) {
                        setState(() {
                          selectedcity = val!;
                          cityid = selectedcity.city_id;
                        });
                      },),
                    const SizedBox(height: 15,),
                    MaterialButton(onPressed: () => validateForm(),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('CONTINUE', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                      color: Colors.blue,
                      minWidth: double.maxFinite,),
                    const SizedBox(height: 20,),
                    const Text('By signing up you have agreed to our'),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            launchtermsodservices();
                          },
                            child: const Text('Terms of Use',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue),)),
                        const Text(' & '),
                        InkWell(
                          onTap: (){
                            launchprivacy();
                          },
                            child: const Text('Privacy Policy',style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue),))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getStates() async {
    final response = await http.get(Uri.parse(url.getStates()));

    setState(() {
      ListOfStates = (json.decode(response.body) as List).map((e) => states.fromJson(e)).toList();
    });
  }

  void getCity(String id) async {
    final response = await http.get(Uri.parse(url.getCities()).replace(query: 'id=$id'));
    setState(() {
      ListOfCities = (json.decode(response.body) as List).map((e) => cities.fromJson(e)).toList();
      cityid = ListOfCities[0].city_id;
    });
  }

  validateForm() {
    _formKey.currentState?.validate();
    setState(() {
      name = controllername.text.toString();
      phone = controllerphone.text.toString();
      if(name!='' && phone!='' && stateid!='' && cityid!=''){
        upload();
      }
    });
  }

  void upload() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("phone", phone);
    await prefs.setString("name", name);

    final response = await http.post(Uri.parse(url.getRegister()),
    headers: {
      "Content-Type": "application/json"
    },
      body: jsonEncode({"Name" : name,"phNO" : phone,"State" : stateid,"District" : cityid , "action" : "0"})
    );
    final body = json.decode(response.body);
    print(body);
    if(body['Status'] == 'Success'){
      print(body);
      await prefs.setString('userid', body['Message']);
      _formKey.currentState?.reset();
      controllerphone.clear();
      controllername.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Otp()));
    }else if(body['Status'] == 'Error'){
      Fluttertoast.showToast(msg: body['Message']);
    }
  }

  void getprivacyandpolicy() async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url.getPrivacyPoliciy()),);
    final body = json.decode(response.body);
    if (body['status'] == 200) {
      print(body);
      prefs.setString('privacypolicy', body['data'].toString().trim());
    } else if (body['status'] == 404) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      print(body);
    }
  }

  void getTermsOfService() async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url.getTermsOfService()),);
    final body = json.decode(response.body);
    if (body['status'] == 200) {
      prefs.setString('termsofservice', body['data'].toString().trim());
      print(body);
    } else if (body['status'] == 404) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      print(body);
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

//   void checkPermission() async {
//     Future<bool> permitted = takepermission.getPermission();
//     if(await permitted){
//       print("done");
//     }
//     else if(!await permitted){
//       print('unDone');
//       Alert(
//         onWillPopActive: true,
//         context: context,
//         style: const AlertStyle(
//           isCloseButton: false,
//           isOverlayTapDismiss: false,
//         ),
//         useRootNavigator: false,
//         type: AlertType.error,
//         title: "Permission",
//         desc: "Please grant permissions to use the application",
//         buttons: [
//           DialogButton(
//             color: Colors.red,
//             child: const Text(
//               "Close",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () async {
//               Future<bool> recheck = takepermission.recheck();
//               if(await recheck){
//                 Navigator.pop(context);
//               }
//               if(!await recheck){
//                 exit(0);
//               }
//             }
//           ),
//           DialogButton(
//             child: const Text(
//               "Setting",
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//             onPressed: () => openAppSettings(),
//           )
//         ],
//       ).show();
//     }
//   }
}
class states{
 final String state_id;
 final String state_name;

 const states ({
   required this.state_id,
   required this.state_name
});
 factory states.fromJson(Map<String, dynamic> json){
   return states(
     state_id: json['StateId'] as String,
     state_name: json['StateName'] as String
   );
 }
}
class cities{
  final String city_id;
  final String city_name;

  const cities ({
    required this.city_id,
    required this.city_name
  });
  factory cities.fromJson(Map<String, dynamic> json){
    return cities(
        city_id: json['DistrictId'] as String,
        city_name: json['DistrictName'] as String
    );
  }
}
