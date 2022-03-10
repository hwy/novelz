import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
//import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';
import 'package:html/parser.dart';
import 'dart:ui';
import 'bookdialog.dart';
import 'connectnet.dart';
import 'loadingdialog.dart';
import 'dart:convert';

/*
void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '搜索',
      theme: ThemeData.light(),
      home: SearchPage(),
    );
  }
}
*/



class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  var seachlink;
  var clicklink;
  Map<String, dynamic> datadetail = new Map();
  final controller = TextEditingController();

  List bookchaptertitle =[] ;
  List bookchapterlink=[] ;



  List<BookResult>  listsearchbookresult =  new List<BookResult>.generate(1, (i) {
    return BookResult(
      bookname:"武煉巔峰",
      booklink: "https://czbooks.net/n/u6ei",
      bookdesc: "武之巔峰，是孤獨，是寂寞，是漫漫求索，是高處不勝寒逆境中成長，絕地裡求生，不屈不饒，才能堪破武之極道。凌霄閣試煉弟子兼掃地小廝楊開偶獲一本無字黑書，從此踏上漫漫武道。",
      bookimage: "https://img.uukanshu.com/fengmian/2012/10/634865275395707500.jpg",
    );

  });

  String searchbook ="";
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
         color: Theme.of(context).primaryColor,
        child: Column(
            children: <Widget> [
         Padding(
          padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top,),
          child: Container(
            height: 50.0,
            child: new Padding(
                padding: const EdgeInsets.all(1.0),
                child: new Card(
                    child: new Container(
                      child: new Row(
                        children: <Widget>[
                          SizedBox(width: 5.0,),
                          Icon(Icons.search, color: Colors.grey,),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: controller,
                                decoration: new InputDecoration(
                                  //  contentPadding: EdgeInsets.only(top: 1.1),
                                    hintText: '請輸入書名', border: InputBorder.none),
                                //  onChanged: onSearchTextChanged(),
                                onSubmitted: (text) async {//内容提交(按回车)的回调
                                  print('submit $text');
                                  searchbook=text;
                                  getNet();

                                },
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              controller.clear();
                              // onSearchTextChanged();
                            },
                          ),
                        ],
                      ),
                    )
                )
            ),
          ),
        ),

    Expanded(
    child: Container(
                color: Theme.of(context).backgroundColor,

                child: ListView.builder(
    itemCount: listsearchbookresult.length,
    itemBuilder: (context, index) {
    return ListTile( //                           <-- Card widget


      title:Container(
        height: 150,
        child: Card(
          color: Colors.blue,
          child: Row(
            children: [
              Expanded(
                flex: 34,
                child: Image.network(
                  listsearchbookresult[index].bookimage,
                ),
              ),
              Expanded(
                flex: 66,
                child: Column(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Center(child: Text('${listsearchbookresult[index].bookname.toString()}')),
                    ),
                    Expanded(flex: 70, child: Text('${listsearchbookresult[index].bookdesc.toString().replaceAll(' ', '')}')),
                    Expanded(flex: 20, child: Text('${listsearchbookresult[index].bookdate.toString()}')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
     //   debugPrint(listsearchbookresult[index].booklink.toString()+'34343343434343');
      onTap: () => onTapped(listsearchbookresult[index].booklink),
    //  subtitle: Text('${listsearchbookresult[index].bookdesc.toString().replaceAll(' ', '')}',), onTap: () => onTapped(listsearchbookresult[index].booklink),
      );
    

    },
    ),
    ),
              ),
  ],
        ),
      ),
    );
  }


  void onTapped(String booklink)async {
    clicklink=booklink;

    await getNetBookdetail();
    //datadetail =await getNetBookdetail();

    if (datadetail['bookname']!=null) {

    showDialog(
      context: context,

      builder: (_) => BookDialog(datadetail: datadetail,bookchaptertitle:bookchaptertitle,bookchapterlink:bookchapterlink),
    ); // navigate to the next screen
    // .
  }
  }

  Future  getNetBookdetail() async {
    //  searchbook = await ChineseConverter.convert(searchbook, T2S());
    //var seargbk ='武炼巅峰';
    ProgressDialog.showProgress(context);

    var url = clicklink;

    Dio dio = new Dio();
    print(url);
    //   Transformer.transformRequest();

    dio.options.connectTimeout = 5 * 1000;
    dio.options.sendTimeout = 5 * 1000;
    dio.options.receiveTimeout = 3 * 1000;
    dio.options.headers = {
      HttpHeaders.acceptHeader: "application/json;charset=big5"
    };
 //   var response = await dio.get(url, options: Options(responseDecoder: gbkDecoder),);

    var response = await dio.get(url);


    var document = parse(response.data.toString());
    //  var element =parse( document.getElementsByClassName('lists'));
    image = document.getElementsByTagName("img")[0].attributes['src'];

    debugPrint(document.toString()+'444444');

 //   var element =document.getElementsByClassName('bookinfo')[0].querySelectorAll('p');
    var elementchapter =document.getElementById('chapter-list');
   // debugPrint(elementchapter.text+'444444');

    var chapterlink=  elementchapter.querySelectorAll('a');


    List bookchapterlinktemp=[];
    List bookchaptertitletemp=[];

  //  debugPrint(chapterlink.length.toString()+'+chapterlink');
    var i;
    for (i = 0; i < chapterlink.length; ++i) {
      bookchapterlinktemp.add('http:'+chapterlink[i].attributes['href']);
      bookchaptertitletemp.add(chapterlink[i].innerHtml);
     
    // print("search230"+bookchaptertitle[i]);
    }

    bookchapterlink = bookchapterlinktemp;
    bookchaptertitle=bookchaptertitletemp;


 //   var responseimg = await get(image);


   // String base64Image = base64Encode(responseimg.bodyBytes);

    var elementbook=  document.getElementsByClassName('novel-detail')[0];

  //  print(base64Image);

/*
    var www.biquge.com.cn = element.querySelectorAll('a');
    var parentNew = element.getElementsByClassName('intro');
*/
    datadetail['bookname'] = elementbook.getElementsByClassName('title')[0].innerHtml.replaceAll(' ', '');
    datadetail['bookphoto'] = image;
    datadetail['bookauthor'] = elementbook.getElementsByClassName('author')[0].querySelector('a').innerHtml.replaceAll(' ', '').replaceAll('&nbsp;', '');
    datadetail['booktype'] = 'booktype';//document.getElementsByClassName('bookinfo')[0].querySelectorAll('p')[1].text.replaceAll(' ', '');
    datadetail['booktotalwording'] = 'booktotalwording';//document.getElementsByClassName('bookinfo')[0].querySelectorAll('p')[3].text.replaceAll(' ', '');
    datadetail['bookdesc'] = elementbook.getElementsByClassName('description')[0].text.replaceAll(' ', '');
    datadetail['booklastupdatetitle'] =  'booklastupdatetitle';//document.getElementById('info').querySelectorAll('p')[3].text;
    datadetail['bookupdate'] = 'bookupdate' ;//document.getElementById('info').querySelectorAll('p')[2].innerHtml.replaceAll(' ', '');
    datadetail['bookurl'] = url;
    //datadetail['bookbase64Image']  = base64Encode(responseimg.bodyBytes);

   
    ProgressDialog.dismiss(context);

  //  return  datadetail;
  }


  void getNet() async {
    ProgressDialog.showProgress(context);

    //  searchbook = await ChineseConverter.convert(searchbook, T2S());
   var seargbk ='武';

  //   seargbk =await ChineseConverter.convert(seargbk, T2S());

    //seargbk =urlEncode.encode(seargbk);

    var url ="https://czbooks.net/s/$seargbk?q=$seargbk"; //深圳
    // var url ="http://www.shuquge.com/search.php?searchkey=$searchbook"; //深圳
    Dio dio = new Dio();
    print(url);
    //   Transformer.transformRequest();

    dio.options.connectTimeout = 5 * 1000;
    dio.options.sendTimeout = 5 * 1000;
    dio.options.receiveTimeout = 3 * 1000;
    dio.options.headers = {HttpHeaders.acceptHeader:"application/json;charset=big5"};


   // var response = await dio.get(url, options: Options(responseDecoder: gbkDecoder),);
    var response = await dio.get(url);

   // debugPrint(response.data.toString()+"222222222222222");

    var document = parse(response.data.toString());
    //  var element =parse( document.getElementsByClassName('lists'));
    var element =document.getElementsByClassName('nav novel-list style-default')[0];

   // debugPrint(element.outerHtml+"eleleleleleleleemeelmele");

    var parentLinkName = element.getElementsByClassName('novel-item');
    var parentNew = element.getElementsByClassName('novel-item-newest-chapter');
    var parentUpdate = element.getElementsByClassName('novel-item-author');

    var parentimage = document.getElementsByTagName("img");

    debugPrint(parentLinkName.toString()+"121321");
    var i;
   listsearchbookresult.clear();
    //透過資料產生器，產生資料
    listsearchbookresult = new List<BookResult>.generate(parentLinkName.length, (i) {
     // debugPrint(parentLinkName[i].getElementsByTagName('a')[0].text+"parentNewparentNew"+"  "+parentLinkName.length.toString());

      return BookResult(
        bookname: parentLinkName[i].getElementsByTagName('a')[0].text.trim(),
        booklink: "https:"+parentLinkName[i].getElementsByTagName('a')[0].attributes['href'].toString(),
        bookdesc: "簡介:"+parentNew[i].text,
        bookimage: parentimage[i].attributes['src'],
        bookdate: '作者:'+parentUpdate[i].getElementsByTagName('a')[0].text.trim(),
      ); // debugPrint(i.toString());

    }
    );



  //  debugPrint(listsearchbookresult[3].bookdesc.toString()+"listsearchbookresult");

    ProgressDialog.dismiss(context);

  setState(() {});
  }



}

