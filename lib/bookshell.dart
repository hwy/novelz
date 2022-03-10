import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'reader_scene.dart';
import 'sqfhelper.dart';

//list viewpage

class BookShell extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new BookShellState();
}



class BookShellState extends State<BookShell> {

  DatabaseHelper databaseHelper= DatabaseHelper.instance;



  Map<String, dynamic> bookDetail;


  List<Map<String, dynamic>> listItems;
  int articleId;
  String abc;
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: LoadBook(),
        builder: (context,  snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.memory( base64Decode(listItems[index]['bookphoto'])),
                      title: Text('${listItems[index]['bookname']}'+'${listItems[index]['bookreadchapter']}'),
                      subtitle: Text('${listItems[index]['bookupdate']}'),
                      //     abc = listItems[index]['bookphoto'].to;
                      // articleId=int.parse(listItems[index]['id']);
                      onTap: () async {

                        bookDetail= listItems[index];
                        String naviatorpage = 'bookshell';
                        final result = await Navigator.pushReplacement(
                            context,
                            // We'll create the SelectionScreen in the next step!
                            new MaterialPageRoute(builder: (context) => new ReaderScene(bookDetail,naviatorpage)));
                       // Navigator.pop(context);
                      },
                    );

                  },

                )

            );
          }
          else{

           // debugPrint(listItems.toString()+"2222222222222222");

            return CircularProgressIndicator();

          }}

    );

  }





  Future   <List<Map<String, dynamic>>> LoadBook()async{
    // debugPrint(image+"imageimageimageimage");
    listItems =    await databaseHelper.queryAllBook();


    return listItems;
  }
}


