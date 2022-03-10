import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class scrollview extends StatefulWidget {
  @override
  scrollviewPageState createState() => scrollviewPageState();
}

class scrollviewPageState extends State<scrollview> with TickerProviderStateMixin {


  ScrollController _scrollController = new ScrollController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
         //_showBackToTopButton = true; // show the back-to-top button
          } else {
          //  _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_scrollController.hasClients){
        _scrollController.position.ensureVisible(
          _formKey.currentContext.findRenderObject(),
          alignment: 0.0, // Aligns the image in the middle.
       //   duration: const Duration(milliseconds: 120), // So it does not jump.
        );      }
    });



  }


  @override
  Widget build(BuildContext context) {



        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,

          child: ConstrainedBox(
            constraints: BoxConstraints(
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(

                    // A fixed-height child.
                    color: const Color(0xffeeee00), // Yellow
                    height: 1220.0,
                    alignment: Alignment.center,
                    child: const Text('Fixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height CoFixed Height Content'),
                  ),
                  Expanded(
                    // A flexible child that will grow to fit the viewport but
                    // still be at least as big as necessary to fit its contents.
                    child: Container(
                      key: _formKey,

                      color: const Color(0xffee0000), // Red
                      height: 1200.0,
                      alignment: Alignment.center,
                      child: const Text('Flexible Content'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );


  }




  }
