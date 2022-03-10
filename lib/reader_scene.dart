import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'mainpage.dart';
import 'sqfhelper.dart';
import 'dart:async';

import 'reader/public.dart';

import 'reader/article_provider.dart';
import 'reader/reader_utils.dart';
import 'reader/reader_config.dart';

import 'reader/reader_page_agent.dart';
import 'reader_menu.dart';
import 'reader/reader_view.dart';
import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


enum PageJumpType { stay, firstPage, lastPage }

class ReaderScene extends StatefulWidget {
  int articleId;
  //var scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> _bookDetail;
  String _naviatorpage;

  ReaderScene(this._bookDetail,this._naviatorpage ,{this.articleId});



  @override
  ReaderSceneState createState() => ReaderSceneState(_bookDetail,_naviatorpage);
}







final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class ReaderSceneState extends State<ReaderScene> with RouteAware , WidgetsBindingObserver {

  DatabaseHelper databaseHelper= DatabaseHelper.instance;

  int pageIndex = 0;
  bool isMenuVisiable = false;
  PageController pageController = PageController(keepPage: false);
  bool isLoading = false;


  Map<String, dynamic> _bookDetail;
  String _naviatorpage;
  ReaderSceneState(this._bookDetail,this._naviatorpage);


  double scrollPosition=0;
  double scrollPositionNow=0;
  double FristPagePositionMax=0;
  double PositionMaxtem=0;


  int scrolltoind=0;


  List<String> items=['讀取中',''];

  double topSafeHeight = 0;

  Article preArticle;
  Article currentArticle;
  Article nextArticle;

  List<Chapter> chapters = [];
  List<Map<String, dynamic>> listChapter;

  int articleId;

  FlutterTts flutterTts = FlutterTts();
  int temIndex=0;

  //booktitle
  final ItemScrollController ItemScrollControllerTitle = ItemScrollController();
  final ItemPositionsListener itemPositionsListenerTitle = ItemPositionsListener.create();


  var content;

  bool mode =false;

  //listView index
   var page1 = GlobalKey();

  var page2 = GlobalKey();

  Article prepage ;
  Article nextpage ;




  //scroll text
  ScrollController _scrollController = ScrollController();
  bool scroll = false;
  int speedFactor = 620;




  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;


    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }


  _toggleScrolling() async {
    if(mode) {
      setState(() {
        scroll = !scroll;
      });
      // print("reader_menu 105 maxExtent" +maxExtent.toString()+"_scrollController.offset"+_scrollController.offset.toString());

      if (scroll) {
        _scroll();
      } else {
        _scrollController.animateTo(_scrollController.offset,
            duration: Duration(seconds: 1), curve: Curves.linear);
      }
    }else{


      setState(() {
        scroll = !scroll;
      });
      // print("reader_menu 105 maxExtent" +maxExtent.toString()+"_scrollController.offset"+_scrollController.offset.toString());

      if (scroll) {

        List<dynamic> languages = await flutterTts.getLanguages;

        await flutterTts.setLanguage("yue-HK-Standard-A");

        await flutterTts.setSpeechRate(1.3);

        await flutterTts.setVolume(1.0);

        await flutterTts.setPitch(1.0);

  //print( await flutterTts.isLanguageAvailable("yue-HK-Standard-A").toString());
        var content= currentArticle.stringAtPageIndex(pageIndex);


        while(scroll) {

          await _speak(content);
          await nextPage();
          print("content pageIndex 170 "+ pageIndex.toString());
          content = currentArticle.stringAtPageIndex(pageIndex);

        }
      } else {
        _stop();
      }

    }

  }




  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor, zIndex:2, name:"SomeName");
    pageIndex=_bookDetail['bookreadchaptepage'];
    pageController = PageController(initialPage: pageIndex);
    WidgetsBinding.instance.addObserver(this);

    pageController.addListener(onScroll);
