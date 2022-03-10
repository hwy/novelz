import 'dart:async';
import 'package:flutter/material.dart';
import 'reader_scene.dart';

import 'mainpage.dart';

void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }




  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => MainPage()
    )
    );
  }

  initScreen(BuildContext context) {

    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent[700]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        alignment: FractionalOffset(0.5, 0.9),

        // child: Image(image: NetworkImage("http://pic.616pic.com/ys_bnew_img/00/18/92/rz25PYO8sb.jpg"),width: 100.0,)
      ),


    );
  }
}