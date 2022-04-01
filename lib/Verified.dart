import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Verified extends StatefulWidget {
  const Verified({Key? key}) : super(key: key);

  @override
  State<Verified> createState() => _VerifiedState();
}

class _VerifiedState extends State<Verified> {

  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 10),
            () => Navigator.pop(context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Verified',style: TextStyle(color: Colors.black),),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                    child: Lottie.asset('image/verified.json',repeat: false,addRepaintBoundary: true)
                ),
                const SizedBox(height: 20,),
                const Text('Registered Successfully',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                const SizedBox(height: 20,),
                const Text("Congratulations, your account has been Registered successfully. Now you will receive every day's gold rates updates on your registered number",
                style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                },
                  minWidth: 150,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Back to Home',style: TextStyle(fontSize: 15,color: Colors.white),),
                ),
                color: Colors.blue,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