//debugPrint(articleId.toString()+"   ");

    // pageController.jumpToPage(pageIndex);
    _scrollController = ScrollController(initialScrollOffset: _bookDetail['booScrollposition'])..addListener(() async {
      scrollPositionNow=_scrollController.position.pixels;


      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          await _loadMorePrev();
        } else {
          await _loadMoreNext();
        }
      }
    });


   // print("reader_scene 141"+_bookDetail['booScrollposition'].toString()+"'_bookDetail['booScrollposition']_bookDetail['booScrollposition']'");
    setup();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    routeObserver.subscribe(this, ModalRoute.of(context));
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        SaveReadPage();
        break;
      case AppLifecycleState.paused:
        SaveReadPage();
        break;
      case AppLifecycleState.detached:
      //await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
      // await resumeCallBack();
        break;
    }
    print (state.toString()+"_lastLifecycleState_lastLifecycleState");
  }


  @override
  void didPop() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
   // SaveReadPage();

    BackButtonInterceptor.removeByName("SomeName");

    super.dispose();

    pageController.dispose();
    routeObserver.unsubscribe(this);
    _scrollController.dispose();

    WidgetsBinding.instance.removeObserver(this);
    print('dispose');
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
 //   Catalog.catalogPageKey.currentState;
    print('reader_secene'+_naviatorpage);
    SaveReadPage();

    if(_naviatorpage=='bookdialog'){
      Navigator.pop(context);
    }else {

      Navigator.pushReplacement(context,new MaterialPageRoute(
          builder: (context) => new MainPage()
      )
      );
    }
    return true;
  }



  void setup() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    topSafeHeight = Screen.topSafeHeight;
/*
    List<dynamic> chaptersResponse = await Request.get(action: 'catalog');
    chaptersResponse.forEach((data) {
      chapters.add(Chapter.fromJson(data));
    });
*/
    listChapter= await LoadChapter(_bookDetail['id']);
