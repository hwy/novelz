import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'loadingdialog.dart';
import 'reader_scene.dart';

import 'bookshow.dart';
import 'sqfhelper.dart';

 var image;
String booklinkall;


class BookDialog extends StatefulWidget {
  // var booklinkall;
   Map<String, dynamic>  datadetail;
   List bookchaptertitle =[] ;
   List bookchapterlink=[] ;

  BookDialog({Key key, @required this.datadetail,this.bookchaptertitle,this.bookchapterlink}) : super(key: key);

//  debugPrint(datadetail.toString());
  @override
  State<StatefulWidget> createState() => BookDialogData(datadetail: datadetail,bookchaptertitle:bookchaptertitle,bookchapterlink:bookchapterlink);
}

class BookDialogData extends State<BookDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
   Map<String, dynamic>  datadetail;
  List bookchaptertitle =[] ;
  List bookchapterlink=[] ;

  BookDialogData({Key key, @required this.datadetail,this.bookchaptertitle,this.bookchapterlink});
  DatabaseHelper databaseHelper= DatabaseHelper.instance;
String bookbase64Image;
  @override
  void initState() {
    super.initState();


    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
   // Uint8List bytes = base64Decode(datadetail['bookbase64Image']);

    return Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 96.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(datadetail['bookname'],
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: Text('作者 :'+
                                              datadetail['bookauthor'].toString()),
                                          //subtitle: Text(datadetail['booklastupdatedate']),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: 95,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      image:CachedNetworkImageProvider(image),
                                      //new Image.memory(bytes).image,
                                      //Uint8List bytes = BASE64.decode(_base64),
                                  //Image.memory(base64Decode(datadetail['bookbase64Image'])),
                                      fit: BoxFit.cover)),
                              margin: EdgeInsets.only(left: 8.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.all(10.0),
                         // margin: EdgeInsets.all(10.0),

                          width: double.maxFinite,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height *0.55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
//                              Divider(),

                          /*    ListTile(
                                title: Text("簡介"),
                              ),
                            Divider(), */
                              new Expanded(
                                flex: 1,
                                child: new SingleChildScrollView(
                                    child: new Text('簡介\n'+datadetail['bookdesc']??"test")
                                ),
                              ),
               Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: <Widget>[
                   OutlineButton(
                onPressed: () {
                  Navigator.pop(context);
                  print(BorderStyle.values);
                },
                borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                    style: BorderStyle.solid
                ),
                child: new Text('返回'),
              ),
                     OutlineButton(
                       onPressed: () async {


                         //add check if link same or not, if not add new book
                         List<Map<String, dynamic>>  Bulkdatadetail=await databaseHelper.queryBookId(datadetail['bookurl']);
                         print(Bulkdatadetail.toString()+"bookdialog205");
                        if(!Bulkdatadetail.isEmpty){
                          datadetail=Bulkdatadetail[0];
                          String naviatorpage = 'bookdialog';

                          print(datadetail['id']);
                          Navigator.pop(context);
                          Navigator.push( context, new MaterialPageRoute(builder: (context) => new ReaderScene(datadetail,naviatorpage)));
                    //      Get.to(BookDisplay());
                        }else{

                          ProgressDialog.showProgress(context);


                        if(await InsetBook()) {
                          print('adddddddding book and load screan');
                          String naviatorpage = 'bookdialog';

                          List<Map<String, dynamic>>  Bulkdatadetail=await databaseHelper.queryBookId(datadetail['bookurl']);
                          datadetail=Bulkdatadetail[0];

                          ProgressDialog.dismiss(context);
                          Navigator.pop(context);
                         // Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScene(datadetail)));
                          Navigator.push( context, new MaterialPageRoute(builder: (context) => new ReaderScene(datadetail,naviatorpage)));
                        }else{print("error++++++++++++++++++");}
                       }

                          },
                       borderSide: BorderSide(
                           color: Colors.blue,
                           width: 2.0,
                           style: BorderStyle.solid
                       ),
                       child: new Text('閱讀'),
                     ),
  ]
               ),

                            ],
                          ),
                        ),
                        //SizedBox(height: 10.0),


                      ],
                    ),
                  ),
                ],
              ),

          ),
        ),
      );
  
  }




  Future<bool> InsetBook()async{
   // debugPrint(image+"imageimageimageimage");


    Uri imageUri = Uri.parse(image);

    var responseimg = await get(imageUri);
    datadetail['base64Image'] = base64Encode(responseimg.bodyBytes);
    datadetail['id']=await databaseHelper.insertbook(datadetail);
    datadetail['bookreadchapter']=0;
    print("bookdialog 244 "+bookchaptertitle.toString());
    databaseHelper.insertchapter(datadetail['id'], bookchaptertitle, bookchapterlink);



    /*
    List<Map<String, dynamic>> chaterFristId =  await  databaseHelper.queryChapterFirstId(bookId);


    print('chaterFristIdchaterFristIdchaterFristId'+chaterFristId[0].toString()+bookId.toString()+'45   ');
    // print( await db.update(table, {'bookreadchapter': chaterFristId[0]['bookchapterid']},  where: '$columnId = ?', whereArgs: [bookdbid]));
    todo
*/

    return true;
  }



}


/*
class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  const PNetworkImage(this.image, {Key key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, image) =>
          Center(child: CircularProgressIndicator()),
      errorWidget: (context, image, error) => Image.asset(
        'assets/placeholder.jpg',
        fit: BoxFit.cover,
      ),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
*/