//https://m.hunhun520.com/novel.php?action=search&searchtype=novelname&searchkey=%E4%B9%A6%E5%BA%93










const httpHeaders={
  'Accept': 'application/json, text/plain, */*',
  'Authorization': '666',
  'Content-Type': 'application/json;charset=gbk',
  'Origin': 'http://localhost:8080',
  'Referer': 'http://localhost:8080/',
  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
};

/*
String gbkDecoder (List<int> responseBytes, RequestOptions options, ResponseBody responseBody) {  //gbk to utf8

  String result =  gbk.decode(responseBytes);
  return result;
}
*/



//產品資料
class BookResult {
  final String bookname;
  final String booklink;
  final String bookdesc;
  final String bookimage;
  final String bookdate;
  final String id;

  BookResult({this.bookname, this.booklink,this.bookdesc,this.bookimage,this.bookdate,this.id});
}

/*
//產品資料
class BookResultDetail {
  final String bookname;
  final String bookphoto;
  final String bookauthor;
  final String booktype;
  final String booktotalwording;
  final String bookdesc;
  final String booklastupdatetitle;
  final String booklastupdatedate;
  final String bookbase64Image;


  BookResultDetail(
      {this.bookname,
        this.bookphoto,
        this.bookauthor,
        this.booktype,
        this.booktotalwording,
        this.bookdesc,
        this.booklastupdatetitle,
        this.booklastupdatedate,
        this.bookbase64Image,
        });
}
*/