//print(_bookDetail['id'].toString()+"sssseettttttuuupppp"+listChapter.toString());

  //  debugPrint ('_bookDetail[bookreadchaptepage]'+_bookDetail['bookreadchaptepage'].toString()+"no??");


    if(_bookDetail['bookreadchapter']==0) {
      articleId =listChapter[0]['bookchapterid'];

    } else {
      articleId = _bookDetail['bookreadchapter'];
      //  debugPrint ('_bobookreadchapterbookreadchapterbookreadcokDetail[bookreadchaptepage]'+listChapter[0]['bookreadchaptepage'].toString()+"no??");
    }



    await resetContent(articleId, PageJumpType.stay);
  }

  resetContent(int articleId, PageJumpType jumpType) async {
    currentArticle = await fetchArticle(articleId);

   // print("reader_scene 253 totalpage "+currentArticle.pageCount.toString());


    if (currentArticle.preArticleId > 0) {
      preArticle = await fetchArticle(currentArticle.preArticleId);
    } else {
      preArticle = null;
    }
    if (currentArticle.nextArticleId > 0) {
      nextArticle = await fetchArticle(currentArticle.nextArticleId);
    } else {
      nextArticle = null;
    }
    if (jumpType == PageJumpType.firstPage) {
      pageIndex = 0;

      print("PageJumpType.firstPage"+pageIndex.toString());

    } else if (jumpType == PageJumpType.lastPage) {
      pageIndex = currentArticle.pageCount - 1;
      print("PageJumpType.lastPage"+pageIndex.toString());

    }


    if(jumpType == PageJumpType.stay) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage((preArticle != null ? preArticle.pageCount : 0) + pageIndex);

        }
      });
    }
    if (jumpType != PageJumpType.stay) {
      // print("PageJumpType.stayssssssssss"+preArticle.pageCount.toString());
      pageController.jumpToPage((preArticle != null ? preArticle.pageCount : 0) + pageIndex);
    }


    setState(() {});
  }

  onScroll() {
    var page = pageController.offset / Screen.width;

   // print ("onScroll 366"+ page.toString());

    var nextArtilePage = currentArticle.pageCount + (preArticle != null ? preArticle.pageCount : 0);
    if (page >= nextArtilePage) {
      print('到逹下章節');

      preArticle = currentArticle;
      currentArticle = nextArticle;
      nextArticle = null;
      pageIndex = 0;
      pageController.jumpToPage(preArticle.pageCount);
      fetchNextArticle(currentArticle.nextArticleId);
      setState(() {});
    }
    if (preArticle != null && page <= preArticle.pageCount - 1) {
      print('到逹上章節');

      nextArticle = currentArticle;
      currentArticle = preArticle;
      preArticle = null;
      pageIndex = currentArticle.pageCount - 1;
      pageController.jumpToPage(currentArticle.pageCount - 1);
      fetchPreviousArticle(currentArticle.preArticleId);
      setState(() {});
    }
  }

  fetchPreviousArticle(int articleId) async {
    if (preArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    preArticle = await fetchArticle(articleId);
    pageController.jumpToPage(preArticle.pageCount + pageIndex);
    isLoading = false;
    setState(() {});
  }

  fetchNextArticle(int articleId) async {
    if (nextArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    nextArticle = await fetchArticle(articleId);
    isLoading = false;
    setState(() {});
  }

  Future<Article> fetchArticle(int articleId) async {
    var article = await ArticleProvider.fetchArticle(articleId,_bookDetail['id']);
    var contentHeight = Screen.height - topSafeHeight - ReaderUtils.topOffset - Screen.bottomSafeHeight - ReaderUtils.bottomOffset - 20;
    var contentWidth = Screen.width - 15 - 10;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(article.content, contentHeight, contentWidth, ReaderConfig.instance.fontSize);

    return article;
  }

  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
      setState(() {
        isMenuVisiable = true;
      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  onPageChanged(int index) {


/*
  if(temIndex>index) {
    var nextArtilePage = currentArticle.pageCount +
        (preArticle != null ? preArticle.pageCount : 0);
    if (pageIndex >= nextArtilePage) {
      pageIndex = 0;
    } else {
      pageIndex++;
    }
    print("nextPage 472 " + pageIndex.toString());
  }else if(temIndex<index) {
    if (preArticle != null && pageIndex <= preArticle.pageCount - 1) {
      pageIndex = currentArticle.pageCount - 1;
    } else {
      pageIndex--;
    }
  }
    var page = index - (preArticle != null ? preArticle.pageCount : 0);


   if (page < currentArticle.pageCount && page >= 0) {
      setState(() {
        pageIndex = page;
        //   databaseHelper.updateBookReadChapterPage(_bookDetail['id'],currentArticle.novelId,pageIndex);

      });
    }*/
  }

  previousPage() {
    if (pageIndex == 0 && currentArticle.preArticleId == 0) {
      Toast.show('已經是第一頁');
      return;
    }

     pageController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  nextPage() async{
    if (pageIndex >= currentArticle.pageCount - 1 && currentArticle.nextArticleId == 0) {
      Toast.show('這是最後一頁');
      return;
    }

    await pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Widget buildPage(BuildContext context, int index)  {
   var  pagebuildPage = index - (preArticle != null ? preArticle.pageCount : 0);
   var articlebuildPage;

    if (pagebuildPage >= this.currentArticle.pageCount) {
      // 到达下一章了
      articlebuildPage = nextArticle;
      pagebuildPage = 0;
      // databaseHelper.updateBookReadChapterPage(_bookDetail['id'],currentArticle.novelId,page);
    } else if (pagebuildPage < 0) {
      // 到达上一章了
      articlebuildPage = preArticle;
      pagebuildPage = preArticle.pageCount - 1;
      // databaseHelper.updateBookReadChapterPage(_bookDetail['id'],currentArticle.novelId,page);
    } else {
      articlebuildPage = this.currentArticle;
      //   databaseHelper.updateBookReadChapterPage(_bookDetail['id'],currentArticle.novelId,page);
    }
    pageIndex= pagebuildPage;
print("pageIndex 507 "+ pageIndex.toString());

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);

      },
      child: ReaderView(article: articlebuildPage, page: pagebuildPage, topSafeHeight: topSafeHeight),
    );


  }

  buildPageView() {
    if (currentArticle == null) {
      print('currentArticle == null');

      return Container();
    }


    int itemCount = (preArticle != null ? preArticle.pageCount : 0) + currentArticle.pageCount + (nextArticle != null ? nextArticle.pageCount : 0);
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,

    );


  }



  buildScrollPage(){
    if (currentArticle == null) {
      print('currentArticle == null');

      return Container();
    }

    content =  currentArticle.content;
    if (content.startsWith('\n')) {
      content = content.substring(1);
    }

    return   Container(

      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(15, topSafeHeight + ReaderUtils.topOffset, 10, Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
      child:  SingleChildScrollView(
    //  scrollDirection: Axis.vertical,
      controller: _scrollController,


      child: IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Container(

                key: page1,


                child: Center(child: Text.rich(


        TextSpan(children: [TextSpan(text: items[0], style: TextStyle(fontSize: fixedFontSize(ReaderConfig.instance.fontSize)))]),
        textAlign: TextAlign.justify,
      ),)),

            Expanded(
              // A flexible child that will grow to fit the viewport but
              // still be at least as big as necessary to fit its contents.
              child: Container(
                  key: page2,

                  child: Center(child: Text.rich(


                    TextSpan(children: [TextSpan(text: items[1], style: TextStyle(fontSize: fixedFontSize(ReaderConfig.instance.fontSize)))]),
                    textAlign: TextAlign.justify,
                  ),)),
              ),

          ],
        ),
      ),
    ),
    );







  }

  Future<bool> _loadMorePrev() async {

    // print("reader_scene-494 scrollPosition FristPagePositionMax " + FristPagePositionMax.toString() + "scrollPositionNow " +scrollPositionNow.toString());
   // await Future.delayed(Duration(seconds: 0, milliseconds: 100));



    currentArticle= prepage;

    if( currentArticle.preArticleId == 0) {

      Toast.show('已經是第一頁');

    } else {
      //  scrolltoind--;
      preArticle = await fetchArticle(currentArticle.preArticleId);

  print("preArticle.novelId "+preArticle.novelId.toString()+ "articleID "+ articleId.toString() );
      if (preArticle.id != _bookDetail['id']) {
        Toast.show('已經是第一頁');
      } else {
        if (currentArticle.index != 0) {
          setState(() {
            prepage = preArticle;
            nextpage = currentArticle;


            print(
                "reader_scene-517 scrollPosition currentArticle.preArticleId " +
                    currentArticle.preArticleId.toString());


            items[0] = preArticle.content;

            items[1] = currentArticle.content;


            //      items.addAll(List.generate(1, (v) => currentArticle.content));
            //     print("data count = ${items.length}");

          });


          //print("reader_scene-517 scrollPosition SecondScrollPositionMax " + SecondScrollPositionMax.toString() + "FirstScrollPositionMax " +FirstScrollPositionMax.toString());

          // _scrollController.jumpTo(SecondScrollPositionMax);


          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.position.ensureVisible(
                page2.currentContext.findRenderObject(),
                alignment: 0, // How far into view the item should be scrolled (between 0 and 1).

              );
            }
          });
        } else {
          //    scrolltoind++;
          setState(() {
            items.addAll(List.generate(1, (v) => '伺服器/或連線出現問題,重試中'));
          });
          // await Future.delayed(Duration(seconds: 5, milliseconds: 100));
        }
      }
    }

    // load();
    return true;
  }



  Future<bool> _loadMoreNext() async {
  //   await Future.delayed(Duration(seconds: 0, milliseconds: 100));


    currentArticle= nextpage;

    if(currentArticle.nextArticleId<=0) {

      Toast.show('已經是最後一頁');
    }else{
      //scrolltoind++;

      nextArticle= await fetchArticle(currentArticle.nextArticleId);



      if(currentArticle.index!=0 ) {
        setState(() {


          prepage =currentArticle;
          nextpage =nextArticle;


          print("reader_scene-517 scrollPosition currentArticle.preArticleId " + currentArticle.preArticleId.toString() );


          items[0]=currentArticle.content;

          items[1]=nextArticle.content;


        //      items.addAll(List.generate(1, (v) => currentArticle.content));
   //     print("data count = ${items.length}");

      });


      //print("reader_scene-517 scrollPosition SecondScrollPositionMax " + SecondScrollPositionMax.toString() + "FirstScrollPositionMax " +FirstScrollPositionMax.toString());

     // _scrollController.jumpTo(SecondScrollPositionMax);


      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(_scrollController.hasClients){
      _scrollController.position.ensureVisible(
        page1.currentContext.findRenderObject(),
        alignment: 1, // How far into view the item should be scrolled (between 0 and 1).

      ); }
      });


    }else {
   //   scrolltoind--;
      setState(() {
        items.addAll(List.generate(1, (v) => '伺服器/或連線出現問題,重試中'));
      });
     // await Future.delayed(Duration(seconds: 5, milliseconds: 100));

    }

    }

    // load();
    return true;
  }



  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }
    return ReaderMenu(
      chapters: chapters,
      articleIndex: currentArticle.index,
      onTap: hideMenu,
      onPreviousArticle: () {
        resetContent(currentArticle.preArticleId, PageJumpType.firstPage);
      },
      onNextArticle: () {
        resetContent(currentArticle.nextArticleId, PageJumpType.firstPage);
      },
      onToggleChapter: (Chapter chapter) {
        resetContent(chapter.id, PageJumpType.firstPage);
      },
      naviatorpage:_naviatorpage,
    );
  }

  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      this.isMenuVisiable = false;
    });
  }

  @override
  Widget build(BuildContext context) {



    if (currentArticle == null || chapters == null) {
      return Scaffold();
    }


    //future: LoadChapter(_bookDetail['id']),
    if(mode) {


      if (currentArticle == null) {
        print('currentArticle == null');

        return Container();
      }

      if(items[0]=='讀取中') {

        prepage =currentArticle;
        nextpage =currentArticle;
        items[0]=currentArticle.content;
      }

      return Scaffold(

        body: NotificationListener(
          onNotification: (notif) {
            if (notif is ScrollEndNotification && scroll) {
              Timer(Duration(seconds: 1), () {
                _scroll();
              });

              //List scroll position
              print(notif.metrics.pixels);
              print(_scrollController.offset);

            }

            return true;
          },

          child: GestureDetector(

            onTap: () async{
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
              setState(() {
                isMenuVisiable = true;
                print(isMenuVisiable);
              });



            }, // handle your onTap here

            child: Stack(
              children: <Widget>[


                buildScrollPage(),

                buildMenu(),
              ],


            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          _toggleScrolling();

        }   ,
        backgroundColor: Colors.blueGrey.withOpacity(0.1),
      ), // This trailing comma makes auto-formatting nicer for build methods.
        drawer: buildDrawer(),

      );

    }else{


      return Scaffold(

        body: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Stack(
            children: <Widget>[
              /* Positioned(left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                 // to do  child: Image.asset('lib/img/icons8-book-shelf-64.png', fit: BoxFit.cover)
                ),*/
              buildPageView(),
              buildMenu(),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          _toggleScrolling();
        }), drawer: buildDrawer(),


      );
    }



  }// end build



  buildDrawer (){
    debugPrint(listChapter.length.toString());


    if(articleId!=0 && articleId!=null&&scrolltoind==0) {

      scrolltoind= listChapter.indexWhere((note) => note.containsValue(articleId));

    }

    if(scrolltoind<0){
      scrolltoind=0;
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
                accountName: Text(_bookDetail['bookname']),
                accountEmail: Text('更新 :'+_bookDetail['bookupdate']),



                currentAccountPicture:       Container(
                  decoration: BoxDecoration(
                    color:  Color(0xff7c94b6),
                    image:  DecorationImage(
                      image: MemoryImage(base64Decode(_bookDetail['bookphoto'])),
                      fit: BoxFit.cover,
                    ),

                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              // child: Image.memory( base64Decode(_bookDetail['bookphoto'])),
            ),
          ),



          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Expanded(



              child: ScrollablePositionedList.builder(
                itemCount: listChapter == null ? 0 : listChapter.length,
                itemScrollController: ItemScrollControllerTitle,initialScrollIndex:scrolltoind,
                itemPositionsListener: itemPositionsListenerTitle,
                itemBuilder: (ctx, i) {

                  // debugPrint(i.toString()+'432432443iiiiiiii');
                  return Column(
                      children: <Widget>[
                        ListTile(
                          // leading: Icon(listChapter[i]['icon']),
                            title: Text(
                              listChapter[i]['bookchaptertitle'],
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),



                            onTap: () async {

                              scrolltoind=i;
                              ItemScrollControllerTitle.jumpTo(index: scrolltoind);

                           //   print(listChapter[i]['bookchapterid'].toString()+"listChapter[i]['bookchapteri']listChapter[i]['bookchapteri']listChapter[i]['bookchapteri']");

                              if(mode) {
                                currentArticle = await fetchArticle(listChapter[i]['bookchapterid']);
                                items.clear();

                                items=['沒有資料',''];


                                if (currentArticle == null) {
                                  print('currentArticle == null');

                                  return Container();
                                }
                                prepage =currentArticle;
                                nextpage =currentArticle;
                                items[0]=currentArticle.content;
                                items[1]='';


                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if(_scrollController.hasClients){
                                    _scrollController.position.ensureVisible(
                                      page1.currentContext.findRenderObject(),
                                      alignment: 0.0001, // How far into view the item should be scrolled (between 0 and 1).

                                    ); }
                                });

                              }else{
                                await resetContent(listChapter[i]['bookchapterid'], PageJumpType.firstPage);
                              }
                              Navigator.pop(context) ;
                            }






                        ),

                        Divider(), //                           <-- Divider

                      ]
                  );
                },
              ),
            ),
          )
        ],
      ),
    );

  }





  Future   <List<Map<String, dynamic>>> LoadChapter(int bookId)async{
    // debugPrint(image+"imageimageimageimage");
    return listChapter=  await databaseHelper.queryAllChapter(bookId);


    // return listItems;
  }



  SaveReadPage()  {
    double scrollPositionResetPosition=0;

  //  print("Reader_scenec 804 PrevscrollPositionMax "+PrevscrollPositionMax.toString()+" CurrentscrollPositionMax "+CurrentscrollPositionMax.toString());

    int noveId=currentArticle.novelId;





    if(mode) {

      FristPagePositionMax=_getWidgetInfo();

      if(scrollPositionNow>FristPagePositionMax){
        scrollPositionResetPosition=scrollPositionNow-FristPagePositionMax;
        noveId=nextArticle.novelId;
        print('reader_scene scronllview 973 scrollPositionResetPosition'+scrollPositionResetPosition.toString()+'scrollPositionNow' +scrollPositionNow.toString());

      }else{
        scrollPositionResetPosition=scrollPositionNow;
      }
      print('reader_scene scronllview 820 FristPagePositionMax'+FristPagePositionMax.toString()+'scrollPositionNow' +scrollPositionNow.toString());

      pageIndex=(currentArticle.pageCount/FristPagePositionMax*scrollPositionResetPosition).toInt();
    }else{
      scrollPositionResetPosition=FristPagePositionMax/currentArticle.pageCount*pageIndex;
    }


   print("reader_scene 930 "+scrollPositionResetPosition.toString()+'scrollPositionReset');
    databaseHelper.updateBookReadChapterPage(_bookDetail['id'],noveId,pageIndex,scrollPositionResetPosition);
  }

  Future<void> _speak(String _text) async {
    if (_text != null && _text.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);

      await flutterTts.speak(_text);


    }
  }


  Future _stop() async {
    var result = await flutterTts.stop();
    //if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  readAllSentencesList(List<String> allSentences) async {
    for (int i=0; i<allSentences.length; i++){
      await _speak(allSentences[i]);
    }
  }

  double _getWidgetInfo() {
    final RenderBox renderBox = page1.currentContext?.findRenderObject() as RenderBox;

    final Size size = renderBox.size; // or _widgetKey.currentContext?.size
    print('Size: ${size.width}, ${size.height}');

    return size.height;
  }

  }
