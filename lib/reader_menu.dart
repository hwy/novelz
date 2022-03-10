import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'sqfhelper.dart';
import 'dart:async';

import 'bookshell.dart';
import 'reader/public.dart';
import 'bookdetail.dart';

class ReaderMenu extends StatefulWidget {
  final List<Chapter> chapters;
  final int articleIndex;

  final VoidCallback onTap;
  final VoidCallback onPreviousArticle;
  final VoidCallback onNextArticle;
  final void Function(Chapter chapter) onToggleChapter;
  final String naviatorpage;
  ReaderMenu({this.chapters, this.articleIndex, this.onTap, this.onPreviousArticle, this.onNextArticle, this.onToggleChapter,this.naviatorpage});

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  //var scaffoldKey = GlobalKey<ScaffoldState>();

  double progressValue;
  bool isTipVisible = false;


  // BookDetail bookDetail;
//  DatabaseHelper databaseHelper= DatabaseHelper.instance;


  //List<Map<String, dynamic>> bookDetail;


  @override
  initState() {
    super.initState();

    progressValue = this.widget.articleIndex / (this.widget.chapters.length - 1);
    animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void didUpdateWidget(ReaderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    progressValue = this.widget.articleIndex / (this.widget.chapters.length - 1);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
    });
    setState(() {
      isTipVisible = false;
    });
  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Screen.navigationBarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(color: SQColor.paper, boxShadow: Styles.borderShadow),
        height: Screen.navigationBarHeight,
        padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {

                //  print('reader_menu 92 '+chapters.toString());
                  if(this.widget.naviatorpage=='bookdialog'){
                    Navigator.pop(context);
                  }else {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => MainPage()
                    )
                    );
                  }
                },
                       child: Image.asset('lib/img/icons8-book-shelf-64.png'),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: 44,
            //     child: Image.asset('img/read_icon_voice.png'),
            ),
            Container(
              width: 44,
              //   child: Image.asset('img/read_icon_more.png'),
            ),
          ],
        ),
      ),
    );
  }

  int currentArticleIndex() {
    return ((this.widget.chapters.length - 1) * progressValue).toInt();
  }

  buildProgressTipView() {
    if (!isTipVisible) {
      return Container();
    }
    Chapter chapter = this.widget.chapters[currentArticleIndex()];

    print('reader_menu130 '+chapter.toString());
    double percentage = chapter.index / (this.widget.chapters.length - 1) * 100;
    return Container(
      decoration: BoxDecoration(color: Color(0xff00C88D), borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(chapter.title, style: TextStyle(color: Colors.black, fontSize: 16)),
          Text('${percentage.toStringAsFixed(1)}%', style: TextStyle(color: SQColor.orange, fontSize: 12)),
        ],
      ),
    );
  }

  previousArticle() {
    if (this.widget.articleIndex == 0) {
      Toast.show('已经是第一章了');
      return;
    }
    this.widget.onPreviousArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  nextArticle() {
    if (this.widget.articleIndex == this.widget.chapters.length - 1) {
      Toast.show('已经是最后一章了');
      return;
    }
    this.widget.onNextArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  buildProgressView() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: previousArticle,
            child: Container(
              padding: EdgeInsets.all(20),
              //  child: Image.asset('img/read_icon_chapter_previous.png'),
            ),
          ),
          Expanded(
            child: Slider(
              value: progressValue,
              onChanged: (double value) {
                setState(() {
                  isTipVisible = true;
                  progressValue = value;
                });
              },
              onChangeEnd: (double value) {
                Chapter chapter = this.widget.chapters[currentArticleIndex()];
                this.widget.onToggleChapter(chapter);
              },
              activeColor: SQColor.primary,
              inactiveColor: SQColor.gray,
            ),
          ),
          GestureDetector(
            onTap: nextArticle,
            child: Container(
              padding: EdgeInsets.all(20),
              //   child: Image.asset('img/read_icon_chapter_next.png'),
            ),
          )
        ],
      ),
    );
  }

  buildBottomView() {
    return Positioned(
      bottom: -(Screen.bottomSafeHeight + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          buildProgressTipView(),
          Container(
            decoration: BoxDecoration(color: SQColor.paper, boxShadow: Styles.borderShadow),
            padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
            child: Column(
              children: <Widget>[
                 // buildProgressView(),
                buildBottomMenus(),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        buildBottomItem('目錄', 'lib/img/icons8-book-shelf-64.png'),
        buildBottomItem('亮度', 'lib/img/icons8-brightness-50.png'),
        buildBottomItem('字體', 'lib/img/icons8-website-font-size-100.png'),
        buildBottomItem('設定', 'lib/img/icons8-automatic-50.png'),
      ],
    );
  }

  buildBottomItem(String title, String icon) {
    return InkWell(
      onTap: () async {  // handle your onTap here
        if(title=='目錄') {
          Scaffold.of(context).openDrawer();
          print("Container pressed"+title);

          // bookDetail.bookDetail= await LoadbookDetail(bookId.bookid);
        }else if(title=='目錄'){

        }
      },
      child : Container (

        child: Column(
          children: <Widget>[
            Image.asset(icon),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: fixedFontSize(12), color: SQColor.darkGray)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    //   buildDrawer ();
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide();
            },
            child: Container(color: Colors.transparent),
          ),
          buildTopView(context),
          buildBottomView(),
        ],
      ),
    );

  }



/*
  Future  LoadbookDetail(int bookId)async{
    // debugPrint(image+"imageimageimageimage");
     return  await databaseHelper.queryBookDetail(bookId);


    // return listItems;
  }
*/
}
