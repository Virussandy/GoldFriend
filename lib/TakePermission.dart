// import 'dart:convert';
// import 'package:goldfriend/Url.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'UploadData.dart';
//
// class TakePermission{
//
//   Url url = Url();
//   UploadData uploadData = UploadData();
//
//   Future<bool> getPermission() async {
//     if ((await checkPermission(Permission.phone)) && (await checkPermission(Permission.contacts))){
//       print('Permitted');
//       register();
//       return true;
//     }
//     print('not permitted');
//     return false;
//   }
//
//   Future<bool> checkPermission(Permission permission) async {
//     final result = await permission.request();
//     switch (result) {
//       case PermissionStatus.granted:
//       case PermissionStatus.limited:
//         return true;
//       case PermissionStatus.denied:
//       case PermissionStatus.restricted:
//       case PermissionStatus.permanentlyDenied:
//         return false;
//     }
//   }
//
//   Future<bool> recheck()async{
//     if (((await Permission.phone.status.isGranted) && (await Permission.contacts.status.isGranted)) || ((await Permission.phone.status.isLimited) && (await Permission.contacts.status.isLimited))){
//         print('Permitted');
//         return true;
//       }
//     return false;
//   }
//
//   void register() async {
//     final prefs = await SharedPreferences.getInstance();
//       final response = await http.post(Uri.parse(url.getLogin()),
//           body: {
//             "action" : "register",
//             "name" : "0",
//             "password" : "0",
//             "phone" : "0",
//             "deviceid" : prefs.getString('deviceid')
//           });
//       print(response.body);
//     final body = json.decode(response.body);
//     if(body['status'] == 200 || body['status'] == 404){
//       uploadData.getuserid();
//     }
//   }
// }